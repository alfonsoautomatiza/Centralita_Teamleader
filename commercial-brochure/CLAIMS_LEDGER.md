---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Registro de Afirmaciones y Evidencias

La documentación reciente de uso es la fuente narrativa principal. Las capturas y los metadatos del manual sirven como corroboración de esta copia comercial. Este repositorio no contiene el código fuente actual de la aplicación; por tanto, las afirmaciones que solo aparecen en documentación técnica antigua o promocional no se publican como verificadas.

## Afirmaciones

| ID | Funcionalidad / afirmación exacta | Ejemplo realista | Estado | Documentación principal | Evidencia corroborante | Discrepancia / brecha | Alcance / condiciones | Uso en folleto | Confirmación necesaria |
|---|---|---|---|---|---|---|---|---|---|
| CLAIM-001 | Aplicación de escritorio para Windows que relaciona llamadas con Teamleader Focus y puede añadir grabación y análisis con IA cuando se configuran. | Un equipo comercial usa la aplicación junto con Teamleader durante su jornada de llamadas. | verified | `docs/index.md:L7-L10`; `docs/es/manual/instalacion.md:L7-L20` | `mkdocs.yml:L1-L6`; `docs/img/pantalla_configuracion_centralita teamleader.png` muestra los módulos CRM, grabación e IA. | El repositorio es el manual, no la implementación ejecutable. | Windows 10/11; licencia y paquete autorizado. Grabación e IA son opcionales. | Portada y encaje | No |
| CLAIM-002 | Busca teléfonos en contactos y empresas de Teamleader y muestra el contexto disponible en una prenota. | Ante una llamada o búsqueda manual, el agente confirma el cliente y revisa oportunidades, tickets o notas pertinentes. | verified | `docs/es/manual/uso-diario.md:L18-L36`; `docs/es/manual/teamleader.md:L20-L30` | `docs/img/BUSCAR.png`; `docs/es/manual/index.md:L33-L41` | La disponibilidad depende de permisos y coincidencias del CRM. | Requiere Teamleader validado; revisar duplicados y prefijos. | Funcionalidad 1 | No |
| CLAIM-003 | Si un número no existe, abre un flujo de alta para crear un contacto o una empresa. | Un nuevo posible cliente llama y el usuario completa nombre, empresa y correo antes de guardar. | verified | `docs/es/manual/uso-diario.md:L20-L24`; `docs/es/manual/teamleader.md:L32-L40` | `docs/img/pantalla-alta-nuevo.png` muestra el formulario de contacto/empresa. | La guía antigua atribuye enriquecimiento automático por IA y búsquedas externas; no se publica esa ampliación. | El usuario debe revisar los datos y decidir el tipo de registro. | Funcionalidad 2 | No |
| CLAIM-004 | Permite configurar grabación desactivada, interna u OBS, y procesar el audio con IA si se activa un proveedor compatible. | Un equipo elige grabación interna; otro con OBS configura host, puerto, ruta y escena antes de probar la conexión. | verified | `docs/es/manual/configuracion.md:L33-L61`; `docs/es/manual/instalacion.md:L35-L47` | `docs/img/pantalla_configuracion_centralita teamleader.png` muestra configuración OBS y estados de conexión. | No se verifica la calidad, precisión, coste ni captura de ambos canales. | Requiere consentimiento, ruta escribible y configuración válida; IA requiere Google AI u OpenRouter y revisión humana. | Funcionalidad 3 | No |
| CLAIM-005 | La prenota permite seleccionar contexto y añadir foco y apuntes; el análisis de IA se genera después de finalizar el audio y debe revisarse. | Durante una llamada comercial, el agente selecciona el producto, anota acuerdos y después comprueba nombres, cifras y fechas del texto generado. | verified | `docs/es/manual/uso-diario.md:L38-L69`; `docs/es/manual/index.md:L33-L48` | `docs/es/manual/configuracion.md:L51-L65` documenta proveedor, modelo y prompts. | Las guías antiguas prometen notas completas sin intervención; el manual reciente exige contexto y revisión. | Solo con grabación e IA activadas y audio válido; el resultado no es una fuente definitiva. | Funcionalidad 4 | No |
| CLAIM-006 | Ofrece un asistente y una configuración web para validar Teamleader, elegir grabación, configurar IA y comprobar conexiones. | La persona administradora configura primero CRM, después audio e IA y comprueba cada servicio antes de una llamada de prueba. | verified | `docs/es/manual/instalacion.md:L35-L58`; `docs/es/manual/configuracion.md:L7-L18` | `docs/img/pantalla_configuracion_centralita teamleader.png`; `mkdocs.yml:L113-L137` | La captura contiene datos de entorno; no debe reutilizarse sin redacción. | Los pasos opcionales pueden omitirse; guardar y validar antes del uso. | Funcionalidad 5 y flujo | No |
| CLAIM-007 | Puede detectar llamadas de un Android enlazado mediante Just Remote Phone; también permite búsqueda manual. | Un usuario empareja móvil y PC para identificación automática; si no usa Android, introduce el teléfono manualmente. | verified | `docs/es/manual/configuracion.md:L67-L75`; `docs/es/manual/uso-diario.md:L28-L36` | `docs/img/pantalla_llamadas_windows.png` muestra la aplicación de terceros conectada. | Versiones y precios de la app externa varían en guías antiguas y no se publican. | Función opcional; requiere software de terceros, enlace activo y permisos. | Encaje y requisitos | No |
| CLAIM-008 | El siguiente paso verificable es consultar el manual oficial o solicitar información general a ALCATIC. | Un interesado revisa instalación y compatibilidad antes de solicitar el paquete por un canal autorizado. | verified | `docs/index.md:L35-L37`; `docs/es/manual/ayuda.md:L35-L62` | `mkdocs.yml:L2-L4` identifica el manual oficial; `README.md:L50-L60` enlaza AlcaTic. | El canal contractual de soporte tiene prioridad y no se conoce desde el repositorio. | CTA al manual y a `https://alcatic.es/`; no se promete descarga pública. | Próximo paso | No |
| CLAIM-009 | “Automatización total”, ninguna intervención manual y ninguna llamada perdida. | No publicable. | unsupported | Afirmado en guías promocionales antiguas, p. ej. `docs/es/tecnica/arquitectura.md:L24-L29` y `docs/es/castellano/ejemplos-dia-a-dia.md:L429-L430`. | `docs/es/manual/index.md:L38-L48` exige selección de contexto y revisión; `docs/es/manual/uso-diario.md:L67-L69` limita la recuperación. | Contradicción directa con el flujo actual y sus límites. | Ninguno. | Excluido | No; no publicar |
| CLAIM-010 | Testimonios, clientes “reales” y métricas de ventas, ahorro, precisión o satisfacción. | No publicable. | unsupported | `docs/es/tecnica/casos-de-uso.md` presenta empresas, testimonios y métricas sin evidencia adjunta. | No existen contratos, estudios, datos anonimizados ni implementación en el repositorio que los prueben. | Casos narrativos etiquetados como reales sin soporte verificable. | Ninguno. | Excluido | No; no publicar |
| CLAIM-011 | Precios de IA, precio/licencia de Just Remote Phone, gratuidad, prueba de 15 días y uso ilimitado. | No publicable. | needs-confirmation | Varias guías antiguas y localizadas ofrecen cifras y condiciones diferentes, p. ej. `docs/en/index.md:L82-L100` y `docs/es/castellano/link-descarga-software-centralita-teamleader.md:L403-L417`. | El manual reciente remite a contrato/licencia/proveedor: `docs/es/manual/ayuda.md:L35-L38`. | Condiciones comerciales variables y no confirmadas. | Ninguno. | Excluido | Confirmar oferta, territorio, moneda, impuestos y fecha de vigencia. |
| CLAIM-012 | Instalador firmado, libre de malware, actualizaciones automáticas y versión 2.5.0. | No publicable. | needs-confirmation | `docs/es/castellano/link-descarga-software-centralita-teamleader.md:L307-L399`. | `docs/es/updates/manifest-stable.json:L1-L18` declara canal estable 0.1.1; no hay firma del instalador ni checksum publicable del paquete comercial. | Conflicto de versión y ausencia de evidencia sobre firma/actualización. | Ninguno. | Excluido | Confirmar versión, firma, checksum y política de actualización. |
| CLAIM-013 | Idiomas completos y disponibles en la aplicación. | No publicable. | needs-confirmation | Guías antiguas enumeran combinaciones diferentes de ES/EN/FR/IT y más idiomas en una captura. | El sitio de documentación sí está en ES/EN/FR (`mkdocs.yml:L21-L27`), pero eso no demuestra idiomas de la aplicación. | Documentación y producto no son equivalentes. | Ninguno. | Excluido | Confirmar idiomas y cobertura de la versión vigente. |

## Inventario `docs/**/*.md` inspeccionado primero

| Fuente | Disposición | Razón / narrativa extraída | Versión / limitaciones |
|---|---|---|---|
| `docs/index.md` | inspected | Narrativa oficial actual: Windows, Teamleader, grabación e IA opcionales, uso responsable. | Fuente principal reciente. |
| `docs/indice_docs.md` | excluded | Índice automático; usado para comprobar cobertura, sin claims propios. | Actualizado 2026-08-05. |
| `docs/_internal/mantenimiento.md` | excluded | Procedimiento interno del sitio; no describe capacidades del producto. | Excluido del sitio público. |
| `docs/img/indice_img.md` | excluded | Índice de activos sin narrativa de producto. | Solo inventario. |
| `docs/es/indice_es.md` | excluded | Índice automático sin claims propios. | Solo navegación. |
| `docs/es/manual/index.md` | inspected | Flujo actual, opciones y límites de uso. | Fuente principal reciente. |
| `docs/es/manual/instalacion.md` | inspected | Requisitos, paquete Windows y asistente de siete pasos. | Fuente principal reciente. |
| `docs/es/manual/configuracion.md` | inspected | Teamleader, modos de grabación, IA, Android, campos libres y backup. | Fuente principal reciente. |
| `docs/es/manual/uso-diario.md` | inspected | Búsqueda, llamada detectada, prenota y revisión del texto de IA. | Fuente principal reciente. |
| `docs/es/manual/teamleader.md` | inspected | Datos CRM consultados y límites por permisos. | Fuente principal reciente. |
| `docs/es/manual/incidencias.md` | inspected | Condiciones de fallo y diagnóstico; limita promesas absolutas. | Fuente principal reciente. |
| `docs/es/manual/ayuda.md` | inspected | Condiciones opcionales, privacidad y soporte. | Fuente principal reciente. |
| `docs/es/castellano/indice_castellano.md` | excluded | Índice automático sin claims propios. | Solo navegación. |
| `docs/es/castellano/inicio-rapido-centralita-teamleader.md` | inspected | Instalación, CRM, IA, Android y claims comerciales antiguos. | Contiene tiempos, costes y garantías no verificadas. |
| `docs/es/castellano/api-teamleader.md` | inspected | OAuth2, búsqueda y creación de notas. | Contiene afirmaciones de seguridad no demostradas. |
| `docs/es/castellano/centralita-crm-ia-teamleader.md` | inspected | Inventario amplio de funciones y ejemplos. | Marketing antiguo con métricas no verificadas. |
| `docs/es/castellano/creacion-nuevo-registros-teamleader.md` | inspected | Alta de contacto/empresa y claims de enriquecimiento. | Ampliaciones de IA y fuentes externas no corroboradas. |
| `docs/es/castellano/ejemplos-dia-a-dia.md` | inspected | Escenarios de uso para contrastar con manual reciente. | Promesas absolutas excluidas. |
| `docs/es/castellano/pantalla-configuracion-centralita-teamleader.md` | inspected | Configuración visual, CRM, IA, audio y Android. | Cifras, idiomas y temas requieren confirmación. |
| `docs/es/castellano/App-Call-remoto.md` | inspected | Integración opcional Android/Windows. | Precios, versiones y consumo no publicados. |
| `docs/es/castellano/link-descarga-software-centralita-teamleader.md` | inspected | Instalación y ausencia de URL pública verificable. | Conflictos de versión, gratuidad y firma. |
| `docs/es/tecnica/indice_tecnica.md` | excluded | Índice automático sin claims propios. | Solo navegación. |
| `docs/es/tecnica/arquitectura.md` | inspected | Flujo funcional y arquitectura narrativa. | Contiene promesas absolutas y métricas no probadas. |
| `docs/es/tecnica/casos-de-uso.md` | inspected | Casos, testimonios y métricas para identificar claims prohibidos. | No hay evidencia primaria; no se publican. |
| `docs/es/tecnica/faq-tecnica.md` | inspected | Condiciones, límites y formatos declarados. | Mezcla guía de usuario y supuestos técnicos antiguos. |
| `docs/es/tecnica/funcionalidades-avanzadas.md` | inspected | OBS, backup, idiomas, validación y recuperación. | Cifras y garantías no verificadas. |
| `docs/es/tecnica/funcionalidades-core.md` | inspected | Detección, grabación, IA, CRM y configuración. | Implementación citada no está presente en este repo. |
| `docs/es/tecnica/integraciones.md` | inspected | Detalle de OBS y condiciones de uso. | Presenta discrepancias de formato/escena. |
| `docs/tecnica/indice_tecnica.md` | excluded | Índice automático duplicado. | Solo navegación. |
| `docs/tecnica/arquitectura.md` | inspected | Referencia técnica heredada. | Código citado ausente; no corrobora implementación. |
| `docs/tecnica/casos-de-uso.md` | inspected | Escenarios y cifras heredadas. | Métricas no verificadas. |
| `docs/tecnica/faq-tecnica.md` | inspected | Requisitos y operaciones heredadas. | Contradice instalación del manual reciente. |
| `docs/tecnica/funcionalidades-avanzadas.md` | inspected | Lista de capacidades avanzadas declaradas. | Código citado ausente; estados no verificables. |
| `docs/tecnica/funcionalidades-core.md` | inspected | Inventario técnico del supuesto MVP. | Código citado ausente. |
| `docs/tecnica/integraciones.md` | inspected | Integraciones declaradas y estados. | Solo Teamleader/OBS/OpenRouter tienen apoyo narrativo actual; otras excluidas. |
| `docs/en/indice_en.md` | excluded | Índice automático. | Solo navegación. |
| `docs/en/index.md` | inspected | Narrativa localizada y oferta antigua. | Prueba gratuita y claims comerciales no confirmados. |
| `docs/en/english/indice_english.md` | excluded | Índice automático. | Solo navegación. |
| `docs/en/english/inicio-rapido-centralita-teamleader.md` | inspected | Traducción de instalación y configuración. | Tiempos, costes y licencia no confirmados. |
| `docs/en/english/centralita-crm-ia-teamleader.md` | inspected | Traducción de funciones y ejemplos. | Métricas no confirmadas. |
| `docs/en/english/link-descarga-software-centralita-teamleader.md` | inspected | Traducción de descarga y requisitos. | Conflictos de versión/seguridad. |
| `docs/en/technical/indice_technical.md` | excluded | Índice automático. | Solo navegación. |
| `docs/en/technical/arquitectura.md` | inspected | Traducción técnica resumida. | Implementación no presente. |
| `docs/fr/indice_fr.md` | excluded | Índice automático. | Solo navegación. |
| `docs/fr/index.md` | inspected | Narrativa localizada y oferta antigua. | Prueba gratuita y beneficios no confirmados. |
| `docs/fr/francais/indice_francais.md` | excluded | Índice automático. | Solo navegación. |
| `docs/fr/francais/demarrage-rapide-centralita-teamleader.md` | inspected | Traducción de instalación y configuración. | Tiempos, costes y licencia no confirmados. |
| `docs/fr/francais/centralite-crm-ia-teamleader.md` | inspected | Traducción de funciones y ejemplos. | Métricas no confirmadas. |
| `docs/fr/francais/lien-telechargement-logiciel-centralita-teamleader.md` | inspected | Traducción de descarga y requisitos. | Conflictos de versión/seguridad. |
| `docs/fr/technique/indice_technique.md` | excluded | Índice automático. | Solo navegación. |
| `docs/fr/technique/architecture.md` | inspected | Traducción técnica resumida. | Implementación no presente. |

## Documentación complementaria

| Fuente | Rol | Narrativa / limitaciones |
|---|---|---|
| `README.md` | Fallback secundario | Integración Teamleader, búsqueda y contacto general; texto antiguo y con erratas. |
| `IDEAS.md` | Hipótesis, no prueba | Lista de ideas con casillas sin completar y referencias a otro repositorio; excluida como evidencia actual. |
| `mkdocs.yml` | Metadatos y estructura | Nombre oficial, descripción, idiomas del manual, URL pública y navegación. |
| `docs/es/updates/manifest-stable.json` | Metadato de release | Declara 0.1.1 y entra en conflicto con 2.5.0 de guías antiguas. |

## Fuentes corroborantes

| Fuente | Tipo | Claims comprobados | Resultado / limitaciones |
|---|---|---|---|
| `docs/img/BUSCAR.png` | Captura de UI | CLAIM-002 | Confirma búsqueda manual y control de grabación; captura pequeña y antigua. |
| `docs/img/pantalla-alta-nuevo.png` | Captura de UI | CLAIM-003 | Confirma alta de contacto/empresa; no prueba calidad de IA ni fuentes externas. |
| `docs/img/pantalla_configuracion_centralita teamleader.png` | Captura de UI | CLAIM-001, CLAIM-004, CLAIM-006 | Confirma módulos y configuración OBS/IA/CRM; contiene rutas, IP y contraseña enmascarada, por lo que requiere redacción. |
| `docs/img/pantalla_llamadas_windows.png` | Captura de tercero | CLAIM-007 | Confirma el flujo de app Android/Windows; contiene identidades y teléfonos de demostración, por lo que requiere sustitución. |

## Discrepancias y preguntas de confirmación

- [ ] `CLAIM-009`: las guías antiguas prometen automatización total y recuperación sin pérdidas; el manual reciente exige intervención, revisión y audio válido.
- [ ] `CLAIM-010`: no hay evidencia de los testimonios, empresas ni métricas presentados como reales.
- [ ] `CLAIM-011`: confirmar condiciones comerciales vigentes; existen afirmaciones divergentes sobre gratuidad, prueba y licencias.
- [ ] `CLAIM-012`: confirmar versión, firma, checksum y actualizaciones; el manifiesto 0.1.1 contradice la versión 2.5.0 documentada.
- [ ] `CLAIM-013`: confirmar idiomas de la aplicación; los idiomas del sitio y de capturas no prueban cobertura del producto.
- [ ] Las guías OBS difieren en nombre de escena y formato (Audio/Grabación Llamada; MP4 frente a MP3/WAV). El folleto solo indica que OBS requiere configuración y prueba.
- [ ] Los requisitos de espacio varían entre 5 MB y 50 MB. El folleto no publica una cifra.

## Exclusiones de descubrimiento

- No se inspeccionaron `.git/`, `.atl/`, binarios, ZIP/MSI/MP4, `docs/es/updates/files/`, cachés, salidas generadas, dependencias ni posibles archivos de secretos.
- `IDEAS.md` se trató como backlog/hipótesis, nunca como prueba de capacidad.
- No se usaron nombres de archivos o módulos como base de una afirmación comercial.
