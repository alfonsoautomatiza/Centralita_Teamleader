---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Funcionalidades Core (MVP)

Las funcionalidades core son el conjunto mínimo de características que definen el Producto Mínimo Viable (MVP) de la Centralita Teamleader. Estas funcionalidades son esenciales para el funcionamiento básico del sistema.

---

## 1. Detección Automática de Llamadas

### Descripción
Integración con `RemotePhoneService.dll` para detectar estados de llamada (Idle/OffHook/Connected) y obtener el número telefónico activo automáticamente.

### Valor de Negocio
Automatiza todo el flujo sin intervención manual, activando grabación y lookups CRM automáticamente. El usuario no necesita recordar iniciar ningún proceso.

### Referencias Técnicas
- **Archivo**: `miratelefono_ia.py:CallProcessor`
- **Archivo**: `miratelefono_phone_processor.py`

### Estados de Llamada

| Estado | Descripción | Acción Triggered |
|--------|-------------|------------------|
| **Idle** | No hay llamada activa | Esperar próxima llamada |
| **OffHook** | Teléfono descolgado (llamada entrante/saliente) | Iniciar grabación, buscar en CRM |
| **Connected** | Llamada conectada | Continuar grabación |
| **OnHook** | Teléfono colgado | Detener grabación, procesar IA |

### Flujo de Detección
```python
# miratelefono_phone_processor.py
def classify_for_call_routing(phone_number):
    # 1. Normalizar número (+34, prefijos)
    # 2. Detectar extensiones internas
    # 3. Determinar tipo (entrante/saliente/interna)
    # 4. Retornar clasificación
```

### Configuración
```ini
[WINDOWS]
appandroid=True  # Habilita RemotePhoneService
```

---

## 2. Grabación de Audio Multiformato

### Descripción
Soporte para grabación interna (WAV vía PyAudio) y externa (MP4 vía OBS Studio) con cambio dinámico según configuración `modulos#audio`.

### Valor de Negocio
Flexibilidad para diferentes entornos. OBS ofrece mejor calidad pero requiere setup; modo interno funciona out-of-the-box sin configuración adicional.

### Modos de Grabación

| Modo | Valor | Método | Calidad | Configuración |
|------|-------|--------|---------|---------------|
| **Desactivado** | 0 | No graba | N/A | `modulos#audio=0` |
| **Interna** | 1 | PyAudio (WAV) | Estándar | `modulos#audio=1` |
| **OBS** | 2 | OBS Studio (MP4) | Alta | `modulos#audio=2` |

### Grabación Interna (Modo 1)
**Referencias**: `miratelefono_tareas_proceso.py:crear_trabajo_grabar`, `libwertyaudiolimpieza.py`

**Ventajas**:
- Funciona out-of-the-box
- No requiere software adicional
- Grabación de micrófono

**Limitaciones**:
- Solo captura audio de micrófono
- No graba audio del sistema (softphones)
- Calidad estándar

### Grabación OBS (Modo 2)
**Referencias**: `miratelefono_tareas_proceso.py:tarea_obs`

**Ventajas**:
- Alta calidad de audio
- Captura ambos lados de conversación
- Compatible con softphones VoIP

**Requisitos**:
- OBS Studio instalado y ejecutándose
- Plugin `obs-browser-source` configurado
- Escena de audio configurada

**Configuración**:
```ini
[OBS]
obs_activo=True
obs_host=localhost
obs_port=4455
obs_password=...
```

### Validación de Audio
**Referencia**: `libwertyaudiolimpieza.py:AudioCleaner`

Todos los audios son validados antes del procesamiento:
- **Tamaño mínimo**: 4096 bytes
- **Duración mínima**: 0.8 segundos
- **Formato válido**: WAV/MP4
- **Checksum SHA256**: Integridad de archivo

---

## 3. Transcripción IA de Llamadas

### Descripción
Procesamiento automático del audio grabado con OpenRouter API (modelos como Google Gemini 2.5 Flash Lite) generando resúmenes estructurados.

### Valor de Negocio
Elimina la necesidad de tomar notas manuales, proporciona resúmenes accionables de cada llamada con puntos clave, decisiones y siguientes pasos.

### Referencias Técnicas
- **Archivo**: `miratelefono_tareas_proceso.py:crear_trabajo_ia`
- **Archivo**: `libwertyIA.py`
- **Configuración**: `config.ini:[IA]`

### Flujo de Transcripción
```python
# miratelefono_tareas_proceso.py
def crear_trabajo_ia(self, audio_file):
    # 1. Validar audio (tamaño, duración, formato)
    # 2. Convertir a formato compatible
    # 3. Enviar a OpenRouter API
    # 4. Procesar respuesta (resumen estructurado)
    # 5. Guardar resultado en CSV
    # 6. Crear nota en CRM si está configurado
```

### Configuración
```ini
[IA]
api_key=sk-or-...
modelo=google/gemini-2.5-flash-lite
intrucciones=Transcribe la llamada y genera un resumen con:
- Puntos clave discutidos
- Decisiones tomadas
- Siguientes pasos
- Objeciones o preocupaciones
```

### A/B Testing de Prompts
**Referencia**: `miratelefono_premiun.py:PromptVersionManager`

Sistema para experimentar con diferentes prompts:
- Versionado de prompts
- Asignación aleatoria (A/B)
- Medición de effectiveness
- Optimización continua

### Output de Transcripción
La IA genera un resumen estructurado con:
- **Resumen ejecutivo**: Breve descripción de la llamada
- **Puntos clave**: Topics discutidos
- **Decisiones tomadas**: Acuerdos y compromisos
- **Siguientes pasos**: Acciones a realizar
- **Objeciones**: Preocupaciones del cliente
- **Información de contacto**: Datos relevantes mencionados

---

## 4. Integración Bidireccional con Teamleader

### Descripción
Búsqueda automática de contactos/empresas por número telefónico al recibir llamada, apertura de ficha CRM en navegador, y creación de notas/pre-notas con datos de la llamada.

### Valor de Negocio
Centraliza toda la información del cliente en un solo lugar, reduce tiempo de búsqueda manual y asegura que todos los datos estén actualizados.

### Referencias Técnicas
- **Archivo**: `FRAMES/procesos.py:buscateam`
- **Archivo**: `FRAMES/cuadro.py:nota`
- **Archivo**: `apitl.py`

### Flujo de Integración
```python
# FRAMES/procesos.py
def buscateam(phone_number):
    # 1. Buscar contactos por número
    # 2. Buscar empresas por número
    # 3. Retornar primera coincidencia
    # 4. Si no hay coincidencia, retornar None

def trigger_lookup_side_effects(entity):
    # 1. Abrir ficha en navegador
    # 2. Crear nota con datos de llamada
    # 3. Actualizar hoja de tiempo
```

### Configuración OAuth2
```ini
[API]
client_id=your_client_id
client_secret=your_client_secret
tl_access_token=...
tl_refresh_token=...
```

### Operaciones Disponibles

| Operación | Método | Descripción |
|-----------|--------|-------------|
| **Buscar contacto** | `GET /contacts.find` | Búsqueda por teléfono |
| **Buscar empresa** | `GET /companies.find` | Búsqueda por teléfono |
| **Crear nota** | `POST /notes` | Crear nota en ficha |
| **Crear pre-nota** | `POST /prenotes` | Para nuevos clientes |
| **Actualizar deal** | `PATCH /deals/{id}` | Actualizar desde llamada |

### Campos Libres
Mapeo de campos personalizados:
```ini
[API]
camposlibres=campo_origen<-->campo_destino
```

Codificado en `bs4` para seguridad.

---

## 5. Interfaz de System Tray

### Descripción
Menú tray con acceso rápido a búsquedas manuales, última llamada, hoja de tiempo, configuración web y apagado controlado.

### Valor de Negocio
Acceso permanente sin interferir con workflow, notificaciones visuales de grabación activa.

### Referencias Técnicas
- **Archivo**: `miratelefono_ia.py:GUIComponents`
- **Archivo**: `miratelefono_sg.py`

### Menú Tray
```python
menu = [
    "🔍 Buscar número...",      # Búsqueda manual
    "📞 Última llamada",         # Info última llamada
    "📋 Hoja de tiempo",         # Streamlit en puerto 8501
    "⚙️ Configuración",          # Streamlit en puerto 8585
    "----------------",
    "❌ Salir"                   # Apagado controlado
]
```

### Notificaciones Visuales
- **Icono rojo**: Grabación activa
- **Icono verde**: Sistema listo
- **Icono amarillo**: Procesando IA
- **Balloon tips**: Alertas importantes

### Configuración
```ini
[WINDOWS]
tema=DarkBlue16  # Tema visual PySimpleGUI
icono_tray=icono.ico
```

---

## 6. Gestión de Tareas en Segundo Plano

### Descripción
Sistema TareaV2 con ThreadPoolExecutor para grabación, IA, backup y plantillas simultáneas sin bloquear interfaz.

### Valor de Negocio
Sistema responsivo, múltiples operaciones en paralelo, mejor uso de recursos.

### Referencias Técnicas
- **Archivo**: `miratelefono_tareas_proceso.py:TareaV2`
- **Archivo**: `miratelefono_tareas_proceso.py:GestorCSV`

### Arquitectura de Tareas
```python
class TareaV2:
    def __init__(self):
        self.executor = ThreadPoolExecutor(max_workers=4)

    def enqueue_grabacion(self, audio_file):
        self.executor.submit(self.procesar_grabacion, audio_file)

    def enqueue_ia(self, audio_file):
        self.executor.submit(self.procesar_ia, audio_file)

    def enqueue_backup(self):
        self.executor.schedule(self.procesar_backup, delay=24h)
```

### Tareas Simultáneas
El sistema puede ejecutar:
- ✅ Grabación de audio
- ✅ Transcripción IA de llamadas anteriores
- ✅ Backup automático
- ✅ Procesamiento de plantillas

Todo sin bloquear la interfaz ni la detección de nuevas llamadas.

### GestorCSV
Persistencia de estado con cache:
- Lectura optimizada con cache en memoria
- Escritura inmediata (no batch)
- Recuperación post-apagón

---

## 7. Configuración Web via Streamlit

### Descripción
Interface en `http://localhost:8585/` para ajustar parámetros en tiempo real con recarga en caliente (detección de cambios en `config.ini`).

### Valor de Negocio
Modificación de configuración sin reiniciar aplicación, ideal para usuarios no técnicos.

### Referencias Técnicas
- **Archivo**: `_internal/config.py`
- **Archivo**: `FRAMES/conf.py:control_stream_config`

### Pantallas de Configuración

#### 1. Configuración General
- Idioma de la interfaz
- Tema visual
- Módulos activos

#### 2. Configuración API
- Credenciales Teamleader
- Tokens OAuth2
- Campos libres mapeo

#### 3. Configuración IA
- API Key OpenRouter
- Modelo a usar
- Prompt de instrucciones
- Tags de IA

#### 4. Configuración Audio
- Modo de grabación (0/1/2)
- Rutas de archivos
- Formato de salida

#### 5. Configuración OBS
- Host y puerto WebSocket
- Password de conexión
- Escena de grabación

### Recarga en Caliente
```python
# FRAMES/conf.py
def control_stream_config(self):
    current_mtime = os.path.getmtime("config.ini")

    if current_mtime != self.last_mtime:
        # Recargar variables
        self.recargar_configuracion()
        # Reiniciar traductor
        self.reiniciar_traductor()
        # Actualizar configuración de grabación
        self.actualizar_grabacion()
```

**Sin reiniciar**: Los cambios se aplican inmediatamente sin necesidad de cerrar y abrir la aplicación.

---

## Resumen de Funcionalidades Core

| # | Funcionalidad | Estado | Crítico |
|---|---------------|--------|---------|
| 1 | Detección automática de llamadas | ✅ | Sí |
| 2 | Grabación de audio multiformato | ✅ | Sí |
| 3 | Transcripción IA de llamadas | ✅ | Sí |
| 4 | Integración Teamleader | ✅ | Sí |
| 5 | Interfaz system tray | ✅ | No |
| 6 | Gestión de tareas en background | ✅ | Sí |
| 7 | Configuración web Streamlit | ✅ | No |

## Próximos Pasos

- [ ] Revisar [[funcionalidades-avanzadas]] para características v2
- [ ] Consultar [[integraciones]] para detallar conexiones con servicios
- [ ] Ver [[casos-de-uso]] para ejemplos prácticos de uso
- [ ] Leer [[faq-tecnica]] para preguntas frecuentes
