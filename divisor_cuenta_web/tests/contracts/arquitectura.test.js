import { readFileSync, readdirSync } from 'node:fs'
import { resolve, relative, dirname } from 'node:path'
import { expect, it } from 'vitest'

const raiz = resolve('src')
/** Inventaría módulos productivos para comprobar todas sus dependencias, no solo un ejemplo. */
function archivos(directorio) {
  return readdirSync(directorio, { withFileTypes: true }).flatMap((entrada) => {
    const ruta = resolve(directorio, entrada.name)
    return entrada.isDirectory() ? archivos(ruta) : /\.[jt]sx?$/.test(ruta) ? [ruta] : []
  })
}

it('respeta las fronteras de capas y el punto único de composición', () => {
  for (const archivo of archivos(raiz)) {
    const ruta = relative(raiz, archivo).replaceAll('\\', '/')
    const fuente = readFileSync(archivo, 'utf8').replace(/\/\*[\s\S]*?\*\//g, '').replace(/^\s*\/\/.*$/gm, '')
    const imports = [...fuente.matchAll(/(?:\bfrom\s*|\bimport\s*\(?\s*)['"]([^'"]+)['"]/g)].map((m) => m[1])
    for (const destino of imports) {
      const resuelto = destino.startsWith('.') ? relative(raiz, resolve(dirname(archivo), destino)).replaceAll('\\', '/') : destino
      expect(destino, ruta).not.toMatch(/^https?:/)
      if (ruta.startsWith('domain/')) {
        expect(resuelto, ruta).not.toMatch(/^(react|react-dom|data\/|presentation\/)/)
      }
      if (ruta.startsWith('presentation/')) expect(resuelto, ruta).not.toMatch(/^data\//)
      if (ruta.startsWith('data/')) expect(resuelto, ruta).not.toMatch(/^(react|react-dom|presentation\/)/)
      if (resuelto.startsWith('data/') && !ruta.startsWith('data/')) expect(ruta).toBe('main.jsx')
    }
    if (ruta.startsWith('domain/')) expect(fuente, ruta).not.toMatch(/\b(document|window|HTMLElement|navigator|localStorage|indexedDB)\b/)
    if (ruta !== 'main.jsx') expect(fuente, ruta).not.toContain('import.meta.glob')
    if (ruta.startsWith('domain/') || ruta.startsWith('presentation/')) {
      expect(fuente, ruta).not.toMatch(/\binstanceof\b/)
    }
  }
})

it('descubre estrategias por patrón eager en el único punto de composición', () => {
  const fuente = readFileSync(resolve(raiz, 'main.jsx'), 'utf8')
  expect(fuente).toMatch(/import\.meta\.glob\(['"]\.\/data\/redondeo\*\.js['"],\s*\{\s*eager:\s*true\s*\}\)/)
  expect(fuente).not.toMatch(/from\s*['"].*redondeo(?:Exacto|HaciaArriba)/)
})
