---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Ideas de funcionalidades — Centralita Teamleader

## Contexto de la Aplicación
**Descripción**: Sistema de gestión de llamadas con IA que integra telefonía, grabación de audio, transcripción automática con inteligencia artificial y sincronización con CRMs como Teamleader. Centraliza la gestión de llamadas entrantes/salientes, automatiza el resumen de conversaciones y mantiene un registro estructurado de todas las interacciones.



**Público Objetivo**: PYMEs españolas que utilizan Teamleader como CRM y necesitan automatizar la gestión de llamadas telefónicas con transcripción IA, especialmente empresas de servicios, call centers y equipos de ventas.

---

## Funcionalidades Core (MVP)

- [ ] **Detección automática de llamadas**: Integración con RemotePhoneService.dll para detectar estados de llamada (Idle/OffHook/Connected) y obtener número telefónico activo. **Valor**: Automatiza todo el flujo sin intervención manual, activando grabación y lookups CRM automáticamente. (Referencias: `miratelefono_ia.py:CallProcessor`, `miratelefono_phone_processor.py`)

- [ ] **Grabación de audio multiformato**: Soporte para grabación interna (WAV vía PyAudio) y externa (MP4 vía OBS Studio) con cambio dinámico según configuración `modulos#audio` (0=desactivado, 1=interna, 2=OBS). **Valor**: Flexibilidad para diferentes entornos, OBS ofrece mejor calidad pero requiere setup, modo interno funciona out-of-the-box. (Referencias: `miratelefono_tareas_proceso.py:crear_trabajo_grabar`, `libwertyaudiolimpieza.py`)

- [ ] **Transcripción IA de llamadas**: Procesamiento automático del audio grabado con OpenRouter API (modelos como google/gemini-2.5-flash-lite) generando resúmenes estructurados. **Valor**: Elimina la necesidad de tomar notas manuales, proporciona resúmenes accionables de cada llamada. (Referencias: `miratelefono_tareas_proceso.py:crear_trabajo_ia`, `libwertyIA.py`, `config.ini:[IA]`)

- [ ] **Integración bidireccional con Teamleader**: Búsqueda automática de contactos/empresas por número telefónico al recibir llamada, apertura de ficha CRM en navegador, y creación de notas/pre-notas con datos de la llamada. **Valor**: Centraliza toda la información del cliente en un solo lugar, reduce tiempo de búsqueda manual. (Referencias: `FRAMES/procesos.py:buscateam`, `FRAMES/cuadro.py:nota`, `apitl.py`)

- [ ] **Interfaz de system tray**: Menú tray con acceso rápido a búsquedas manuales, última llamada, hoja de tiempo, configuración web y apagado controlado. **Valor**: Acceso permanente sin interferir con workflow, notificaciones visuales de grabación activa. (Referencias: `miratelefono_ia.py:GUIComponents`, `miratelefono_sg.py`)

- [ ] **Gestión de tareas en segundo plano**: Sistema TareaV2 con ThreadPoolExecutor para grabación, IA, backup y plantillas simultáneas sin bloquear interfaz. **Valor**: Sistema responsivo, múltiples operaciones en paralelo, mejor uso de recursos. (Referencias: `miratelefono_tareas_proceso.py:TareaV2`, `GestorCSV`)

- [ ] **Configuración web via Streamlit**: Interface en `http://localhost:8585/` para ajustar parámetros en tiempo real con recarga en caliente (detencción de cambios en `config.ini`). **Valor**: Modificación de configuración sin reiniciar aplicación,适用于 usuarios no técnicos. (Referencias: `_internal/config.py`, `FRAMES/conf.py:control_stream_config`)

- [ ] **Persistencia de estado en CSV**: Archivo `hojatiempo.csv` con registro de todas las llamadas (teléfono, fichero, entidad, tiempo, estado, URL) para recuperación tras apagones. **Valor**: No se pierden grabaciones pendientes de procesar por IA si hay corte de luz. (Referencias: `miratelefono_tareas_proceso.py:procesocsv_post_apagon`, `GestorCSV`)

---

## Funcionalidades Avanzadas (v2)

- [ ] **Sistema de archivos "Frames" para integraciones múltiples**: Arquitectura modular en `FRAMES/` que permite diferentes implementaciones por CRM (Teamleader, Sage 50, etc.) con resolución dinámica por rama git o variable de entorno `CENTRALITA_FRAME`. **Valor**: Mismo código base para múltiples productos, fácil mantenimiento de integraciones específicas. (Referencias: `FRAMES/README.md`, `frame_loader.py`)

- [ ] **Cache warming diferido de Streamlit**: Arranque optimizado que carga páginas auxiliares (config, hojatiempo, prenota, nota) en segundo plano tras un delay configurable. **Valor**: Primer arranque más rápido, páginas auxiliares listas cuando se necesitan. (Referencias: `miratelefono_ia.py:_schedule_startup_warming`, `resolve_startup_warming_plan`)

- [ ] **Validación de audio antes de IA**: Sistema de limpieza con `libwertyaudiolimpieza.AudioCleaner` que valida tamaño mínimo, duración y checksum SHA256 antes de encolar tarea IA, con reintentos para archivos recién creados. **Valor**: Evita procesamiento de audios corruptos o vacíos, ahorra créditos API. (Referencias: `miratelefono_tareas_proceso.py:_validar_audio_antes_de_ia`, `libwertyaudiolimpieza.py`)

- [ ] **Sistema de backup automático**: BackupManager que detecta cambios en datos y ejecuta backups periódicos según `backup#tiempo_backup` y `backup#dirbackup`. **Valor**: Protección contra pérdida de datos, recuperación ante desastres. (Referencias: `miratelefono_backup.py:BackupManager`)

- [ ] **Circuit Breaker para APIs externas**: Sistema de aislamiento que previene cascadas de fallos en OBS Studio y APIs CRM cuando hay problemas de conectividad. **Valor**: Sistema permanece funcional aunque un servicio externo falle, mejor resiliencia. (Referencias: `miratelefono_circuit_breaker.py:CircuitBreakerManager`)

- [ ] **Health checks monitorizados**: Comprobaciones periódicas de estado de OBS, API CRM y otros componentes críticos con métricas disponibles en puerto 8000. **Valor**: Detección proactiva de problemas, monitorización en producción. (Referencias: `miratelefono_health_checks.py:health_checker`)

- [ ] **Supervisor de procesos Streamlit**: Gestión centralizada de instancias Streamlit (config, hojatiempo, nota, prenota) con cierre por inactividad y prevención de múltiples instancias. **Valor**: Ahorro de recursos, control de memoria, evita procesos zombies. (Referencias: `FRAMES/streamlit_supervisor.py`, `STREAMLIT_SUPERVISOR_README.md`)

- [ ] **Sistema de multi-idioma**: Traducciones vía gettext con dominios por idioma (es, en, it) en `locale/`, configurables desde `windows#idioma`. **Valor**: Internacionalización fácil, soporte para mercados multinacionales. (Referencias: `FRAMES/conf.py:proceidioma`, `locale/`)

- [ ] **A/B testing de prompts IA**: PromptVersionManager para experimentar con diferentes prompts de transcripción y medir effectiveness con versionado y asignación aleatoria. **Valor**: Optimización continua de calidad de transcripción, decisiones basadas en datos. (Referencias: `miratelefono_premiun.py:PromptVersionManager`, `miratelefono_tareas_proceso.py:_assign_prompt_ab`)

---

## Integraciones Posibles

- [ ] **Teamleader API**: Integración actual con OAuth2 (`client_id`, `client_secret`, `tl_access_token`, `tl_refresh_token`). **Casos de uso**: Sincronización de contactos, empresas, deals, quotations; creación automática de notas tras llamada; lookup de números telefónicos. **Qué problema resuelve**: Centralización de toda la información del cliente en el CRM, evita duplicación de datos.

- [ ] **OBS Studio (WebSocket)**: Control remoto vía `obs_websocket` en `python-OBS-websocket` para grabación de audio del sistema. **Casos de uso**: Grabación de alta calidad de llamadas, captura de audio de cualquier aplicación. **Qué problema resuelve**: Calidad de audio superior a grabación interna, permite grabar llamadas VoIP.

- [ ] **Sage 50**: Frame específico en `FRAMES/sage50/` (si existe) para integración con contabilidad Sage 50. **Casos de uso**: Sincronización de facturas, clientes, proveedores; generación de presupuestos desde llamadas. **Qué problema resuelve**: Integración telefónica-contabilidad para empresas que usan Sage.

- [ ] **OpenRouter / Google Gemini**: API de IA para transcripción de audio. **Casos de uso**: Transcripción speech-to-text, resumen de conversaciones, extracción de entidades y acciones. **Qué problema resuelve**: Automatización de documentación de llamadas, búsqueda en historial de conversaciones.

- [ ] **eInforma**: Integración con `bs4empresite.bs4empresite` para datos comerciales de empresas españolas. **Casos de uso**: Enriquecimiento de fichas de cliente con información comercial y financiera. **Qué problema resuelve**: Contexto adicional sobre clientes potenciales, calificación de riesgo.

- [ ] **Flet**: Framework Python para interfaces de escritorio multiplataforma (ver `ADDON/server_flet.py`). **Casos de uso**: Aplicaciones de escritorio nativas alternativas a Streamlit. **Qué problema resuelve**: Opción para usuarios que prefieren desktop apps sobre web apps.

---

## Preguntas Frecuentes Anticipadas

### ¿Cómo se instala?

**Respuesta**:
1. **Requisitos previos**: Windows 10/11 (para integración de telefonía)
2. **Instalación**:
   - Descargar instalador: `Setup_Centralita_IA_Teamleader.exe`
   - Ejecutar instalador y seguir asistente
   - Finalizar instalación
3. **Configuración inicial**:
   - Abrir configuración desde icono en bandeja de sistema
   - Configurar API keys en secciones `[API]` (Teamleader) y `[IA]` (OpenRouter)
   - Establecer rutas de audio en `[AUDIO]`
4. **Ejecución**: Aplicación se inicia automáticamente tras instalación, ejecutable `Centralita.exe`

### ¿Qué pasa si falla la conexión con Teamleader?

**Respuesta**: El sistema incluye Circuit Breaker (`miratelefono_circuit_breaker.py`) que aísla fallos de la API CRM. Si Teamleader no responde:
- Las llamadas se siguen grabando y transcribiendo
- Los datos se guardan en `hojatiempo.csv` con estado pendiente
- Un health check periódico reintenta la conexión
- Cuando se restaura, se sincronizan los datos pendientes manualmente vía "Hoja de tiempo"

### ¿Cómo se configuran los mapeos de columnas?

**Respuesta**: Los mapeos se configuran en `config.ini`:
- **Campos libres de Teamleader**: `api#camposlibres` con formato `campo_origen<-->campo_destino` codificado en bs4
- **Mapeos de campos personalizados**: Editar `FRAMES/config_glosario.py` para definir diccionarios de traducción
- **Para nuevas integraciones**: Crear nuevo frame en `FRAMES/<nombre>/x_conf.py` con mapeos específicos

### ¿Se puede personalizar X?

**Respuesta**: El sistema es altamente personalizable:
- **Prompts de IA**: Modificar `ia#intrucciones` en `config.ini` o usar sistema A/B testing vía `miratelefono_premiun.py`
- **Tema visual**: Cambiar `windows#tema` (temas de PySimpleGUI: DarkBlue16, LightGreen, etc.)
- **Idioma**: Ajustar `windows#idioma` (es, en, it) y agregar traducciones en `locale/`
- **Módulos activos**: Habilitar/deshabilitar en `[MODULOS]` (buscar, audio, ia, plantillas, cuadro)
- **Integraciones**: Crear frames personalizados en `FRAMES/` siguiendo estructura de `main/`

### ¿Qué formatos de archivo soporta?

**Respuesta**:
- **Audio entrada**: WAV (grabación interna), MP4 (grabación OBS)
- **Audio salida**: WAV (para procesamiento IA), TXT (transcripción)
- **Configuración**: INI (config.ini), JSON (campos_libres.c, cachés)
- **Datos**: CSV (hojatiempo.csv), PICKLE (serialización interna)
- **Logs**: TXT (log_centralita.log)

### ¿Cómo se manejan los errores de validación?

**Respuesta**: Sistema multi-capa:
1. **Validación de audio**: `libwertyaudiolimpieza` valida tamaño (min 4096 bytes), duración (min 0.8s), formato WAV/MP4 y checksum SHA256
2. **Reintentos automáticos**: Para archivos recién creados (6 reintentos con 350ms delay)
3. **Logging estructurado**: Todos los errores se registran en `log_centralita.log` con traceback
4. **Notificaciones usuario**: System tray muestra avisos visuales de errores críticos
5. **Recuperación graceful**: TareaV2 marca estado "Sin IA" para audios no válidos, continúa procesando otras tareas

---

## Keywords SEO Relevantes

**Para documentación y visibilidad del producto**:

- centralita telefonía python, teamleader integración api
- transcripción ia llamadas automática, speech to text python
- grabación llamadas obs studio, audio python pyaudio
- crm integración teamleader, sincronización contactos
- sistema de gestión de llamadas, call center software
- automación llamadas entrantes, detector de llamadas
- openrouter gemini, ia transcripción audio
- python streamlit dashboard, system tray application
- backup automático python, circuit breaker pattern
- multiidioma aplicación python, gettext localization

**Frases larga tipo**:

- "sistema de centralita telefónica con integración teamleader"
- "grabar llamadas automáticamente con python y obs studio"
- "transcribir llamadas con inteligencia artificial openrouter"
- "integración crm teamleader api python automation"
- "software call center python speech to text"
- "automatizar gestión de llamadas con ia y crm"
- "centralita virtual python teamleader grabación"
- "sistema de recuperación de llamadas post apagón"

---

## Casos de Uso Reales (Ejemplos para el Manual)

### 1. Caso: Gestión de llamadas de ventas en empresa de servicios

**Usuario tipo**: Empresa de jardinería/landscaping con 5-10 agentes comerciales

**Problema**:
- Los agentes pierden tiempo buscando información del cliente en Teamleader mientras hablan
- No hay registro automático de qué se acordó en cada llamada
- Los resúmenes de llamadas se escriben manualmente con errores y omisiones
- Las llamadas con clientes nuevos no se registran hasta crear manualmente la ficha

**Solución**:
- Centralita detecta llamada entrante, busca automáticamente en Teamleader por número
- Abre ficha del cliente en navegador antes de que el agente conteste
- Graba la llamada y genera transcripción IA con resumen estructurado
- Crea nota en Teamleader con puntos clave, objeciones y siguientes pasos
- Para clientes nuevos, abre formulario de pre-nota para alta rápida

**Pasos típicos**:
1. Cliente llama al teléfono fijo de la empresa
2. Centralita detecta llamada (OffHook) en RemotePhoneService
3. Busca número en Teamleader (contactos + empresas)
4. Si encuentra, abre ficha en navegador + inicia grabación
5. Agente contesta ya con contexto completo del cliente
6. Al colgar, IA procesa audio y genera resumen
7. Nota se crea automáticamente en Teamleader
8. En "Hoja de tiempo" se registra duración y enlace a nota

### 2. Caso: Recuperación de llamadas tras corte de luz

**Usuario tipo**: Call center con operarios telefónicos, ubicación con infraestructura eléctrica inestable

**Problema**:
- Cortes de luz frecuentes interrumpen la aplicación
- Llamadas grabadas antes del corte no se procesan por IA
- Operarios deben recordar qué llamadas necesitan transcripción
- Pérdida de información crítica de clientes

**Solución**:
- Sistema persiste estado de cada llamada en `hojatiempo.csv` inmediatamente
- Al reiniciar, `procesocsv_post_apagon()` detecta filas sin IA
- Valida archivos de audio existen y son válidos
- Relanza tareas de IA automáticamente para llamadas pendientes
- Notifica al usuario con resumen de recuperación

**Pasos típicos**:
1. Corte de luz: sistema se apaga inesperadamente
2. 3 llamadas estaban grabadas pero no transcritas aún
3. Registros en CSV: estado="Audio finalizado", sin "IA disponible"
4. Electricidad vuelve, usuario reinicia centralita.exe
5. Splash screen muestra "Recuperando pendientes de hojatiempo.csv"
6. Sistema valida 3 audios WAV existen y cumplen requisitos
7. Encola 3 tareas de IA en ThreadPoolExecutor
8. Notificación: "Recuperación de pendientes: pendientes=3, relanzadas=3"
9. Operarios ven las 3 transcripciones aparecer en Teamleader

### 3. Caso: Empresa multinacional con sedes en varios países

**Usuario tipo**: Consultora con sedes en España, Italia y Reino Unido

**Problema**:
- Cada sede usa mismo sistema pero diferente idioma
- Traducciones manuales de la interfaz son tediosas
- Prompts de IA deben adaptarse a idioma/cultura local
- Configuraciones específicas por sede (formatos de número, rutas)

**Solución**:
- Sistema de multi-idioma con `windows#idioma` (es/it/en)
- Dominios gettext en `locale/es/LC_MESSAGES/`, `locale/it/...`
- Frames por país: `FRAMES/main/` (España), `FRAMES/italia/` (Italia)
- Prompts IA configurables por sede en `ia#intrucciones`
- Rutas de audio configurables en `[AUDIO]` por instalación

**Pasos típicos**:
1. Sede España: `config.ini` con `windows#idioma=es`, `audio#inicio=d:\centralita_ia\rec`
2. Sede Italia: copia sistema, cambia `windows#idioma=it`, `audio#inicio=c:\dati\chiamate`
3. Sede UK: `windows#idioma=en`, prompts IA en inglés
4. Cada sede ejecuta `centralita.py` con config.ini localizado
5. Interfaz aparece en idioma configurado sin recompilar
6. Prompts IA adaptados a cultura local (ej: formal vs informal)

### 4. Caso: Integración con OBS Studio para alta calidad

**Usuario tipo**: Empresa VoIP que necesita grabar llamadas de softphone

**Problema**:
- Grabación interna PyAudio solo captura audio de micrófono
- Softphone Zoiper/3CX no se integra con API de audio Windows
- Necesitan grabar ambos lados de la conversación (caller + callee)
- Calidad de WAV interno es insuficiente para análisis de sentimiento

**Solución**:
- Configurar `modulos#audio=2` en config.ini
- OBS Studio con plugin obs-browser-source captura audio del sistema
- Centralita conecta vía WebSocket a OBS (`obs#obs_host=localhost`, `obs#obs_port=4455`)
- Al detectar llamada, invoca `tarea_obs.obs_grabar(nombre)`
- OBS graba en MP4 alta calidad con ambos canales de audio
- IA procesa MP4 con mejores resultados que WAV

**Pasos típicos**:
1. Usuario instala OBS Studio y configura escena de audio
2. Edita config.ini: `modulos#audio=2`, `obs#obs_activo=True`
3. Inicia centralita.py
4. OBS se inicia en background, conecta WebSocket
5. Llamada entra, centralita detecta OffHook
6. Instrucción a OBS: `StartRecording` vía WebSocket
7. OBS graba toda la conversación en MP4
8. Al colgar, `StopRecording` + conversión a WAV para IA
9. Transcripción de mayor calidad por mejor audio fuente

---

## Observaciones del Análisis

**Notas técnicas importantes detectadas**:

1. **Arquitectura Frame-driven**: El sistema usa una arquitectura de "frames" en `FRAMES/` que permite diferentes implementaciones por integración CRM (Teamleader, Sage 50, etc.). Esto es CRÍTICO para entender el código - los archivos en la raíz (`conf.py`, `cuadro.py`, `procesos.py`) son shims que delegan al frame activo resuelto por variable de entorno o rama git.

2. **Sistema de tareas TareaV2 altamente optimizado**: `miratelefono_tareas_proceso.py:TareaV2` no es un simple task runner - incluye ThreadPoolExecutor, GestorCSV con cache, validación de audio pre-IA, recuperación post-apagón y A/B testing de prompts. Este es el CORAZÓN del sistema y debe documentarse exhaustivamente.

3. **Bootstrap en dos fases**: `centralita.py:ApplicationBootstrap` separa validación de entorno (`validate_environment`) de carga de módulos pesados. Services "deferred" (métricas, circuit breakers, health checks) se inician en segundo plano para no bloquear el arranque. Esto es CRÍTICO para UX de arranque rápido.

4. **Limpieza de audio como paso obligatorio**: `libwertyaudiolimpieza.py` no es opcional - el sistema valida TODOS los audios antes de enviarlos a IA (tamaño mínimo 4096 bytes, duración > 0.8s, checksum SHA256). Esto evita WASTEAR créditos API en audios corruptos.

5. **Integración OBS es opcional pero compleja**: El modo `modulos#audio=2` requiere OBS Studio ejecutándose, WebSocket conectado, y escena configurada. El modo 1 (grabación interna) es mucho más simple y funciona out-of-the-box. Documentar AMBOS modos claramente.

6. **CSV como base de datos distribuida**: `hojatiempo.csv` no es solo un log - es el MECANISMO DE RECUPERACIÓN del sistema. Si el CSV se corrompe o se borra, se pierde la capacidad de recuperar llamadas tras apagones. Debe documentarse cómo hacer backup de este archivo.

7. **Configuración en tiempo real sin reinicio**: `control_stream_config()` en `FRAMES/conf.py` detecta cambios en `config.ini` via marcador de archivo (mtime) y recarga variables, traductor y configuración de grabación SIN REINICIAR. Esto es crucial para usuarios que ajustan prompts frecuentemente.

8. **Sistema de licencias basado en addon**: La licencia (`apiteam.lic[1]["addon"]`) controla qué módulos están activos (ia, cuadro, buscar, etc.). Las funciones checkean licencia antes de ejecutar: `if self.core.variable.apicrm.lic[1]["addon"]["ia"]:`. Esto debe documentarse para soporte.

9. **System tray como menú dinámico**: El menú se construye dinámicamente según licencia y configuración - si `cuadro` no está en licencia, no aparece "Cuadro Mando". Si `windows#appandroid=False`, no se inicia RemotePhoneService.

10. **Logs estructurados pero monolíticos**: `log_centralita.log` usa logging Python con niveles DEBUG/INFO/WARNING/ERROR. El archivo puede crecer sin límite - no hay rotación de logs implementada. Para producción de larga duración, recomendar logrotate o configurar `RotatingFileHandler`.

---

## Archivos Clave Referenciados

- **`centralita.py`**: Bootstrap de aplicación con validación de entorno, logging estructurado y cleanup de procesos rs.exe. Punto de entrada principal.

- **`miratelefono_ia.py`**: Clase principal `MiraTelefono` que orquesta todos los componentes (Core, API, Recording, TaskManager, CallProcessor, GUI). Contiene bucle principal y lógica de cleanup.

- **`miratelefono_tareas_proceso.py`**: CORAZÓN del sistema. `TareaV2` gestiona grabación, IA, backup y plantillas con ThreadPoolExecutor. `GestorCSV` persiste estado para recuperación post-apagón. `FabricaTareas` crea trabajos especializados.

- **`FRAMES/conf.py`**: Configuración unificada con `Conf` class que maneja Teamleader API, idiomas (gettext), licencias y recarga en caliente de configuración. CRÍTICO: método `control_stream_config()` permite recarga sin reinicio.

- **`FRAMES/cuadro.py`**: `libwertyCuadro` lanza instancias Streamlit (config, hojatiempo, prenota, nota) en puertos específicos (8501-8504, 8585) y gestiona procesos rs.exe en builds PyInstaller.

- **`FRAMES/procesos.py`** (inferido): Contiene `buscateam()` para lookup CRM y `trigger_lookup_side_effects()` para efectos secundarios (abrir URL, crear nota). Debe implementarse por frame (Teamleader, Sage 50).

- **`miratelefono_phone_processor.py`**: `PhoneProcessor.classify_for_call_routing()` normaliza números telefónicos, detecta extensiones internas y determina tipo de llamada (entrante/saliente/interna).

- **`libwertyaudiolimpieza.py`**: `AudioCleaner.prepare_wav_for_ia()` valida y limpia audios antes de enviarlos a IA (trim de silencio, validación tamaño/duración, checksum SHA256). PREVIENE WASTE de créditos API.

- **`miratelefono_circuit_breaker.py`**: `CircuitBreakerManager` aísla fallos en cascada de APIs externas (OBS, Teamleader). Pattern circuit breaker con estados CLOSED/OPEN/HALF_OPEN.

- **`miratelefono_health_checks.py`**: `health_checker` registra comprobaciones de estado para OBS Studio y API CRM con endpoints de métricas en puerto 8000.

- **`FRAMES/streamlit_supervisor.py`**: `initialize_supervisor()` crea supervisor que gestiona múltiples instancias Streamlit, cierra por inactividad y previene procesos zombies. CRÍTICO para gestión de memoria en uso prolongado.

- **`config.ini`**: Archivo de configuración MONOLÍTICO que controla TODO: API keys ([API]), rutas audio ([AUDIO]), módulos activos ([MODULOS]), prompts IA ([IA]), OBS ([OBS]), backup ([BACKUP]), idioma/tema ([WINDOWS]).

- **`FRAMES/config_glosario.py`**: Define constantes de aplicación (`DEFAULT_IA_NAME`, `LICENCIAS_CENTRALITA`, `build_app_name`, `resolve_ia_name`). Modificar para rebranding.

- **`manual/`**: Directorio con documentación Markdown para usuarios (ayuda.md, configuracion.md, uso-diario.md, instalacion.md, incidencias.md, teamleader.md). ESTA ES LA DOCUMENTACIÓN DE USUARIO que el Writer Agent debe usar como base.

- **`miratelefono_backup.py`**: `BackupManager` programa backups periódicos según configuración `backup#tiempo_backup` y `backup#dirbackup`. Detecta cambios en datos antes de ejecutar.

- **`miratelefono_premiun.py`**: `PromptVersionManager` implementa sistema A/B testing de prompts IA con versionado, asignación aleatoria y medición de effectiveness. Para optimización continua.

- **`FRAMES/README.md`**: Documenta arquitectura de frames para múltiples integraciones CRM. LEE ESTO PRIMERO si vas a agregar soporte para nuevo CRM.
