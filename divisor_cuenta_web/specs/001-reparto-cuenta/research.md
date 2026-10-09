# Research: Reparto de cuenta

## Estado local e inyección

**Decisión**: useState dentro de useDivisor; las dependencias llegan por parámetros desde
main y PantallaDivisor. Las actualizaciones de estado son inmutables y los cálculos se
hacen solo en el manejador de Calcular.
**Motivo**: una sola pantalla no requiere coordinación global; cumple la petición y DIP.
**Alternativas**: Redux/Zustand descartados por instrucción; Context innecesario.
**Fuente**: [React useState](https://react.dev/reference/react/useState).

## Precisión y redondeo

**Decisión**: monto en centavos BigInt, porcentaje en centésimas BigInt y personas BigInt.
El reparto se representa como racional de centavos { numerador, denominador }.
**Motivo**: conservar mitades y cantidades grandes sin límites arbitrarios ni dependencia
monetaria. No usar Number/toFixed para tomar decisiones de redondeo.
**Alternativas**: coma flotante con epsilon no garantiza todos los empates; biblioteca
monetaria añade dependencia evitable.

Sea C el monto en centavos, P el porcentaje en centésimas y N las personas:
propina = mitad-arriba(C * P / 10000); reparto = (C + propina) / N.
Para enteros no negativos a y b > 0, mitad-arriba(a/b) suma uno al cociente entero cuando
el doble del resto es mayor o igual al divisor. Esta regla de propina es una operación
aritmética fija del caso de uso, no validación ni formato ni una instancia de data.
Las estrategias aplican la política final al reparto y devuelven centavos enteros.

## OCP y composición

**Decisión**: main usa import.meta.glob('./data/redondeo*.js', { eager: true }) para obtener
exportaciones de funciones/metadatos. Allí crea objetos { aplicar } y el catálogo inyectado.
**Motivo**: registrar manualmente cada modo obligaría a editar main, contrario a la
redacción literal de OCP. La pantalla deriva sus opciones del catálogo y no fija dos ramas.
**Alternativas**: switch por modo viola extensión; registro manual requiere una excepción
constitucional que no se introduce; plugins de red son innecesarios.
**Fuente**: [Vite glob import](https://vite.dev/guide/features.html#glob-import).
Los módulos exportan aplicar, id, etiqueta y orden; no instancian servicios al importarse.
La convención de nombres y metadatos sirve para descubrimiento, no cambia el contrato
mínimo de estrategia. Nueva estrategia: nuevo archivo que cumpla la convención y pruebas.

## Pruebas

**Decisión**: Vitest para unidad/contratos y jsdom para UI, con createRoot y act de React.
**Motivo**: permite verificar mensajes y desaparición de resultados desde el DOM sin
introducir una librería adicional de estado ni una biblioteca de utilidades de UI.
**Alternativas**: Node solo no tiene DOM; pruebas de UI manuales exclusivamente no satisfacen
aceptación ejecutable. jsdom no reemplaza la comprobación offline en navegador real.
**Fuentes**: [Vitest](https://vitest.dev/guide/),
[entornos](https://vitest.dev/guide/environment.html),
[React act](https://react.dev/reference/react/act).
La documentación consultada exige Node >=22.12 y Vite >=6.4; las versiones locales son
Node 24.20.0 y Vite declarado ^8.3.0. La versión exacta de Vitest/jsdom se resolverá y
fijará en package-lock.json al instalar durante implementación, verificando sus engines.

## Offline y entrega

**Decisión**: cálculo síncrono y recursos propios empaquetados; no fuentes/CDN ni APIs.
Se prueba la pantalla ya cargada con conexión desactivada y el build servido localmente.
**Motivo**: cubre el escenario descrito de completar y calcular sin pedir red ni guardar
la cuenta. No existe un procedimiento de primera instalación offline definido en la spec.
**Alternativas**: PWA/service worker se reserva para un alcance explícito de reapertura
sin conexión; backend y persistencia contradicen la spec.
**Fuente**: [Vite build](https://vite.dev/guide/build).
Un build estático por sí solo no constituye una garantía de caché para recargas remotas.

## Decisiones de interfaz y consistencia

**Decisión**: validar en orden monto, personas, propina; mostrar el primer error. Al editar,
ocultar salida y error, sin recalcular. Iniciar campos vacíos y modo exacto.
**Motivo**: comportamiento determinista donde la spec no fija precedencia ni estado inicial;
evita confundir un resultado anterior con datos recién editados.
**Alternativas**: múltiples mensajes simultáneos o conservar resultado anterior serían
posibles, pero requieren más estado o una indicación adicional no necesaria.
Gramática: recortar espacios exteriores; monto/propina con dígitos y opcionalmente punto
o coma seguido de una o dos cifras; sin agrupación ni exponentes. Personas con signo
opcional y dígitos enteros; valores <=0 usan el mensaje específico. Un negativo decimal
no es un entero y recibe Número de personas inválido. No se añaden máximos arbitrarios.

SC-001 enumera seis ejecuciones frente a siete escenarios: se prueba el conjunto completo
sin editar la spec. No quedan decisiones técnicas pendientes para esta fase.
