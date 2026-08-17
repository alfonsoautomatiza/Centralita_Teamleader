---
title: Centralita ia Teamleader system architecture
description: Technical overview of call detection, recording, AI processing, recovery and Teamleader integration components.
lang: en
tags:
  - contexto/proyecto/manual

---

# System Architecture

## Application Context

### Description
AI-powered call management system that integrates telephony, audio recording, automatic transcription with artificial intelligence, and synchronization with CRMs like Teamleader. Centralizes the management of incoming/outgoing calls, automates conversation summarization, and maintains a structured record of all interactions.

### Technology Stack
- **OBS Studio**: System audio recording (optional)
- **OpenRouter API**: AI transcription (Google Gemini)
- **Teamleader API**: CRM integration

### Target Audience
SMEs using Teamleader as CRM who need to automate phone call management with AI transcription, especially service companies, call centers, and sales teams.

---

## Frame-Driven Architecture

The system uses a "frames" architecture in `FRAMES/` that allows different implementations per CRM integration (Teamleader, Sage 50, etc.).

### Frame Concept
Files in the root (`conf.py`, `cuadro.py`, `procesos.py`) are shims that delegate to the active frame resolved by:
- Environment variable `CENTRALITA_FRAME`
- Active git branch
- Configuration in `config.ini`

### Frame Structure
```
FRAMES/
├── main/              # Main frame (Teamleader)
│   ├── conf.py        # Teamleader configuration
│   ├── cuadro.py      # Dashboard
│   └── procesos.py    # TL-specific processes
├── sage50/            # Sage 50 frame (if exists)
│   ├── conf.py
│   ├── cuadro.py
│   └── procesos.py
└── README.md          # Frame documentation
```

### Advantages
- **Same code base** for multiple products
- **Easy maintenance** of specific integrations
- **Dynamic switch** without recompiling
- **Isolation** of each CRM's logic

---

## Main Components

### 1. System Initialization

**Responsibility**: Main entry point and environment validation

**Key functionalities**:
- Environment and dependency validation
- Structured logging with DEBUG/INFO/WARNING/ERROR levels
- System initialization

---

### 2. Main Engine

**Responsibility**: Orchestration of all components

**Managed components**:
- **Core**: Configuration and global state
- **API**: Teamleader/OAuth client
- **Recording**: Audio recording (internal/OBS)
- **TaskManager**: Task management system
- **CallProcessor**: Call state detection
- **GUI**: System tray and menus

**Workflow**:
1. Call state detection
2. Automatic recording start
3. CRM search
4. Customer file opening
5. AI processing when call ends
6. Automatic CRM note creation

---

### 3. Task System

**Responsibility**: HEART of the system - management of recording, AI, backup and templates

**Main functionalities**:
- **Background recording** without blocking interface
- **AI processing** of transcriptions
- **Automatic backup** of recordings
- **Template processing** customization

**Features**:
- **Simultaneous execution** without blocking interface
- **Pre-AI audio validation** (avoids wasted credits)
- **Post-blackout recovery** from CSV
- **A/B testing** of AI prompts

### GestorCSV
State persistence in `hojatiempo.csv`:
- Record of all calls
- Processing status (audio, AI, CRM)
- URLs of created notes
- **Automatic recovery** after power outage

---

### 4. Unified Configuration

**Responsibility**: Centralized configuration with hot reload

**Functionalities**:
- Teamleader API (OAuth2, tokens)
- Multi-language system
- License management
- **Hot reload** without restarting

**Dynamic reload**:
- Detects changes in config.ini
- Reloads variables automatically
- Restarts translator
- Updates recording configuration

---

### 5. Dashboard

**Responsibility**: Configuration interface management

**Available interfaces**:
- **Configuration**: General configuration panel
- **Time sheet**: Call registry
- **Pre-notes**: Predefined notes management
- **Notes**: Note creation and management

**Features**:
- Web management interfaces
- Supervisor to avoid multiple instances
- Inactivity closure

---

## Recovery System

### CSV Persistence
`hojatiempo.csv` is the system's **RECOVERY MECHANISM**:

| Column | Description |
|---------|-------------|
| telefono | Phone number |
| fichero | Recorded audio path |
| entidad | Contact/Company found |
| tiempo | Call duration |
| estado | Audio finished, AI available, etc. |
| url | CRM note URL |

### Post-Blackout Recovery
The system automatically recovers unprocessed calls:
1. CSV reading
2. Filtering of records without AI
3. Verification of existing files
4. Reprocessing with AI
5. User notification

---

## Validation System

### Audio Cleaning (`libwertyaudiolimpieza.py`)

**AudioCleaner.prepare_wav_for_ia()**:
- **Minimum size**: 4096 bytes
- **Minimum duration**: 0.8 seconds
- **Valid format**: WAV/MP4
- **SHA256 Checksum**: File integrity

**Automatic retries**:
- 6 retries with 350ms delay
- For newly created files
- Avoids premature processing

---

## Integrations

### Teamleader API
**OAuth2 Flow**:
- `client_id`, `client_secret`
- `tl_access_token`, `tl_refresh_token`
- Automatic token refresh

**Operations**:
- Search contacts/companies
- Create notes/pre-notes
- Lookup by phone number

### OBS Studio (WebSocket)
**Remote control**:
- Remote recording control
- System audio recording

**Configuration**:
- Configurable OBS host
- Configurable OBS port
- Selectable audio mode

---

## Circuit Breaker

### Failure Isolation

**Isolation system**:
- Detects external service failures
- Isolates problematic services
- Automatically retries connections

**Monitored services**:
- OBS Studio
- Teamleader API
- OpenRouter API

---

## Health Checks

### Monitoring

**Monitoring system**:
- Periodic state checks
- Performance metrics
- Monitoring endpoints

**Verified components**:
- OBS Studio connected
- CRM API responding
- File system accessible

---

## Logs and Debugging

### Structured Logging
**Levels**:
- `DEBUG`: Execution details
- `INFO`: Important events
- `WARNING`: Non-critical alerts
- `ERROR`: Errors with traceback

**File**: `log_centralita.log`

**Current limitation**: No log rotation. For long-term production, recommend `RotatingFileHandler`.

---

## Configuration Files

### config.ini
MONOLITHIC file that controls EVERYTHING:

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
idioma=en
tema=DarkBlue16
```

---

## Important Observations

1. **CSV as distributed database**: `hojatiempo.csv` is not just a log - it's the RECOVERY MECHANISM. If corrupted or deleted, the ability to recover calls after blackouts is lost.

2. **Real-time configuration**: The system allows reloading configuration WITHOUT RESTARTING, crucial for users who frequently adjust prompts.

3. **License system**: The license controls which modules are active. Functions check license before executing.

4. **Dynamic menu**: The menu is built according to license and configuration - unauthorized modules don't appear.

5. **Mandatory audio cleaning**: The system validates ALL audio before sending to AI, preventing API credit waste.

---

## Key System Components

| Component | Responsibility |
|-----------|-----------------|
| Main Engine | System orchestration |
| Task System | Recording and AI management |
| Unified Configuration | Centralized configuration |
| Dashboard | Management interfaces |
| CRM Processes | CRM lookup and effects |
| Audio Validation | File validation |
| Failure Isolation | Error management |
| Monitoring | Health checks |
| config.ini | Main configuration |

---

## Next Steps

- [ ] Read [[../../tecnica/funcionalidades-core]] to learn about main functionalities
- [ ] Review [[../../tecnica/funcionalidades-avanzadas]] for v2 features
- [ ] Consult [[../../tecnica/integraciones]] to learn about available integrations
- [ ] See [[../../tecnica/casos-de-uso]] for practical examples
