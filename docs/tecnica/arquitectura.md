---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Arquitectura del Sistema

## Contexto de la Aplicación

### Descripción
Sistema de gestión de llamadas con IA que integra telefonía, grabación de audio, transcripción automática con inteligencia artificial y sincronización con CRMs como Teamleader. Centraliza la gestión de llamadas entrantes/salientes, automatiza el resumen de conversaciones y mantiene un registro estructurado de todas las interacciones.

### Stack Tecnológico
- **Python 3.13+**: Lenguaje principal del sistema
- **Streamlit**: Interfaces web de configuración y gestión
- **PySimpleGUI**: System tray y menú de notificaciones
- **OBS Studio**: Grabación de audio del sistema (opcional)
- **OpenRouter API**: Transcripción con IA (Google Gemini)
- **Teamleader API**: Integración con CRM
- **Tkinter/PyAudio**: Grabación interna de audio
- **PyInstaller**: Empaquetado en ejecutable
- **NumPy/pandas**: Procesamiento de datos
- **Threading/multiprocessing**: Concurrencia de tareas

### Público Objetivo
PYMEs españolas que utilizan Teamleader como CRM y necesitan automatizar la gestión de llamadas telefónicas con transcripción IA, especialmente empresas de servicios, call centers y equipos de ventas.

---

## Arquitectura Frame-Driven

El sistema usa una arquitectura de "frames" en `FRAMES/` que permite diferentes implementaciones por integración CRM (Teamleader, Sage 50, etc.).

### Concepto de Frames
Los archivos en la raíz (`conf.py`, `cuadro.py`, `procesos.py`) son shims que delegan al frame activo resuelto por:
- Variable de entorno `CENTRALITA_FRAME`
- Rama git activa
- Configuración en `config.ini`

### Estructura de Frames
```
FRAMES/
├── main/              # Frame principal (Teamleader)
│   ├── conf.py        # Configuración Teamleader
│   ├── cuadro.py      # Cuadro de mando
│   └── procesos.py    # Procesos específicos TL
├── sage50/            # Frame Sage 50 (si existe)
│   ├── conf.py
│   ├── cuadro.py
│   └── procesos.py
└── README.md          # Documentación de frames
```

### Ventajas
- **Mismo código base** para múltiples productos
- **Fácil mantenimiento** de integraciones específicas
- **Switch dinámico** sin recompilar
- **Aislamiento** de lógica de cada CRM

---

## Componentes Principales

### 1. Bootstrap de Aplicación (`centralita.py`)

**Responsabilidad**: Punto de entrada principal y validación de entorno

**Funcionalidades clave**:
- Validación de entorno Python y dependencias
- Logging estructurado con niveles DEBUG/INFO/WARNING/ERROR
- Cleanup de procesos rs.exe (en builds PyInstaller)
- Inicialización de ApplicationBootstrap

**Patrón**: Bootstrap en dos fases
1. **Fase 1**: Validación de entorno (rápida)
2. **Fase 2**: Carga de módulos pesados (diferida)

---

### 2. Clase Principal (`miratelefono_ia.py`)

**Responsabilidad**: Orquestación de todos los componentes

**Componentes gestionados**:
- **Core**: Configuración y estado global
- **API**: Cliente Teamleader/OAuth
- **Recording**: Grabación de audio (interna/OBS)
- **TaskManager**: Sistema TareaV2
- **CallProcessor**: Detección de estados de llamada
- **GUI**: System tray y menús

**Bucle principal**:
```python
while True:
    # Detectar estado de llamada
    estado = call_processor.get_state()

    if estado == "OffHook":
        # Iniciar grabación
        # Buscar en CRM
        # Abrir ficha cliente

    elif estado == "Connected":
        # Continuar grabación

    elif estado == "Idle":
        # Detener grabación
        # Procesar con IA
        # Crear nota en CRM
```

---

### 3. Sistema de Tareas (`miratelefono_tareas_proceso.py`)

**Responsabilidad**: CORAZÓN del sistema - gestión de grabación, IA, backup y plantillas

### Clase TareaV2
**ThreadPoolExecutor** para ejecución paralela de tareas:

```python
class TareaV2:
    def procesar_grabacion(self, audio_file):
        # Grabación en background

    def procesar_ia(self, audio_file):
        # Transcripción con IA

    def procesar_backup(self):
        # Backup automático

    def procesar_plantillas(self):
        # Procesamiento de plantillas
```

**Características**:
- **Ejecución simultánea** sin bloquear interfaz
- **Validación de audio** pre-IA (evita créditos desperdiciados)
- **Recuperación post-apagón** desde CSV
- **A/B testing** de prompts IA

### GestorCSV
Persistencia de estado en `hojatiempo.csv`:
- Registro de todas las llamadas
- Estado de procesamiento (audio, IA, CRM)
- URLs de notas creadas
- **Recuperación automática** tras corte de luz

---

### 4. Configuración Unificada (`FRAMES/conf.py`)

**Responsabilidad**: Configuración centralizada con recarga en caliente

### Clase Conf
**Funcionalidades**:
- Teamleader API (OAuth2, tokens)
- Sistema de multi-idioma (gettext)
- Gestión de licencias
- **Recarga en caliente** sin reiniciar

**control_stream_config()**:
```python
def control_stream_config(self):
    # Detecta cambios en config.ini via mtime
    # Recarga variables
    # Reinicia traductor
    # Actualiza configuración de grabación
```

---

### 5. Cuadro de Mando (`FRAMES/cuadro.py`)

**Responsabilidad**: Gestión de interfaces Streamlit

### libwertyCuadro
**Instancias gestionadas**:
- **Config**: `http://localhost:8585/`
- **Hoja de tiempo**: `http://localhost:8501/`
- **Prenota**: `http://localhost:8502/`
- **Nota**: `http://localhost:8503/`

**Características**:
- Lanzamiento de instancias Streamlit
- Gestión de procesos rs.exe (PyInstaller)
- Supervisor para evitar múltiples instancias
- Cierre por inactividad

---

## Sistema de Recuperación

### Persistencia en CSV
`hojatiempo.csv` es el **MECANISMO DE RECUPERACIÓN** del sistema:

| Columna | Descripción |
|---------|-------------|
| telefono | Número telefónico |
| fichero | Ruta del audio grabado |
| entidad | Contacto/Empresa encontrada |
| tiempo | Duración de llamada |
| estado | Audio finalizado, IA disponible, etc. |
| url | URL de nota en CRM |

### Recuperación Post-Apagón
```python
def procesocsv_post_apagon():
    # 1. Leer CSV
    # 2. Filtrar filas sin IA
    # 3. Validar archivos existen
    # 4. Relanzar tareas de IA
    # 5. Notificar al usuario
```

---

## Sistema de Validación

### Limpieza de Audio (`libwertyaudiolimpieza.py`)

**AudioCleaner.prepare_wav_for_ia()**:
- **Tamaño mínimo**: 4096 bytes
- **Duración mínima**: 0.8 segundos
- **Formato válido**: WAV/MP4
- **Checksum SHA256**: Integridad de archivo

**Reintentos automáticos**:
- 6 reintentos con 350ms delay
- Para archivos recién creados
- Evita procesamiento prematuro

---

## Integraciones

### Teamleader API
**OAuth2 Flow**:
- `client_id`, `client_secret`
- `tl_access_token`, `tl_refresh_token`
- Refresh automático de tokens

**Operaciones**:
- Búsqueda de contactos/empresas
- Creación de notas/pre-notas
- Lookup por número telefónico

### OBS Studio (WebSocket)
**Control remoto**:
- `obs_websocket` en `python-OBS-websocket`
- `StartRecording` / `StopRecording`
- Grabación de audio del sistema

**Configuración**:
- `obs#obs_host=localhost`
- `obs#obs_port=4455`
- `modulos#audio=2` (modo OBS)

---

## Circuit Breaker

### Aislamiento de Fallos (`miratelefono_circuit_breaker.py`)

**CircuitBreakerManager**:
```python
estados = ["CLOSED", "OPEN", "HALF_OPEN"]

if api_fails:
    circuit_breaker.open()
    # Aislar fallo, usar fallback

if timeout_expires:
    circuit_breaker.half_open()
    # Reintentar conexión
```

**Servicios monitoreados**:
- OBS Studio
- Teamleader API
- OpenRouter API

---

## Health Checks

### Monitorización (`miratelefono_health_checks.py`)

**health_checker**:
- Comprobaciones periódicas de estado
- Métricas en puerto 8000
- Endpoints para monitoring

**Componentes verificados**:
- OBS Studio conectado
- API CRM respondiendo
- Sistema de archivos accesible

---

## Logs y Debugging

### Logging Estructurado
**Niveles**:
- `DEBUG`: Detalles de ejecución
- `INFO`: Eventos importantes
- `WARNING`: Alertas no críticas
- `ERROR`: Errores con traceback

**Archivo**: `log_centralita.log`

**Limitación actual**: Sin rotación de logs. Para producción de larga duración, recomendar `RotatingFileHandler`.

---

## Archivos de Configuración

### config.ini
Archivo MONOLÍTICO que controla TODO:

```ini
[API]
client_id=...
client_secret=...

[AUDIO]
inicio=d:\centralita_ia\rec

[MODULOS]
buscar=1
audio=1
ia=1

[IA]
api_key=...
intrucciones=...

[OBS]
obs_activo=True
obs_host=localhost

[BACKUP]
tiempo_backup=24
dirbackup=d:\backups

[WINDOWS]
idioma=es
tema=DarkBlue16
```

---

## Observaciones Técnicas Importantes

1. **CSV como base de datos distribuida**: `hojatiempo.csv` no es solo un log - es el MECANISMO DE RECUPERACIÓN. Si se corrompe o borra, se pierde la capacidad de recuperar llamadas tras apagones.

2. **Configuración en tiempo real**: `control_stream_config()` permite recargar configuración SIN REINICIAR, crucial para usuarios que ajustan prompts frecuentemente.

3. **Sistema de licencias**: La licencia controla qué módulos están activos. Las funciones checkean licencia antes de ejecutar.

4. **System tray dinámico**: El menú se construye según licencia y configuración - módulos no autorizados no aparecen.

5. **Limpieza de audio obligatoria**: El sistema valida TODOS los audios antes de enviarlos a IA, previniendo WASTE de créditos API.

---

## Archivos Clave

| Archivo | Responsabilidad |
|---------|-----------------|
| `centralita.py` | Punto de entrada |
| `miratelefono_ia.py` | Orquestación principal |
| `miratelefono_tareas_proceso.py` | CORAZÓN del sistema |
| `FRAMES/conf.py` | Configuración unificada |
| `FRAMES/cuadro.py` | Interfaces Streamlit |
| `FRAMES/procesos.py` | Lookup CRM y efectos |
| `miratelefono_phone_processor.py` | Normalización de números |
| `libwertyaudiolimpieza.py` | Validación de audio |
| `miratelefono_circuit_breaker.py` | Aislamiento de fallos |
| `miratelefono_health_checks.py` | Monitorización |
| `config.ini` | Configuración monolítica |

---

## Próximos Pasos

- [ ] Leer [[funcionalidades-core]] para详细了解 las funcionalidades principales
- [ ] Revisar [[funcionalidades-avanzadas]] para características v2
- [ ] Consultar [[integraciones]] para详细了解 las integraciones disponibles
- [ ] Ver [[casos-de-uso]] para ejemplos prácticos
