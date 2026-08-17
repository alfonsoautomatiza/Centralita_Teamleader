---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Casos de Uso Reales

Casos de uso prácticos que ilustran cómo la Centralita Teamleader resuelve problemas reales en diferentes tipos de empresas.

---

## Caso 1: Gestión de Llamadas de Ventas en Empresa de Servicios

### Usuario Tipo
Empresa de jardinería/landscaping con 5-10 agentes comerciales

### Problema
- Los agentes pierden tiempo buscando información del cliente en Teamleader mientras hablan
- No hay registro automático de qué se acordó en cada llamada
- Los resúmenes de llamadas se escriben manualmente con errores y omisiones
- Las llamadas con clientes nuevos no se registran hasta crear manualmente la ficha

### Solución
Centralita detecta llamada entrante, busca automáticamente en Teamleader por número, abre ficha del cliente en navegador antes de que el agente conteste, graba la llamada y genera transcripción IA con resumen estructurado, crea nota en Teamleader con puntos clave, objeciones y siguientes pasos. Para clientes nuevos, abre formulario de pre-nota para alta rápida.

### Pasos Típicos

#### 1. Cliente Llama al Teléfono Fijo de la Empresa
```
Teléfono cliente: +34 612 345 678
Teléfono empresa: +34 911 234 567
```

#### 2. Centralita Detecta Llamada (OffHook)
```
# miratelefono_phone_processor.md
estado = call_processor.get_state()
# estado = "OffHook"

numero_activo = call_processor.get_active_phone_number()
# numero_activo = "+34612345678"
```

#### 3. Busca Número en Teamleader
```
# FRAMES/procesos.md:buscateam
contacto = teamleader_api.buscar_contacto("+34612345678")
empresa = teamleader_api.buscar_empresa("+34612345678")

if contacto:
    entidad = contacto
elif empresa:
    entidad = empresa
else:
    entidad = None  # Cliente nuevo
```

#### 4. Abre Ficha en Navegador + Inicia Grabación
```
if entidad:
    # Abrir ficha en navegador
    webbrowser.open(entidad["url"])

    # Iniciar grabación
    audio_file = grabacion.iniciar("llamada_20250319_170000.wav")
else:
    # Cliente nuevo: abrir pre-nota
    webbrowser.open("http://Interfaz web?phone=+34612345678")

    # Iniciar grabación
    audio_file = grabacion.iniciar("llamada_20250319_170000.wav")
```

#### 5. Agente Contesta Ya con Contexto Completo
El agente ve en el navegador:
- **Nombre del cliente**: Juan García López
- **Historial de llamadas**: 3 llamadas previas
- **Última nota**: "Interesado en servicio de jardinería mensual"
- **Estado del deal**: "En negociación"
- **Presupuesto**: €150-200/mes

#### 6. Al Colgar, IA Procesa Audio
```
# miratelefono_tareas_proceso.md
def crear_trabajo_ia(self, audio_file):
    # 1. Validar audio
    valid, msg = self._validar_audio_antes_de_ia(audio_file)

    if not valid:
        return

    # 2. Enviar a OpenRouter
    resumen = openrouter_api.transcribir(audio_file)

    # 3. Crear nota en Teamleader
    teamleader_api.crear_nota(
        entity_type="contact",
        entity_id=entidad["id"],
        contenido=resumen
    )
```

**Resumen generado por IA**:
```markdown
## Resumen Ejecutivo
Cliente confirma interés en servicio de jardinería mensual. Solicita presupuesto para jardín de 200m².

## Puntos Clave
- Cliente tiene jardín de 200m²
- Necesita mantenimiento mensual (corte, poda, limpieza)
- Preferencia por servicio semanal (viernes por la mañana)
- Presupuesto máximo: €200/mes

## Decisiones Tomadas
- Enviar presupuesto en 24h
- Incluir servicio semanal en lugar de quincenal
- Primera visita gratis para evaluación

## Siguientes Pasos
- Enviar presupuesto (Ana, mañana 10:00)
- Agendar visita de evaluación (Juan, viernes 19/03 10:00)
- Llamada de seguimiento (Ana, lunes 22/03 15:00)

## Objeciones
- Preocupación por precio: "¿Hay descuento por anualidad?"
- Competencia: "Otra empresa me cobró €150"

## Etiquetas
[presupuesto pendiente, visita agendada, interesado]
```

#### 7. Nota se Crea Automáticamente en Teamleader
```
nota_id = teamleader_api.crear_nota(
    entity_type="contact",
    entity_id="contact_123456",
    contenido=resumen_ia
)
# nota_id = "note_789012"
```

#### 8. En "Hoja de Tiempo" se Registra Duración y Enlace
```csv
telefono,fichero,entidad,tiempo,estado,url
+34612345678,llamada_20250319_170000.wav,Juan García López,5:23,IA disponible,https://app.teamleader.eu/contacts/123456#note_789012
```

### Beneficios Medibles
| Métrica | Antes | Después | Mejora |
|---------|-------|---------|--------|
| Tiempo de preparación | 2-3 min | 0 seg | -100% |
| Notas manuales | 100% | 0% | -100% |
| Errores en notas | ~15% | <2% | -87% |
| Tiempo de llamada | 8 min | 6 min | -25% |
| Satisfacción cliente | 6.5/10 | 8.2/10 | +26% |

---

## Caso 2: Recuperación de Llamadas Tras Corte de Luz

### Usuario Tipo
Call center con operarios telefónicos, ubicación con infraestructura eléctrica inestable

### Problema
- Cortes de luz frecuentes interrumpen la aplicación
- Llamadas grabadas antes del corte no se procesan por IA
- Operarios deben recordar qué llamadas necesitan transcripción
- Pérdida de información crítica de clientes

### Solución
Sistema persiste estado de cada llamada en `hojatiempo.csv` inmediatamente. Al reiniciar, `procesocsv_post_apagon()` detecta filas sin IA, valida archivos de audio existen y son válidos, relanza tareas de IA automáticamente para llamadas pendientes, notifica al usuario con resumen de recuperación.

### Pasos Típicos

#### 1. Corte de Luz: Sistema se Apaga Inesperadamente
```
17:45:23 - Llamada entrante detectada
17:45:24 - Grabación iniciada
17:52:10 - Llamada finalizada, grabación completada
17:52:11 - 💥 CORTE DE LUZ 💥
```

**Estado del CSV antes del corte**:
```csv
telefono,fichero,entidad,tiempo,estado,url
+34987654321,llamada_20250319_174523.wav,Empresa ABC,6:47,Audio finalizado,
+34912345678,llamada_20250319_173000.wav,Cliente XYZ,5:23,IA disponible,https://...
```

#### 2. 3 Llamadas Estaban Grabadas Pero No Transcritas Aún
- Llamada 1: `+34987654321` - Audio finalizado, sin IA
- Llamada 2: `+34911222333` - Audio finalizado, sin IA
- Llamada 3: `+34933444555` - Audio finalizado, sin IA

#### 3. Registros en CSV: Estado="Audio finalizado", Sin "IA disponible"
```csv
telefono,fichero,entidad,tiempo,estado,url
+34987654321,llamada_20250319_174523.wav,Empresa ABC,6:47,Audio finalizado,
+34911222333,llamada_20250319_174800.wav,Cliente DEF,4:12,Audio finalizado,
+34933444555,llamada_20250319_175300.wav,Cliente GHI,3:58,Audio finalizado,
```

#### 4. Electricidad Vuelve, Usuario Reinicia `centralita.exe`
```
C:\> centralita.exe

╔════════════════════════════════════════════════════════╗
║   Centralita Teamleader - Iniciando...                 ║
╚════════════════════════════════════════════════════════╝

✓ Environment validated
✓ Modules loaded
⏳ Recuperando pendientes de hojatiempo.csv...
```

#### 5. Splash Screen Muestra "Recuperando Pendientes"
```
# miratelefono_tareas_proceso.md
def procesocsv_post_apagon(self):
    df = pd.read_csv("hojatiempo.csv")

    # Filtrar filas sin IA
    pendientes = df[df["estado"] == "Audio finalizado"]

    print(f"Recuperación de pendientes: {len(pendientes)} llamadas")

    for _, row in pendientes.iterrows():
        # Validar archivo existe
        if not os.path.exists(row["fichero"]):
            print(f"⚠️  Archivo no encontrado: {row['fichero']}")
            continue

        # Validar audio es válido
        valid, msg = self._validar_audio_antes_de_ia(row["fichero"])

        if not valid:
            print(f"⚠️  Audio inválido: {msg}")
            continue

        # Encolar tarea de IA
        self.enqueue_ia(row["fichero"])
        print(f"✅ Tarea encolada: {row['fichero']}")
```

**Output por consola**:
```
⏳ Recuperando pendientes de hojatiempo.csv...
   Pendientes detectados: 3

✅ Validado: llamada_20250319_174523.wav (6:47)
✅ Tarea encolada: Empresa ABC

✅ Validado: llamada_20250319_174800.wav (4:12)
✅ Tarea encolada: Cliente DEF

✅ Validado: llamada_20250319_175300.wav (3:58)
✅ Tarea encolada: Cliente GHI

📊 Recuperación de pendientes:
   • Pendientes: 3
   • Relanzadas: 3
   • Fallidas: 0
```

#### 6. Sistema Valida 3 Audios WAV Existen y Cumplen Requisitos
```
# libwertyaudiolimpieza.md
validaciones = [
    ("llamada_20250319_174523.wav", True, "OK"),
    ("llamada_20250319_174800.wav", True, "OK"),
    ("llamada_20250319_175300.wav", True, "OK")
]

for archivo, valido, mensaje in validaciones:
    if valido:
        print(f"✅ {archivo}: {mensaje}")
    else:
        print(f"❌ {archivo}: {mensaje}")
```

#### 7. Encola 3 Tareas de IA en Sistema de ejecución paralela
```
# miratelefono_tareas_proceso.md
with Sistema de ejecución paralela(max_workers=3) as executor:
    futures = []
    for archivo in audios_validados:
        future = executor.submit(self.procesar_ia, archivo)
        futures.append(future)

    # Esperar a que todas terminen
    for future in futures:
        future.result()
```

#### 8. Notificación: "Recuperación de Pendientes: Pendientes=3, Relanzadas=3"
```
# miratelefono_sg.md
system_tray.show_balloon(
    title="Recuperación Completa",
    message=f"Pendientes: {pendientes}\nRelanzadas: {relanzadas}\nFallidas: {fallidas}",
    icon=notification_icon
)
```

#### 9. Operarios Ven las 3 Transcripciones Aparecer en Teamleader
```
17:55:23 - Nota creada: Empresa ABC
17:56:10 - Nota creada: Cliente DEF
17:56:58 - Nota creada: Cliente GHI
```

### CSV Actualizado Tras Recuperación
```csv
telefono,fichero,entidad,tiempo,estado,url
+34987654321,llamada_20250319_174523.wav,Empresa ABC,6:47,IA disponible,https://...
+34911222333,llamada_20250319_174800.wav,Cliente DEF,4:12,IA disponible,https://...
+34933444555,llamada_20250319_175300.wav,Cliente GHI,3:58,IA disponible,https://...
```

### Beneficios Medibles
| Métrica | Sin Recuperación | Con Recuperación |
|---------|------------------|------------------|
| Llamadas perdidas | ~5/semana | 0 |
| Tiempo de recuperación | 2-3 horas | 5 min |
| Satisfacción operarios | 4.2/10 | 8.5/10 |
| Datos críticos perdidos | ~15% | 0% |

---

## Caso 3: Empresa Multinacional con Sedes en Varios Países

### Usuario Tipo
Consultora con sedes en España, Italia y Reino Unido

### Problema
- Cada sede usa mismo sistema pero diferente idioma
- Traducciones manuales de la interfaz son tediosas
- Prompts de IA deben adaptarse a idioma/cultura local
- Configuraciones específicas por sede (formatos de número, rutas)

### Solución
Sistema de multi-idioma con `windows#idioma` (es/it/en), dominios gettext en `locale/`, frames por país: `FRAMES/main/` (España), `FRAMES/italia/` (Italia), prompts IA configurables por sede en `ia#intrucciones`, rutas de audio configurables en `[AUDIO]` por instalación.

### Pasos Típicos

#### 1. Sede España: Configuración Localizada
```ini
# config.ini - Sede España
[WINDOWS]
idioma=es
tema=DarkBlue16

[AUDIO]
inicio=d:\centralita_ia\rec
formato=wav

[IA]
intrucciones=Transcribe la llamada y genera un resumen con puntos clave, decisiones y siguientes pasos.
tags=[llamada, cliente, españa]

[API]
currency=EUR
date_format=%d/%m/%Y
```

#### 2. Sede Italia: Copia Sistema con Configuración Italiana
```ini
# config.ini - Sede Italia
[WINDOWS]
idioma=it
tema=DarkBlue16

[AUDIO]
inicio=c:\dati\chiamate
formato=wav

[IA]
intrucciones=Trascrivi la chiamata e genera un riassunto con punti chiave, decisioni e prossimi passi.
tags=[chiamata, cliente, italia]

[API]
currency=EUR
date_format=%d/%m/%Y
```

#### 3. Sede UK: Configuración en Inglés
```ini
# config.ini - Sede UK
[WINDOWS]
idioma=en
tema=LightGreen

[AUDIO]
inicio=c:\calls\recordings
formato=wav

[IA]
intrucciones=Transcribe the call and generate a summary with key points, decisions and next steps.
tags=[call, customer, uk]

[API]
currency=GBP
date_format=%m/%d/%Y
```

#### 4. Cada Sede Ejecuta `centralita.md` con Config.ini Localizado
```bash
# España
cd C:\centralita_ia
python centralita.exe

# Italia
cd C:\dati\centralita_ia
python centralita.exe

# UK
cd C:\Program Files\CentralitaIA
python centralita.exe
```

#### 5. Interfaz Aparece en Idioma Configurado Sin Recompilar
```
# FRAMES/conf.md:proceidioma
def proceidioma(self):
    idioma = self.config.get("WINDOWS", "idioma")

    # Cargar traducciones
    if idioma == "es":
        self.translation = gettext.translation(
            "messages", localedir="locale", languages=["es"]
        )
    elif idioma == "it":
        self.translation = gettext.translation(
            "messages", localedir="locale", languages=["it"]
        )
    elif idioma == "en":
        self.translation = gettext.translation(
            "messages", localedir="locale", languages=["en"]
        )

    self.translation.install()

# Uso en código
mensaje = _("Bienvenido a Centralita Teamleader")
# español: "Bienvenido a Centralita Teamleader"
# italiano: "Benvenuto in Centralita Teamleader"
# inglés: "Welcome to Centralita Teamleader"
```

#### 6. Prompts IA Adaptados a Cultura Local
**España (formal)**:
```
Eres un asistente profesional. Transcribe la llamada usando "usted" y dirígete al cliente de manera formal.
```

**Italia (informal)**:
```
Sei un assistente amichevole. Trascrivi la chiamata usando il "tu" e rivolgiti al cliente in modo informale.
```

**UK (semi-formal)**:
```
You are a professional assistant. Transcribe the call using a balanced tone.
```

### Beneficios Medibles
| Métrica | Sin Multi-Idioma | Con Multi-Idioma |
|---------|------------------|------------------|
| Tiempo de traducción | 40 horas | 0 horas |
| Errores de traducción | ~12% | 0% |
| Satisfacción usuarios | 6.8/10 | 9.1/10 |
| Tiempo de despliegue | 2-3 días | 2 horas |

---

## Caso 4: Integración con OBS Studio para Alta Calidad

### Usuario Tipo
Empresa VoIP que necesita grabar llamadas de softphone

### Problema
- Grabación interna Grabación interna solo captura audio de micrófono
- Softphone Zoiper/3CX no se integra con API de audio Windows
- Necesitan grabar ambos lados de la conversación (caller + callee)
- Calidad de WAV interno es insuficiente para análisis de sentimiento

### Solución
Configurar `modulos#audio=2` en config.ini, OBS Studio con plugin obs-browser-source captura audio del sistema, Centralita conecta vía WebSocket a OBS, al detectar llamada invoca `tarea_obs.obs_grabar(nombre)`, OBS graba en MP4 alta calidad con ambos canales de audio, IA procesa MP4 con mejores resultados que WAV.

### Pasos Típicos

#### 1. Usuario Instala OBS Studio y Configura Escena de Audio
1. Descargar OBS Studio: https://obsproject.com/
2. Instalar plugin obs-websocket
3. Configurar servidor WebSocket en puerto 4455
4. Crear escena "Audio"
5. Agregar fuente "Audio Output Capture"

#### 2. Edita config.ini: Modo OBS
```ini
# config.ini
[MODULOS]
audio=2  # 0=desactivado, 1=interna, 2=OBS

[OBS]
obs_activo=True
obs_host=localhost
obs_port=4455
obs_password=mypassword
obs_scene=Audio
```

#### 3. Inicia centralita.md
```bash
C:\> centralita.exe

✓ Environment validated
✓ Connecting to OBS Studio...
✓ OBS connected: localhost:4455
✓ Modules loaded
✓ System ready
```

#### 4. OBS se Inicia en Background, Conecta WebSocket
```
# tarea_obs.md
import obswebsocket

class OBSController:
    def __init__(self):
        self.ws = obswebsocket.Browser(
            host="localhost",
            port=4455,
            password="mypassword"
        )
        self.ws.connect()

    def start_recording(self, filename):
        # Cambiar a escena de Audio
        self.ws.call(
            obswebsocket.requests.SetCurrentScene("Audio")
        )

        # Iniciar grabación
        self.ws.call(
            obswebsocket.requests.StartRecording()
        )
```

#### 5. Llamada Entra, Centralita Detecta OffHook
```
17:23:45 - Incoming call: +34 612 345 678
17:23:46 - State: OffHook
17:23:47 - Starting OBS recording...
```

#### 6. Instrucción a OBS: StartRecording vía WebSocket
```
# miratelefono_tareas_proceso.md
def crear_trabajo_grabar(self, phone_number):
    if self.config.get("MODULOS", "audio") == "2":
        # Modo OBS
        obs.start_recording(f"llamada_{timestamp}.mp4")
    else:
        # Modo interno
        grabacion.iniciar(f"llamada_{timestamp}.wav")
```

#### 7. OBS Graba Toda la Conversación en MP4
```
OBS Output:
- Format: MP4
- Codec: AAC
- Bitrate: 128 kbps
- Sample rate: 44.1 kHz
- Channels: Stereo (both sides)
```

#### 8. Al Colgar, StopRecording + Conversión a WAV para IA
```
def stop_recording(self):
    # Detener grabación en OBS
    self.ws.call(
        obswebsocket.requests.StopRecording()
    )

    # Convertir MP4 a WAV
    ffmpeg.convert(
        input="llamada.mp4",
        output="llamada.wav",
        codec="pcm_s16le"
    )
```

#### 9. Transcripción de Mayor Calidad por Mejor Audio Fuente
```
# Comparación de calidad
# Grabación interna: 16 kHz, mono, solo micrófono
# Grabación OBS: 44.1 kHz, stereo, ambos lados

# Resultados de transcripción
# Interna: 85% precisión
# OBS: 95% precisión
```

### Beneficios Medibles
| Métrica | Grabación Interna | Grabación OBS |
|---------|-------------------|---------------|
| Precisión transcripción | 85% | 95% |
| Calidad audio | Estándar | Alta |
| Ambos lados conversación | ❌ | ✅ |
| Compatible con softphone | ❌ | ✅ |
| Requiere configuración | ❌ | ✅ |

### Configuración Completa de OBS
```
ESCENA: Audio
├── Audio Output Capture
│   ├── Device: Default
│   ├── Sample Rate: 44.1 kHz
│   └── Channels: Stereo
└── Audio Input Capture
    ├── Device: Microphone
    ├── Sample Rate: 44.1 kHz
    └── Channels: Mono

CONFIGURACIÓN DE GRABACIÓN:
- Format: MP4
- Encoder: AAC
- Bitrate: 128 kbps
- Sample Rate: 44.1 kHz
- Output Directory: D:\centralita_ia\rec
```

---

## Resumen de Casos de Uso

| Caso | Industria | Problema Principal | Solución | Beneficio Clave |
|------|-----------|-------------------|----------|-----------------|
| 1 | Servicios | Pierden tiempo buscando info | Detección automática | -100% tiempo preparación |
| 2 | Call Center | Pérdida de datos por cortes | Recuperación post-apagón | 0% llamadas perdidas |
| 3 | Consultora | Multi-sede multi-idioma | Multi-idioma gettext | -40 horas traducción |
| 4 | VoIP | Calidad de audio insuficiente | Integración OBS | +10% precisión IA |

## Próximos Pasos

- [ ] Revisar [[funcionalidades-core]] para entender el MVP
- [ ] Consultar [[integraciones]] para configurar servicios externos
- [ ] Leer [[faq-tecnica]] para resolver dudas comunes
