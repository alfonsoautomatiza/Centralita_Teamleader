---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Plan de Capturas

El folleto permanece en estado **DRAFT** mientras use estos SVG. Cada imagen final debe recrearse con datos sintéticos, sin credenciales, teléfonos reales, nombres de clientes, rutas internas ni URLs privadas.

| ID | Funcionalidad y claim verificado | Ejemplo que ilustra | Estado exacto y pasos | Encuadre y tamaño | Redacción | Marcador actual | Captura final prevista | Ubicación | Pie / texto alternativo | Estado |
|---|---|---|---|---|---|---|---|---|---|---|
| CAP-01 | Producto configurable para Teamleader, grabación e IA (`CLAIM-001`) | Vista limpia de la configuración general | 1. Abrir Configuración. 2. Mostrar navegación principal y estado general. 3. No abrir campos secretos. | Área principal; 1600x900; 16:9 | Usar instalación de demostración; ocultar IP, rutas, claves y cuentas del navegador. | [CAP-01.svg](captures/CAP-01.svg) | `captures/CAP-01.png` | Portada | Pie: "Centralita IA Teamleader reúne CRM y servicios opcionales en un flujo configurable." / Alt: "Configuración general de Centralita IA Teamleader sin datos sensibles." | planned |
| CAP-02 | Búsqueda manual en Teamleader (`CLAIM-002`) | Agente introduce un teléfono sintético | 1. Abrir Buscar. 2. Introducir `+34 600 000 001`. 3. Mantener grabación desactivada. | Ventana completa; 1200x900; 4:3 | Solo número sintético; sin nombres ni historial real. | [CAP-02.svg](captures/CAP-02.svg) | `captures/CAP-02.png` | Después de funcionalidad 1 | Pie: "La búsqueda manual permite iniciar el flujo con un teléfono conocido." / Alt: "Formulario de búsqueda manual con un número sintético." | planned |
| CAP-03 | Alta de contacto o empresa (`CLAIM-003`) | Número sin coincidencia y formulario de alta | 1. Buscar el número sintético. 2. Abrir alta. 3. Completar `María Ejemplo`, `Empresa Demostración`, `demo@example.invalid`. | Formulario completo; 1400x1000; 7:5 | Datos totalmente sintéticos; no mostrar resultados de WhatsApp, Google o LinkedIn. | [CAP-03.svg](captures/CAP-03.svg) | `captures/CAP-03.png` | Después de funcionalidad 2 | Pie: "Si no hay coincidencia, el usuario puede preparar un nuevo contacto o empresa." / Alt: "Formulario de alta con datos sintéticos de contacto y empresa." | planned |
| CAP-04 | Configuración y comprobación de servicios (`CLAIM-004`, `CLAIM-006`) | Administrador revisa CRM, grabación e IA | 1. Abrir Configuración. 2. Mostrar pestañas y estados con valores de demostración. 3. Mantener secretos ocultos. | Área principal; 1600x900; 16:9 | Sustituir IP/rutas por valores de laboratorio; claves enmascaradas; cerrar pestañas y cuentas personales del navegador. | [CAP-04.svg](captures/CAP-04.svg) | `captures/CAP-04.png` | Después de funcionalidad 5 | Pie: "Cada servicio se configura y verifica antes de incorporarlo al flujo diario." / Alt: "Panel de configuración con estados de Teamleader, grabación e IA." | planned |

## Procedimiento de sustitución

1. Crear cada captura exacta y guardarla con el nombre final previsto.
2. Comprobar dimensiones, legibilidad y redacción; después marcarla `captured` o `approved`.
3. Cambiar `captures/CAP-NN.svg` por el PNG correspondiente en `BROCHURE.md` y `BROCHURE_WORD.html`.
4. Ejecutar `./build-brochure.sh`; solo un paquete sin SVG referenciados puede generar nombres finales.

## Criterios de aprobación

- [ ] La imagen coincide con la funcionalidad y el ejemplo verificados.
- [ ] No amplía el alcance del claim cercano.
- [ ] No aparecen datos personales, credenciales, tokens, clientes, rutas ni URLs internas.
- [ ] El archivo, el token del folleto y este ID coinciden exactamente.
- [ ] El pie y el texto alternativo describen lo visible sin promesas adicionales.
