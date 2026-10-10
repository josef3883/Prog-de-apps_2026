import { chromium } from '../.qa-tools/node_modules/playwright/index.mjs'
import { writeFile } from 'node:fs/promises'

// Harness de QA: requiere Chrome y preview en 127.0.0.1:4173. Las aserciones lanzan
// errores ante fallos; finally cierra Chrome. Datos/capturas se guardan en .qa-tools.
// Los callbacks evaluate miden frames o inspeccionan DOM; no ejecutan negocio propio.
const browser = await chromium.launch({ channel: 'chrome', headless: true })
try {
  const context = await browser.newContext({ viewport: { width: 1280, height: 960 } })
  const page = await context.newPage()
  const errores = []
  page.on('pageerror', error => errores.push(error.message))
  await page.goto('http://127.0.0.1:4173/', { waitUntil: 'networkidle' })
  const resultados = []
  for (const [monto, personas, propina, modo, esperado] of [
    ['100.00','4','10','exacto','27.50 por persona'],
    ['90.00','3','0','exacto','30.00 por persona'],
    ['10.00','3','0','exacto','3.33 por persona'],
    ['10.00','3','0','hacia-arriba','4.00 por persona'],
    ['50.00','0','0','exacto','Debe haber al menos una persona'],
    ['abc','4','0','exacto','Monto inválido'],
    ['10','-0.5','0','exacto','Debe haber al menos una persona'],
  ]) {
    await page.getByLabel('Monto total').fill(monto)
    await page.getByLabel('Número de personas').fill(personas)
    await page.getByLabel('Propina (%)').fill(propina)
    await page.getByLabel('Cómo repartir').selectOption(modo)
    const ms = await page.evaluate(async () => {
      const inicio = performance.now()
      document.querySelector('button[type="submit"]').click()
      await new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)))
      return performance.now() - inicio
    })
    const salida = await page.locator(esperado.includes('por persona') ? 'output' : '[role="alert"]').innerText()
    const normalizado = salida.replace(/\s+/g, ' ').trim()
    if (normalizado !== esperado) throw new Error(`${normalizado} != ${esperado}`)
    if (!esperado.includes('por persona') && await page.locator('output').count()) throw new Error('Resultado visible junto al error')
    if (ms >= 1000) throw new Error(`Resultado tardío: ${ms} ms`)
    resultados.push({ monto, personas, propina, modo, esperado, ms })
  }
  await page.evaluate(() => {
    globalThis.escriturasCuenta = 0
    const prohibido = () => { globalThis.escriturasCuenta++; throw new Error('Persistencia inesperada') }
    for (const metodo of ['setItem','removeItem','clear']) Storage.prototype[metodo] = prohibido
    indexedDB.open = prohibido
    indexedDB.deleteDatabase = prohibido
    Object.defineProperty(document, 'cookie', { configurable: true, get: () => '', set: prohibido })
  })
  const solicitudes = []
  page.on('request', request => solicitudes.push(request.url()))
  await context.setOffline(true)
  for (const [modo, esperado] of [['exacto', '3.33 por persona'], ['hacia-arriba', '4.00 por persona']]) {
    await page.getByLabel('Monto total').fill('10')
    await page.getByLabel('Número de personas').fill('3')
    await page.getByLabel('Propina (%)').fill('0')
    await page.getByLabel('Cómo repartir').selectOption(modo)
    await page.getByRole('button', { name: /Calcular/ }).click()
    const salida = (await page.locator('output').innerText()).replace(/\s+/g,' ').trim()
    if (salida !== esperado) throw new Error(`Offline: ${salida}`)
    resultados.push({ offline: true, modo, esperado })
  }
  if (solicitudes.length) throw new Error(`Solicitudes durante offline: ${solicitudes.join(',')}`)
  const almacenamiento = await page.evaluate(() => ({ escrituras: globalThis.escriturasCuenta, local: localStorage.length, session: sessionStorage.length }))
  if (almacenamiento.escrituras || almacenamiento.local || almacenamiento.session || (await context.cookies()).length) throw new Error('Datos persistidos')
  await page.screenshot({ path: '.qa-tools/escritorio.png', fullPage: true })
  await page.setViewportSize({ width: 375, height: 812 })
  const desborde = await page.evaluate(() => document.documentElement.scrollWidth > innerWidth)
  if (desborde) throw new Error('Desbordamiento horizontal móvil')
  await page.screenshot({ path: '.qa-tools/movil.png', fullPage: true })
  if (errores.length) throw new Error(errores.join('\n'))
  const informe = { navegador: await browser.version(), agente: await page.evaluate(() => navigator.userAgent), plataforma: process.platform, resultados, solicitudesOffline: solicitudes.length, almacenamiento, errores, movilSinDesborde: true }
  await writeFile('.qa-tools/resultados.json', JSON.stringify(informe, null, 2))
  console.log(JSON.stringify(informe, null, 2))
} finally {
  await browser.close()
}

