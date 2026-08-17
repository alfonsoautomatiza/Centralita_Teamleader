---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Preguntas Frecuentes Técnicas (FAQ)

Preguntas técnicas frecuentes sobre la instalación, configuración y uso de la Centralita Teamleader.

---

## Instalación y Configuración

### ¿Cómo se instala?

#### 1. Requisitos Previos
- **Python 3.13+** instalado ([Descargar](https://www.python.org/downloads/))
- **Windows 10/11** (para integración de telefonía)
- **5 MB** de espacio en disco mínimo

#### 2. Instalación
```bash
# 1. Clonar repositorio o descargar ZIP
git clone https://github.com/wertyMSD/Centralita_Teamleader.git
cd Centralita_Teamleader

# 2. Crear entorno virtual
python -m venv .venv

# 3. Activar entorno
.venv\Scripts\activate  # Windows
source .venv/bin/activate  # Linux/Mac

# 4. Instalar dependencias
pip install -r requirements.txt
```

#### 3. Configuración Inicial
```bash
# 1. Copiar config.ini ejemplo
cp config.ini.example config.ini

# 2. Editar config.ini
notepad config.ini
```

**Secciones a configurar**:
```ini
[API]
client_id=your_client_id
client_secret=your_client_secret

[IA]
api_key=sk-or-v1-...

[AUDIO]
inicio=d:\centralita_ia\rec
```

#### 4. Ejecución
```bash
# Modo desarrollo
python centralita.md

# Modo producción (ejecutable)
exe\dist\centralita.exe
```

---

## Integración Teamleader

### ¿Qué pasa si falla la conexión con Teamleader?

El sistema incluye **Circuit Breaker** (`miratelefono_circuit_breaker.md`) que aísla fallos de la API CRM. Si Teamleader no responde:

1. **Las llamadas se siguen grabando y transcribiendo**
2. **Los datos se guardan en `hojatiempo.csv`** con estado pendiente
3. **Un health check periódico reintenta la conexión**
4. **Cuando se restaura, se sincronizan los datos pendientes** manualmente vía "Hoja de tiempo"

```
# Ejemplo de circuit breaker en acción
try:
    contacto = teamleader_api.buscar_contacto(phone)
except CircuitBreakerOpen:
    # Fallback: guardar en CSV para sync posterior
    csv_manager.add_pending_lookup(phone)
    logger.warning("Teamleader API no disponible, datos guardados localmente")
```

### ¿Cómo se obtienen credenciales de Teamleader API?

#### 1. Registrar Aplicación en Teamleader
1. Ir a https://app.teamleader.eu/integrations
2. Click en "Create app"
3. Rellenar:
   - **App name**: Centralita Teamleader
   - **Description**: Integración de telefonía
   - **Redirect URI**: `http://Interfaz web/auth/callback`

#### 2. Obtener Client Credentials
- **Client ID**: Generado automáticamente
- **Client Secret**: Generado automáticamente

#### 3. Configurar en Centralita
```ini
[API]
client_id=tu_client_id
client_secret=tu_client_secret
```

#### 4. Autenticación (OAuth2)
Al iniciar la aplicación por primera vez:
1. Abrir navegador en `http://Interfaz web`
2. Click en "Autorizar Teamleader"
3. Iniciar sesión en Teamleader
4. Autorizar la aplicación
5. Tokens guardados automáticamente en `config.ini`

```ini
[API]
tl_access_token=eyJhbGciOi...
tl_refresh_token=eyJhbGciOi...
```

### ¿Cómo se configuran los mapeos de columnas?

#### Campos Libres de Teamleader
```ini
[API]
camposlibres=telefono<-->custom_field_telefono#nombre<-->custom_field_nombre
```

Codificado en `bs4` para seguridad:
```
import bs4

# Decodificar mapeos
camposlibres_encoded = config.get("API", "camposlibres")
camposlibres_decoded = bs4.BeautifulSoup(
    camposlibres_encoded,
    "html.parser"
).text

# Resultado: "telefono<-->custom_field_telefono#nombre<-->custom_field_nombre"
```

#### Mapeos de Campos Personalizados
Editar `FRAMES/config_glosario.md`:
```
MAPEOS_CAMPOS_LIBRES = {
    "telefono": "custom_field_telefono",
    "nombre": "custom_field_nombre",
    "email": "custom_field_email",
    "direccion": "custom_field_direccion",
    "ciudad": "custom_field_ciudad",
    "codigo_postal": "custom_field_postal_code"
}
```

#### Para Nuevas Integraciones
Crear nuevo frame en `FRAMES/<nombre>/x_conf.md`:
```
# FRAMES/sage50/x_conf.md
MAPEOS_SAGE50 = {
    "telefono": "telefono_cliente",
    "nombre": "nombre_completo",
    "cif": "nif_cif",
    "direccion": "domicilio"
}
```

---

## Personalización

### ¿Se puede personalizar X?

El sistema es **altamente personalizable**:

#### Prompts de IA
**Método 1**: Modificar `config.ini`
```ini
[IA]
intrucciones=Transcribe la llamada y enfócate en:
1. Puntos clave de la conversación
2. Decisiones tomadas
3. Siguientes pasos con fechas
```

**Método 2**: Sistema A/B Testing (ver [[funcionalidades-avanzadas#9-ab-testing-de-prompts-ia]])

#### Tema Visual
```ini
[WINDOWS]
tema=DarkBlue16  # Temas de PySimpleGUI
```

**Temas disponibles**:
- `DarkBlue16`, `DarkGrey16`, `DarkBlack1`
- `LightGreen`, `LightBlue`, `LightGrey`
- `HotDogStand` (estilo retro)

#### Idioma
```ini
[WINDOWS]
idioma=es  # es, en, it
```

Agregar nuevas traducciones en `locale/<lang>/LC_MESSAGES/`:
```bash
# Crear archivo de traducción
msginit --input=locale/messages.pot --locale=fr --output=locale/fr/LC_MESSAGES/messages.po

# Editar traducciones
notepad locale/fr/LC_MESSAGES/messages.po

# Compilar
msgfmt locale/fr/LC_MESSAGES/messages.po -o locale/fr/LC_MESSAGES/messages.mo
```

#### Módulos Activos
```ini
[MODULOS]
buscar=1      # Búsqueda en CRM
audio=1       # Grabación de llamadas
ia=1          # Transcripción con IA
plantillas=0  # Plantillas (desactivado)
cuadro=1      # Cuadro de mando
```

#### Integraciones
Crear frames personalizados en `FRAMES/` siguiendo estructura de `main/`:
```
FRAMES/micrm/
├── __init__.md
├── conf.md          # Configuración MiCRM
├── cuadro.md        # Cuadro de mando MiCRM
├── procesos.md      # Lookup MiCRM, notas
└── x_conf.md        # Mapeos específicos
```

---

## Formatos de Archivo

### ¿Qué formatos de archivo soporta?

| Tipo | Formatos | Descripción |
|------|----------|-------------|
| **Audio entrada** | WAV, MP4 | Grabación de llamadas |
| **Audio salida** | WAV | Para procesamiento IA |
| **Transcripción** | TXT | Resultado de IA |
| **Configuración** | INI | config.ini |
| **Datos** | CSV | hojatiempo.csv |
| **Logs** | TXT | log_centralita.log |
| **Serialización** | PICKLE | Cache interno |

### Formatos de Audio Soportados

#### WAV (Grabación Interna)
```
# Especificaciones
sample_rate = 16000  # Hz
channels = 1         # Mono
bit_depth = 16       # PCM 16-bit
format = WAV         # .wav
```

**Ventajas**:
- Compatible con todas las APIs de IA
- Compresión sin pérdida
- Amplio soporte de software

**Desventajas**:
- Tamaño de archivo grande (~1 MB/minuto)

#### MP4 (Grabación OBS)
```
# Especificaciones
codec = AAC
bitrate = 128000    # 128 kbps
sample_rate = 44100 # Hz
channels = 2        # Stereo
format = MP4        # .mp4
```

**Ventajas**:
- Tamaño de archivo reducido (~100 KB/minuto)
- Mejor calidad de audio
- Ambos lados de conversación

**Desventajas**:
- Requiere conversión a WAV para IA
- Requiere OBS Studio instalado

---

## Manejo de Errores

### ¿Cómo se manejan los errores de validación?

Sistema multi-capa con validación en múltiples niveles:

#### 1. Validación de Audio
```
# libwertyaudiolimpieza.md
def _validar_audio_antes_de_ia(self, audio_file):
    # Tamaño mínimo
    if os.path.getsize(audio_file) < 4096:
        return False, "Archivo demasiado pequeño"

    # Duración mínima
    duration = get_audio_duration(audio_file)
    if duration < 0.8:
        return False, "Duración insuficiente"

    # Formato válido
    if not audio_file.endswith(('.wav', '.mp4')):
        return False, "Formato no soportado"

    # Checksum SHA256
    if not self._verify_checksum(audio_file):
        return False, "Checksum inválido"

    return True, "OK"
```

#### 2. Reintentos Automáticos
```
# Para archivos recién creados
retries = 6
delay = 350  # ms

for i in range(retries):
    valid, msg = self._validar_audio_antes_de_ia(audio_file)

    if valid:
        break

    time.sleep(delay / 1000)
```

#### 3. Logging Estructurado
```
# log_centralita.log
import logging

logging.basicConfig(
    filename='log_centralita.log',
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logging.error("Error al procesar audio", exc_info=True)
```

**Ejemplo de log**:
```
2025-03-19 17:23:45,123 - ERROR - Error al procesar audio
Traceback (most recent call last):
  File "miratelefono_tareas_proceso.md", line 123, in crear_trabajo_ia
    resultado = openrouter_api.transcribir(audio_file)
  File "libwertyIA.md", line 45, in transcribir
    response = openrouter.ChatCompletion.create(...)
openrouter.error.APIError: Invalid API key
```

#### 4. Notificaciones Usuario
```
# System tray muestra avisos visuales
system_tray.show_balloon(
    title="Error de Validación",
    message="El audio de la llamada es demasiado corto",
    icon=error_icon
)
```

#### 5. Recuperación Graceful
```
# TareaV2 marca estado "Sin IA" para audios no válidos
if not valid:
    csv_manager.update_estado(
        audio_file,
        estado="Sin IA",
        motivo="Audio inválido: " + msg
    )
    # Continúa procesando otras tareas
```

---

## Problemas Comunes

### La aplicación no detecta llamadas

**Solución**:
1. Verificar que `appandroid=True` en `[WINDOWS]`
2. Asegurarse de que RemotePhoneService está ejecutándose
3. Comprobar que el teléfono está conectado

```ini
[WINDOWS]
appandroid=True  # Debe ser True
```

### Error: "Teamleader API no responde"

**Solución**:
1. Verificar conexión a internet
2. Comprobar tokens en `config.ini` no han expirado
3. Re-autenticar vía http://Interfaz web

```
# Refrescar tokens manualmente
teamleader_api.refresh_access_token()
```

### OBS no graba audio

**Solución**:
1. Verificar que OBS está ejecutándose
2. Comprobar que `obs_activo=True` en `[OBS]`
3. Verificar escena "Audio" existe
4. Probar conexión WebSocket: `telnet localhost 4455`

```ini
[OBS]
obs_activo=True
obs_host=localhost
obs_port=4455
```

### La transcripción IA es de mala calidad

**Solución**:
1. Verificar calidad de audio (usar modo OBS si es posible)
2. Ajustar prompt en `config.ini`
3. Cambiar modelo (usar GPT-4o en lugar de Gemini Lite)

```ini
[IA]
model=google/gemini-2.5-flash-lite  # Cambiar a openai/gpt-4o
```

---

## Rendimiento y Optimización

### ¿Cuántos recursos consume el sistema?

| Proceso | CPU | RAM | Disco |
|---------|-----|-----|-------|
| **centralita.md** | 0.5-2% | 50-100 MB | 5 MB |
| **Interfaz web Config** | 1-3% | 150-200 MB | - |
| **Interfaz web Hoja Tiempo** | 1-2% | 200-250 MB | - |
| **OBS Studio** | 2-5% | 300-400 MB | - |
| **Total (idle)** | ~5% | ~700 MB | - |
| **Total (grabando)** | ~15% | ~800 MB | ~1 MB/min |

### ¿Cómo optimizar el rendimiento?

#### 1. Desactivar Módulos No Usados
```ini
[MODULOS]
plantillas=0  # Desactivar si no se usa
```

#### 2. Reducir Calidad de Audio
```ini
[AUDIO]
bitrate=64000  # Bajar de 128 kbps a 64 kbps
```

#### 3. Limitar Instancias Interfaz web
```ini
[STREAMLIT_SUPERVISOR]
inactivity_timeout=1800  # Cerrar después de 30 min inactivo
```

#### 4. Usar Modelo IA Más Ligero
```ini
[IA]
model=google/gemini-2.5-flash-lite  # En lugar de GPT-4o
```

---

## Backup y Recuperación

### ¿Cómo hacer backup de la configuración?

```bash
# Backup manual completo
tar -czf backup_$(date +%Y%m%d).tar.gz \
    config.ini \
    hojatiempo.csv \
    campos_libres.c \
    log_centralita.log
```

### ¿Cómo restaurar desde backup?

```bash
# 1. Detener aplicación
taskkill /IM centralita.exe

# 2. Descomprimir backup
tar -xzf backup_20250319.tar.gz

# 3. Copiar archivos
cp config.ini ..
cp hojatiempo.csv ..

# 4. Reiniciar aplicación
centralita.exe
```

---

## Seguridad

### ¿Cómo se protegen las credenciales API?

1. **Tokens en config.ini** (local, no se comparte)
2. **Codificación bs4** para campos libres
3. **OAuth2** con refresh tokens automáticos
4. **Sin envío de datos a terceros** (solo a APIs configuradas)

### ¿El sistema envía datos a servidores externos?

Solo a los servicios configurados:
- **Teamleader API**: Solo contactos/notas
- **OpenRouter API**: Solo audio para transcripción
- **Sin telemetría**: No se recopilan datos de uso

---

## Actualizaciones

### ¿Cómo actualizar a la última versión?

```bash
# 1. Hacer backup
cp config.ini config.ini.backup

# 2. Pull de cambios
git pull origin main

# 3. Actualizar dependencias
pip install -r requirements.txt --upgrade

# 4. Restaurar configuración
cp config.ini.backup config.ini

# 5. Reiniciar aplicación
python centralita.md
```

---

## Soporte

### ¿Dónde obtener ayuda?

1. **Documentación técnica**: Ver [[arquitectura]] y [[funcionalidades-core]]
2. **Casos de uso**: Consultar [[casos-de-uso]]
3. **GitHub Issues**: https://github.com/wertyMSD/Centralita_Teamleader/issues
4. **Email**: soporte@alcatic.com

---

## Resumen de FAQ

| Categoría | Preguntas |
|-----------|-----------|
| Instalación | Cómo instalar, requisitos previos |
| Teamleader | Credenciales, mapeos, fallos de conexión |
| Personalización | Prompts IA, temas, idiomas, módulos |
| Formatos | Audio, configuración, logs |
| Errores | Validación, reintentos, logging |
| Problemas | Detección de llamadas, OBS, transcripción |
| Rendimiento | Recursos, optimización |
| Backup | Copia de seguridad, restauración |
| Seguridad | Protección de credenciales |
| Actualizaciones | Actualización a nueva versión |

## Próximos Pasos

- [ ] Revisar [[arquitectura]] para entender la estructura del sistema
- [ ] Consultar [[funcionalidades-core]] para详细了解 las funcionalidades principales
- [ ] Ver [[casos-de-uso]] para ejemplos prácticos
- [ ] Leer [[integraciones]] para configurar servicios externos
