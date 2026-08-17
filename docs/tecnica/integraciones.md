---
created: 2026-08-13
tags:
  - contexto/proyecto/manual
---
# Integraciones Disponibles

El sistema Centralita Teamleader se integra con múltiples servicios externos para proporcionar una solución completa de gestión de llamadas con CRM e inteligencia artificial.

---

## 1. Teamleader API

### Descripción
Integración actual con OAuth2 para sincronización de contactos, empresas, deals, quotations y creación automática de notas tras llamada.

### Casos de Uso
- Sincronización de contactos y empresas
- Creación automática de notas tras llamada
- Lookup de números telefónicos
- Gestión de deals y quotations

### Qué Problema Resuelve
Centralización de toda la información del cliente en el CRM, evita duplicación de datos y asegura que toda la información de llamadas esté disponible en el sistema de gestión.

### Configuración OAuth2
```ini
[API]
client_id=your_client_id
client_secret=your_client_secret
tl_access_token=eyJhbGciOi...
tl_refresh_token=eyJhbGciOi...
redirect_uri=http://Interfaz web/auth/callback
```

### Flujo de Autenticación
```
# apitl.md
class TeamleaderAPI:
    def __init__(self):
        self.client_id = config.get("API", "client_id")
        self.client_secret = config.get("API", "client_secret")
        self.access_token = config.get("API", "tl_access_token")
        self.refresh_token = config.get("API", "tl_refresh_token")

    def refresh_access_token(self):
        # Intercambiar refresh_token por nuevo access_token
        response = requests.post(
            "https://app.teamleader.eu/oauth2/token",
            data={
                "client_id": self.client_id,
                "client_secret": self.client_secret,
                "refresh_token": self.refresh_token,
                "grant_type": "refresh_token"
            }
        )

        self.access_token = response.json()["access_token"]
        self._save_tokens()
```

### Operaciones Disponibles

#### Buscar Contacto por Teléfono
```
def buscar_contacto(self, phone_number):
    normalized_phone = self._normalize_phone(phone_number)

    response = requests.get(
        "https://app.teamleader.eu/contacts.find",
        headers={"Authorization": f"Bearer {self.access_token}"},
        params={"phone": normalized_phone}
    )

    return response.json()["data"]
```

#### Buscar Empresa por Teléfono
```
def buscar_empresa(self, phone_number):
    normalized_phone = self._normalize_phone(phone_number)

    response = requests.get(
        "https://app.teamleader.eu/companies.find",
        headers={"Authorization": f"Bearer {self.access_token}"},
        params={"phone": normalized_phone}
    )

    return response.json()["data"]
```

#### Crear Nota en Ficha
```
def crear_nota(self, entity_type, entity_id, contenido):
    response = requests.post(
        "https://app.teamleader.eu/notes",
        headers={"Authorization": f"Bearer {self.access_token}"},
        json={
            "entity_type": entity_type,  # "contact" o "company"
            "entity_id": entity_id,
            "note": contenido,
            "created_by": self.current_user_id
        }
    )

    return response.json()["data"]["id"]
```

#### Campos Libres Personalizados
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
```

### Configuración de Campos Libres
```
# FRAMES/x_conf.md
MAPEOS_CAMPOS_LIBRES = {
    "telefono": "custom_field_telefono",
    "nombre": "custom_field_nombre",
    "email": "custom_field_email",
    "direccion": "custom_field_direccion"
}
```

### Webhook para Eventos Teamleader
Opcionalmente, puedes configurar webhooks para recibir eventos de Teamleader:
- `contact.created`: Nuevo contacto creado
- `company.updated`: Empresa actualizada
- `note.created`: Nota creada manualmente

```
@app.route("/webhook/teamleader", methods=["POST"])
def teamleader_webhook():
    event = request.json["type"]

    if event == "contact.created":
        # Sincronizar contacto localmente
        sync_contact(request.json["data"])

    return {"status": "ok"}
```

---

## 2. OBS Studio (WebSocket)

### Descripción
Control remoto vía `obs_websocket` para grabación de audio del sistema en alta calidad.

### Casos de Uso
- Grabación de alta calidad de llamadas
- Captura de audio de cualquier aplicación (softphones VoIP)
- Grabación de ambos lados de la conversación

### Qué Problema Resuelve
La grabación interna de Grabación interna solo captura el micrófono. OBS permite grabar el audio del sistema completo, incluyendo softphones como Zoiper o 3CX.

### Configuración
```ini
[OBS]
obs_activo=True
obs_host=localhost
obs_port=4455
obs_password=your_password
obs_scene=Audio
```

### Instalación de OBS WebSocket
1. Instalar OBS Studio: https://obsproject.com/
2. Instalar plugin obs-websocket:
   - Descargar: https://github.com/Palakis/obs-websocket/releases
   - Copiar a la carpeta de plugins de OBS
3. Configurar en OBS:
   - Herramientas → WebSocket Server Settings
   - Habilitar servidor
   - Puerto: 4455
   - Password: configurar

### Conexión WebSocket
```
# tarea_obs.md
import obswebsocket

class OBSController:
    def __init__(self):
        self.host = config.get("OBS", "obs_host")
        self.port = config.getint("OBS", "obs_port")
        self.password = config.get("OBS", "obs_password")

        self.ws = obswebsocket.Browser(
            host=self.host,
            port=self.port,
            password=self.password
        )
        self.ws.connect()

    def start_recording(self, filename):
        self.ws.call(
            obswebsocket.requests.StartRecording()
        )

    def stop_recording(self):
        self.ws.call(
            obswebsocket.requests.StopRecording()
        )
```

### Configuración de Escena de Audio
1. Crear escena "Audio" en OBS
2. Agregar fuente "Audio Output Capture"
3. Seleccionar dispositivo de audio predeterminado
4. Configurar codificador:
   - Formato: MP4
   - Codec: AAC
   - Bitrate: 128 kbps
   - Sample rate: 44.1 kHz

### Flujo de Grabación
```
def obs_grabar(self, nombre_archivo):
    # 1. Conectar a OBS
    obs = OBSController()

    # 2. Cambiar a escena de Audio
    obs.ws.call(
        obswebsocket.requests.SetCurrentScene(
            sceneName="Audio"
        )
    )

    # 3. Iniciar grabación
    obs.start_recording(nombre_archivo)

    # 4. Esperar fin de llamada (blocking)
    while call_state == "Connected":
        time.sleep(1)

    # 5. Detener grabación
    obs.stop_recording()

    # 6. Convertir MP4 a WAV para IA
    convertir_mp4_a_wav(nombre_archivo)
```

### Limitaciones
- Requiere OBS ejecutándose
- Requiere configuración manual de escenas
- Mayor consumo de recursos que grabación interna

---

## 3. Sage 50

### Descripción
Frame específico en `FRAMES/sage50/` para integración con contabilidad Sage 50 (si está disponible).

### Casos de Uso
- Sincronización de facturas, clientes, proveedores
- Generación de presupuestos desde llamadas
- Consulta de saldo de clientes
- Creación de asientos contables

### Qué Problema Resuelve
Integración telefónica-contabilidad para empresas que usan Sage, permitiendo acceder a información financiera del cliente durante la llamada.

### Configuración
```ini
[SAGE50]
ruta_datos=C:\Sage50\Datos\Empresa
usuario=admin
password=...
integration_enabled=True
```

### Operaciones Disponibles
```
# FRAMES/sage50/procesos.md
def buscar_cliente_sage(self, phone_number):
    # Buscar cliente en base de datos Sage 50
    query = f"SELECT * FROM Clientes WHERE Telefono = '{phone_number}'"
    cliente = sage_db.execute(query)

    return cliente

def crear_factura(self, cliente_id, conceptos):
    # Crear factura en Sage 50
    factura = {
        "cliente_id": cliente_id,
        "fecha": datetime.now(),
        "conceptos": conceptos,
        "total": sum(c["importe"] for c in conceptos)
    }

    sage_db.insert("Facturas", factura)
```

### Estructura del Frame Sage 50
```
FRAMES/sage50/
├── __init__.md
├── conf.md          # Configuración Sage 50
├── cuadro.md        # Cuadro de mando Sage
├── procesos.md      # Procesos específicos Sage
└── x_conf.md        # Mapeos Sage
```

---

## 4. OpenRouter / Google Gemini

### Descripción
API de IA para transcripción de audio usando modelos como Google Gemini 2.5 Flash Lite.

### Casos de Uso
- Transcripción speech-to-text
- Resumen de conversaciones
- Extracción de entidades y acciones
- Análisis de sentimiento

### Qué Problema Resuelve
Automatización de documentación de llamadas, búsqueda en historial de conversaciones, eliminación de notas manuales.

### Configuración
```ini
[IA]
api_key=sk-or-v1-...
provider=openrouter
model=google/gemini-2.5-flash-lite
max_tokens=4000
temperature=0.7
```

### Transcripción de Audio
```
# libwertyIA.md
import openrouter

class TranscriptorIA:
    def __init__(self):
        self.api_key = config.get("IA", "api_key")
        self.model = config.get("IA", "model")

    def transcribir(self, audio_file):
        # 1. Convertir audio a base64
        with open(audio_file, "rb") as f:
            audio_base64 = base64.b64encode(f.read()).decode()

        # 2. Enviar a OpenRouter
        response = openrouter.ChatCompletion.create(
            model=self.model,
            messages=[
                {
                    "role": "system",
                    "content": self._get_prompt()
                },
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "text",
                            "text": "Transcribe esta llamada:"
                        },
                        {
                            "type": "audio",
                            "audio": {
                                "data": audio_base64,
                                "format": "wav"
                            }
                        }
                    ]
                }
            ]
        )

        return response.choices[0].message.content
```

### Prompt de Instrucciones
```ini
[IA]
intrucciones=Eres un asistente experto en transcripción de llamadas telefónicas.
Tu tarea es transcribir el audio y generar un resumen estructurado con:

## Resumen Ejecutivo
Breve descripción de la llamada en 2-3 frases.

## Puntos Clave
- Punto 1
- Punto 2
- Punto 3

## Decisiones Tomadas
- Decisión 1
- Decisión 2

## Siguientes Pasos
- Acción 1 (responsable, fecha)
- Acción 2 (responsable, fecha)

## Objeciones o Preocupaciones
- Objeción 1
- Objeción 2

## Información de Contacto
- Nombre:
- Teléfono:
- Email:
- Dirección:

## Etiquetas
[tag1, tag2, tag3]
```

### Modelos Disponibles
| Modelo | Tokens | Coste/1M tokens | Calidad |
|--------|--------|-----------------|---------|
| google/gemini-2.5-flash-lite | 1M | $0.07 | Alta |
| openai/gpt-4o | 128K | $2.50 | Muy alta |
| anthropic/claude-3-haiku | 200K | $0.25 | Alta |

---

## 5. eInforma

### Descripción
Integración con `bs4empresite.bs4empresite` para datos comerciales de empresas españolas.

### Casos de Uso
- Enriquecimiento de fichas de cliente
- Información comercial y financiera
- Calificación de riesgo
- Datos de contacto verificados

### Qué Problema Resuelve
Contexto adicional sobre clientes potenciales, calificación de riesgo antes de cerrar venta.

### Configuración
```ini
[EINFORMA]
api_key=...
enabled=True
auto_enrich=True
```

### Uso
```
from bs4empresite import bs4empresite

def enriquecer_empresa(self, cif):
    # Buscar en eInforma
    api = bs4empresite.EinformaAPI(config.get("EINFORMA", "api_key"))

    empresa = api.buscar_empresa(cif)

    # Enriquecer ficha de cliente
    return {
        "cif": empresa["cif"],
        "razon_social": empresa["razon_social"],
        "direccion": empresa["direccion"],
        "telefono": empresa["telefono"],
        "email": empresa["email"],
        "ventas_anuales": empresa["ventas"],
        "empleados": empresa["empleados"],
        "rating_crediticio": empresa["rating"]
    }
```

---

## 6. Flet

### Descripción
Framework Python para interfaces de escritorio multiplataforma (ver `ADDON/server_flet.md`).

### Casos de Uso
- Aplicaciones de escritorio nativas
- Alternativa a Interfaz web
- Mejor rendimiento en equipos antiguos

### Qué Problema Resuelve
Opción para usuarios que prefieren desktop apps sobre web apps, mejor integración con sistema operativo.

### Ejemplo de Uso
```
# ADDON/server_flet.md
import flet

def main(page):
    page.title = "Centralita Teamleader"
    page.theme_mode = flet.ThemeMode.DARK

    # Botón de última llamada
    btn_ultima_llamada = flet.ElevatedButton(
        "Última Llamada",
        on_click=mostrar_ultima_llamada
    )

    page.add(btn_ultima_llamada)

flet.app(target=main)
```

---

## Resumen de Integraciones

| Integración | Estado | Tipo | Uso Principal |
|-------------|--------|------|---------------|
| Teamleader API | ✅ | CRM | Sincronización de contactos, notas |
| OBS Studio | ✅ | Grabación | Audio de alta calidad |
| Sage 50 | 🔲 | Contabilidad | Facturas, clientes |
| OpenRouter | ✅ | IA | Transcripción de llamadas |
| eInforma | 🔲 | Datos comerciales | Enriquecimiento de empresas |
| Flet | 🔲 | UI | Aplicaciones desktop |

## Próximos Pasos

- [ ] Configurar Teamleader API: ver [[arquitectura]] para detalles de OAuth2
- [ ] Configurar OBS Studio: revisar [[funcionalidades-core#2-grabacion-de-audio]]
- [ ] Configurar OpenRouter: consultar [[funcionalidades-core#3-transcripcion-ia]]
- [ ] Revisar [[casos-de-uso]] para ejemplos de integración
