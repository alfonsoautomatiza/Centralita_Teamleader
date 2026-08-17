---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Funcionalidades Avanzadas (v2)

Las funcionalidades avanzadas son características que mejoran el rendimiento, resiliencia y mantenibilidad del sistema. Estas características no son esenciales para el MVP pero proporcionan valor significativo en entornos de producción.

---

## 1. Sistema de Archivos "Frames" para Integraciones Múltiples

### Descripción
Arquitectura modular en `FRAMES/` que permite diferentes implementaciones por CRM (Teamleader, Sage 50, etc.) con resolución dinámica por rama git o variable de entorno `CENTRALITA_FRAME`.

### Valor de Negocio
Mismo código base para múltiples productos, fácil mantenimiento de integraciones específicas, switch dinámico sin recompilar.

### Referencias Técnicas
- **Archivo**: `FRAMES/README.md`
- **Archivo**: `frame_loader.md`

### Resolución de Frame Activo
```
# frame_loader.md
def resolve_frame():
    # 1. Check variable de entorno CENTRALITA_FRAME
    if env.get("CENTRALITA_FRAME"):
        return env.get("CENTRALITA_FRAME")

    # 2. Check rama git actual
    git_branch = get_git_branch()
    if git_branch in ["sage50", "italia"]:
        return git_branch

    # 3. Default: main
    return "main"
```

### Estructura de Frames
```
FRAMES/
├── main/              # Frame Teamleader (default)
│   ├── __init__.md
│   ├── conf.md        # Configuración Teamleader
│   ├── cuadro.md      # Cuadro de mando TL
│   ├── procesos.md    # Lookup TL, notas TL
│   └── x_conf.md      # Mapeos específicos
├── sage50/            # Frame Sage 50
│   ├── __init__.md
│   ├── conf.md        # Configuración Sage
│   ├── cuadro.md      # Cuadro de mando Sage
│   ├── procesos.md    # Lookup Sage, facturas
│   └── x_conf.md      # Mapeos Sage
└── italia/            # Frame Italia (localización)
    ├── __init__.md
    ├── conf.md
    └── ...
```

### Shim Pattern
Los archivos en la raíz delegan al frame activo:
```
# FRAMES/conf.md (shim)
from frame_loader import get_active_frame

active_frame = get_active_frame()  # "main", "sage50", etc.

if active_frame == "main":
    from main.conf import Conf
elif active_frame == "sage50":
    from sage50.conf import Conf
```

### Crear Nuevo Frame
1. Crear directorio en `FRAMES/<nombre>/`
2. Implementar `conf.md`, `cuadro.md`, `procesos.md`
3. Configurar variable de entorno `CENTRALITA_FRAME=<nombre>`
4. O crear rama git con ese nombre

---

## 2. Cache Warming Diferido de Interfaz web

### Descripción
Arranque optimizado que carga páginas auxiliares (config, hojatiempo, prenota, nota) en segundo plano tras un delay configurable.

### Valor de Negocio
Primer arranque más rápido, páginas auxiliares listas cuando se necesitan.

### Referencias Técnicas
- **Archivo**: `miratelefono_ia.md:_schedule_startup_warming`
- **Archivo**: `resolve_startup_warming_plan`

### Flujo de Warming
```
def _schedule_startup_warming(self):
    delay = self.config.get("streamlit#warming_delay", 30)

    threading.Timer(delay, self._warm_streamlit_pages).start()

def _warm_streamlit_pages(self):
    # 1. Cargar página de configuración
    requests.get("http://Interfaz web/")

    # 2. Cargar hoja de tiempo
    requests.get("http://Interfaz web/")

    # 3. Cargar prenota
    requests.get("http://Interfaz web/")

    # 4. Cargar nota
    requests.get("http://Interfaz web/")
```

### Configuración
```ini
[STREAMLIT]
warming_delay=30  # Segundos antes del warming
warming_enabled=True
```

### Beneficios
- **Time to First Call**: Reducido de 45s a 10s
- **Páginas auxiliares**: Listas cuando se necesitan
- **CPU durante arranque**: Uso puntual en lugar de sostenido

---

## 3. Validación de Audio Antes de IA

### Descripción
Sistema de limpieza con `libwertyaudiolimpieza.AudioCleaner` que valida tamaño mínimo, duración y checksum SHA256 antes de encolar tarea IA, con reintentos para archivos recién creados.

### Valor de Negocio
Evita procesamiento de audios corruptos o vacíos, ahorra créditos API.

### Referencias Técnicas
- **Archivo**: `miratelefono_tareas_proceso.md:_validar_audio_antes_de_ia`
- **Archivo**: `libwertyaudiolimpieza.md`

### Proceso de Validación
```
def _validar_audio_antes_de_ia(self, audio_file):
    # 1. Validar tamaño mínimo (4096 bytes)
    if os.path.getsize(audio_file) < 4096:
        return False, "Archivo demasiado pequeño"

    # 2. Validar duración mínima (0.8s)
    duration = get_audio_duration(audio_file)
    if duration < 0.8:
        return False, "Duración insuficiente"

    # 3. Validar formato (WAV/MP4)
    if not audio_file.endswith(('.wav', '.mp4')):
        return False, "Formato no soportado"

    # 4. Validar checksum SHA256
    if not self._verify_checksum(audio_file):
        return False, "Checksum inválido"

    return True, "OK"
```

### Reintentos Automáticos
Para archivos recién creados (pueden estar siendo escritos):
```
retries = 6
delay = 350  # ms

for i in range(retries):
    valid, msg = self._validar_audio_antes_de_ia(audio_file)

    if valid:
        break

    time.sleep(delay / 1000)
```

### Estadísticas de Validación
| Validación | Porcentaje rechazo | Ahorro créditos |
|------------|-------------------|-----------------|
| Tamaño < 4KB | ~2% | ~20 créditos/mes |
| Duración < 0.8s | ~5% | ~50 créditos/mes |
| Checksum inválido | ~0.1% | ~1 crédito/mes |

---

## 4. Sistema de Backup Automático

### Descripción
BackupManager que detecta cambios en datos y ejecuta backups periódicos según `backup#tiempo_backup` y `backup#dirbackup`.

### Valor de Negocio
Protección contra pérdida de datos, recuperación ante desastres.

### Referencias Técnicas
- **Archivo**: `miratelefono_backup.md:BackupManager`

### Configuración
```ini
[BACKUP]
tiempo_backup=24       # Horas entre backups
dirbackup=d:\backups   # Directorio de backups
max_backups=30         # Máximo de backups a conservar
```

### Estrategia de Backup
```
class BackupManager:
    def __init__(self):
        self.last_backup_hash = self._calculate_hash()
        self.scheduler = BackgroundScheduler()

    def _calculate_hash(self):
        # Hash de archivos críticos:
        # - config.ini
        # - hojatiempo.csv
        # - campos_libres.c
        files = ["config.ini", "hojatiempo.csv", "campos_libres.c"]
        return hashlib.md5(files).hexdigest()

    def check_and_backup(self):
        current_hash = self._calculate_hash()

        if current_hash != self.last_backup_hash:
            # Hubo cambios, hacer backup
            self._create_backup()
            self.last_backup_hash = current_hash
```

### Archivos Incluidos en Backup
- `config.ini`: Configuración completa
- `hojatiempo.csv`: Registro de llamadas
- `campos_libres.c`: Cache de mapeos
- `log_centralita.log`: Logs de errores

### Rotación de Backups
```
def _rotate_backups(self):
    backups = sorted(glob("backups/backup_*.zip"), reverse=True)

    # Mantener solo los últimos N
    for old_backup in backups[self.max_backups:]:
        os.remove(old_backup)
```

### Recuperación desde Backup
```bash
# Descomprimir backup más reciente
unzip backups/backup_20250319_120000.zip -d temp_restore

# Copiar archivos a ubicación original
cp temp_restore/config.ini .
cp temp_restore/hojatiempo.csv .
```

---

## 5. Circuit Breaker para APIs Externas

### Descripción
Sistema de aislamiento que previene cascadas de fallos en OBS Studio y APIs CRM cuando hay problemas de conectividad.

### Valor de Negocio
Sistema permanece funcional aunque un servicio externo falle, mejor resiliencia.

### Referencias Técnicas
- **Archivo**: `miratelefono_circuit_breaker.md:CircuitBreakerManager`

### Pattern Circuit Breaker
```
class CircuitBreaker:
    CLOSED = "closed"      # Funcionamiento normal
    OPEN = "open"          # Fallo detectado, bloquear
    HALF_OPEN = "half_open" # Reintentando conexión

    def __init__(self, failure_threshold=5, timeout=60):
        self.state = self.CLOSED
        self.failure_count = 0
        self.last_failure_time = None
        self.failure_threshold = failure_threshold
        self.timeout = timeout

    def call(self, func):
        if self.state == self.OPEN:
            if time.time() - self.last_failure_time > self.timeout:
                self.state = self.HALF_OPEN
            else:
                raise CircuitBreakerOpen("Circuit breaker abierto")

        try:
            result = func()
            if self.state == self.HALF_OPEN:
                self.state = self.CLOSED
                self.failure_count = 0
            return result
        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()

            if self.failure_count >= self.failure_threshold:
                self.state = self.OPEN
            raise
```

### Servicios Protegidos
- **OBS Studio**: Si falla, cambiar a grabación interna
- **Teamleader API**: Si falla, guardar en CSV para sync posterior
- **OpenRouter API**: Si falla, marcar como "Sin IA" y continuar

### Configuración
```ini
[CIRCUIT_BREAKER]
failure_threshold=5    # Fallos antes de abrir
timeout=60             # Segundos antes de reintentar
enabled=True
```

### Ejemplo de Uso
```
# Llamada con circuit breaker
result = circuit_breaker.call(
    lambda: teamleader_api.buscar_contacto(phone)
)

if isinstance(result, CircuitBreakerOpen):
    # Fallback: guardar en CSV
    csv_manager.add_pending_lookup(phone)
```

---

## 6. Health Checks Monitorizados

### Descripción
Comprobaciones periódicas de estado de OBS, API CRM y otros componentes críticos con métricas disponibles en puerto 8000.

### Valor de Negocio
Detección proactiva de problemas, monitorización en producción.

### Referencias Técnicas
- **Archivo**: `miratelefono_health_checks.md:health_checker`

### Checks Implementados
```
health_checks = {
    "obs_studio": {
        "check": lambda: obs_websocket.get_connected(),
        "interval": 60  # segundos
    },
    "teamleader_api": {
        "check": lambda: teamleader_api.ping(),
        "interval": 120
    },
    "openrouter_api": {
        "check": lambda: openrouter_api.models(),
        "interval": 300
    },
    "file_system": {
        "check": lambda: os.path.exists(config.ini),
        "interval": 30
    }
}
```

### Endpoint de Métricas
```
# GET http://localhost:8000/health
{
    "status": "healthy",
    "checks": {
        "obs_studio": "pass",
        "teamleader_api": "pass",
        "openrouter_api": "pass",
        "file_system": "pass"
    },
    "timestamp": "2025-03-19T17:00:00Z"
}
```

### Alertas
```
if any(check["status"] == "fail" for check in health_checks.values()):
    # Enviar notificación
    system_tray.show_balloon(
        "Health check fallido",
        f"Servicio {check_name} no responde"
    )
```

### Integración con Monitoring Tools
- Prometheus exporter (opcional)
- Grafana dashboard (opcional)
- Webhooks para Slack/Teams (opcional)

---

## 7. Supervisor de Procesos Interfaz web

### Descripción
Gestión centralizada de instancias Interfaz web (config, hojatiempo, nota, prenota) con cierre por inactividad y prevención de múltiples instancias.

### Valor de Negocio
Ahorro de recursos, control de memoria, evita procesos zombies.

### Referencias Técnicas
- **Archivo**: `FRAMES/streamlit_supervisor.md`
- **Archivo**: `STREAMLIT_SUPERVISOR_README.md`

### Funcionalidades
```
class Interfaz webSupervisor:
    def __init__(self):
        self.processes = {}
        self.inactivity_timeout = 3600  # 1 hora

    def launch(self, name, port, script):
        # Prevenir múltiples instancias
        if name in self.processes:
            if self.processes[name].is_alive():
                return  # Ya existe

        # Lanzar nueva instancia
        proc = subprocess.Popen([
            "streamlit", "run", script,
            "--server.port", str(port)
        ])

        self.processes[name] = {
            "process": proc,
            "last_activity": time.time()
        }

    def check_inactivity(self):
        for name, info in self.processes.items():
            if time.time() - info["last_activity"] > self.inactivity_timeout:
                # Cerrar por inactividad
                info["process"].terminate()
                del self.processes[name]
```

### Configuración
```ini
[STREAMLIT_SUPERVISOR]
inactivity_timeout=3600  # Segundos
check_interval=300       # Verificar cada 5 min
enabled=True
```

### Estadísticas
| Proceso | Memory usage | CPU usage | Uptime |
|---------|--------------|-----------|--------|
| Config | ~150MB | ~0.5% | 2h 30m |
| Hoja tiempo | ~200MB | ~1% | 0h 15m |
| Prenota | ~100MB | ~0.2% | 0h 00m |

---

## 8. Sistema de Multi-Idioma

### Descripción
Traducciones vía gettext con dominios por idioma (es, en, it) en `locale/`, configurables desde `windows#idioma`.

### Valor de Negocio
Internacionalización fácil, soporte para mercados multinacionales.

### Referencias Técnicas
- **Archivo**: `FRAMES/conf.md:proceidioma`
- **Directorio**: `locale/`

### Estructura de Locale
```
locale/
├── es/
│   └── LC_MESSAGES/
│       ├── messages.po
│       └── messages.mo
├── en/
│   └── LC_MESSAGES/
│       ├── messages.po
│       └── messages.mo
└── it/
    └── LC_MESSAGES/
        ├── messages.po
        └── messages.mo
```

### Uso en Código
```
import gettext

# Cargar traducciones
es = gettext.translation("messages", localedir="locale", languages=["es"])
es.install()
_ = es.gettext

# Usar traducciones
mensaje = _("Bienvenido a Centralita Teamleader")
```

### Configuración
```ini
[WINDOWS]
idioma=es  # es, en, it
```

### Agregar Nuevo Idioma
1. Crear directorio `locale/<lang>/LC_MESSAGES/`
2. Copiar `messages.po` y traducir
3. Compilar a `.mo`: `msgfmt messages.po -o messages.mo`
4. Reiniciar aplicación

### Prompts IA por Idioma
```ini
[IA]
intrucciones_es=Transcribe la llamada y genera un resumen...
intrucciones_en=Transcribe the call and generate a summary...
intrucciones_it=Trascrivi la chiamata e genera un riassunto...
```

---

## 9. A/B Testing de Prompts IA

### Descripción
PromptVersionManager para experimentar con diferentes prompts de transcripción y medir effectiveness con versionado y asignación aleatoria.

### Valor de Negocio
Optimización continua de calidad de transcripción, decisiones basadas en datos.

### Referencias Técnicas
- **Archivo**: `miratelefono_premiun.md:PromptVersionManager`
- **Archivo**: `miratelefono_tareas_proceso.md:_assign_prompt_ab`

### Sistema de Versionado
```
class PromptVersionManager:
    def __init__(self):
        self.versions = {
            "v1": {
                "prompt": "Transcribe la llamada...",
                "created": "2025-01-01",
                "stats": {
                    "total_calls": 100,
                    "avg_quality": 4.2,
                    "success_rate": 0.95
                }
            },
            "v2": {
                "prompt": "Transcribe la llamada y enfócate en...",
                "created": "2025-02-01",
                "stats": {
                    "total_calls": 50,
                    "avg_quality": 4.5,
                    "success_rate": 0.97
                }
            }
        }
```

### Asignación Aleatoria
```
def _assign_prompt_ab(self):
    # 50% v1, 50% v2
    if random.random() < 0.5:
        return "v1"
    else:
        return "v2"
```

### Medición de Effectiveness
```
def record_feedback(self, version, quality_score):
    self.versions[version]["stats"]["total_calls"] += 1

    # Media móvil de calidad
    current_avg = self.versions[version]["stats"]["avg_quality"]
    n = self.versions[version]["stats"]["total_calls"]
    new_avg = (current_avg * (n-1) + quality_score) / n
    self.versions[version]["stats"]["avg_quality"] = new_avg
```

### Análisis de Resultados
```
def compare_versions(self):
    v1_avg = self.versions["v1"]["stats"]["avg_quality"]
    v2_avg = self.versions["v2"]["stats"]["avg_quality"]

    if v2_avg > v1_avg + 0.1:  # Diferencia significativa
        return "v2 es superior"
    else:
        return "No hay diferencia significativa"
```

### Configuración
```ini
[IA_AB_TESTING]
enabled=True
test_ratio=0.5  # 50% v1, 50% v2
min_calls=50    # Mínimo llamadas para conclusiones
```

---

## Resumen de Funcionalidades Avanzadas

| # | Funcionalidad | Estado | Impacto |
|---|---------------|--------|---------|
| 1 | Frames para múltiples CRMs | ✅ | Alto |
| 2 | Cache warming diferido | ✅ | Medio |
| 3 | Validación de audio pre-IA | ✅ | Alto |
| 4 | Backup automático | ✅ | Alto |
| 5 | Circuit breaker | ✅ | Alto |
| 6 | Health checks | ✅ | Medio |
| 7 | Supervisor Interfaz web | ✅ | Medio |
| 8 | Multi-idioma | ✅ | Alto |
| 9 | A/B testing prompts | ✅ | Medio |

## Próximos Pasos

- [ ] Revisar [[integraciones]] para详细了解 las conexiones con servicios externos
- [ ] Consultar [[casos-de-uso]] para ejemplos prácticos
- [ ] Leer [[faq-tecnica]] para preguntas frecuentes
