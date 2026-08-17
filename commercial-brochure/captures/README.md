---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Capturas del Folleto

Esta carpeta contiene un marcador SVG válido por cada imagen planificada. El folleto permanece en estado **DRAFT** hasta reemplazarlos por capturas aprobadas.

## Sustitución rápida

1. Consulte la fila del ID en [`../CAPTURE_PLAN.md`](../CAPTURE_PLAN.md).
2. Reproduzca el estado exacto con datos sintéticos y aplique la redacción indicada.
3. Guarde la imagen como `CAP-NN.png`.
4. Cambie `.svg` por `.png` en `../BROCHURE.md` y `../BROCHURE_WORD.html`.
5. Actualice el estado del plan y ejecute `../build-brochure.sh`.

## Inventario

| ID | Funcionalidad / claim | Ejemplo ilustrado | Marcador | Archivo final | Dimensiones / relación | Redacción | Estado |
|---|---|---|---|---|---|---|---|
| CAP-01 | Configuración del producto / `CLAIM-001` | Vista general limpia | [CAP-01.svg](CAP-01.svg) | `CAP-01.png` | 1600x900 / 16:9 | IP, rutas, claves, cuentas y pestañas personales | planned |
| CAP-02 | Búsqueda Teamleader / `CLAIM-002` | Número sintético | [CAP-02.svg](CAP-02.svg) | `CAP-02.png` | 1200x900 / 4:3 | Teléfono e historial real | planned |
| CAP-03 | Alta CRM / `CLAIM-003` | Contacto y empresa sintéticos | [CAP-03.svg](CAP-03.svg) | `CAP-03.png` | 1400x1000 / 7:5 | Identidades y búsquedas externas reales | planned |
| CAP-04 | Servicios configurables / `CLAIM-004`, `CLAIM-006` | Estado de CRM, audio e IA | [CAP-04.svg](CAP-04.svg) | `CAP-04.png` | 1600x900 / 16:9 | IP, rutas, claves y cuentas | planned |

## Cierre

- [ ] Cada fila tiene un SVG no vacío.
- [ ] Cada captura final coincide con su instrucción y dimensiones.
- [ ] No hay datos personales, credenciales, tokens, clientes ni URLs internas.
- [ ] Markdown y HTML referencian exactamente los mismos archivos.
- [ ] El build informa `FINAL` y la revisión visual del DOCX/PDF está aprobada.
