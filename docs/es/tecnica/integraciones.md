---
title: Integración OBS Studio con Centralita Teamleader | Guía de Grabación de Alta Calidad
date: 2025-03-29
keywords:
  - obs studio centralita
  - grabación alta calidad llamadas
  - conexion obs centralita
  - grabación audio centralita
  - configurar obs studio
  - softphone voip grabación
  - zoiper 3cx centralita
  - grabación ambos lados llamada
aliases:
  - /obs-studio
  - /grabacion-obs
  - /integraciones
  - /grabacion-alta-calidad
description: Aprenda a configurar OBS Studio con Centralita Teamleader para grabar llamadas en alta calidad y capturar ambos lados de la conversación.
tags:
  - contexto/proyecto/manual
  - obs
  - grabación
  - audio
  - integración
  - voip
  - alta calidad
status: published
---

# 🎙️ Integración OBS Studio - Grabación de Alta Calidad

OBS Studio permite grabar llamadas con **audio de muy alta calidad**, capturando ambos lados de la conversación. Es ideal para usuarios que necesitan grabaciones profesionales o que usan softphones VoIP (Zoiper, 3CX, etc.).

---

## 🎯 ¿Cuándo Usar OBS Studio?

### Comparación: Grabación Interna vs OBS Studio

| Aspecto | Grabación Interna | OBS Studio |
|---------|------------------|------------|
| **Calidad** | Estándar | ✅ Muy alta |
| **Configuración** | Automática | Requiere setup |
| **Audio capturado** | Solo micrófono | ✅ Ambos lados |
| **Softphones** | No compatible | ✅ Compatible (Zoiper, 3CX) |
| **Recursos** | Bajo consumo | Moderado consumo |
| **Ideal para** | Uso diario básico | Grabaciones profesionales |

!!! tip "Recomendación"
    Use **grabación interna** para uso diario. Use **OBS Studio** solo si necesita:
    - Grabación de muy alta calidad
    - Capturar ambos lados de softphones VoIP
    - Grabaciones para fines legales o de archivo

---

## ⚙️ Requisitos Previos

Antes de configurar OBS Studio con Centralita:

| Requisito | Detalle |
|-----------|---------|
| **OBS Studio** | Instalado y ejecutándose |
| **Complemento de conexión de OBS** | Instalado y configurado |
| **Puerto 4455** | Disponible en su PC |
| **Centralita** | Ejecutándose |

### Descargar e Instalar OBS Studio

1. **Descargue OBS Studio** desde [obsproject.com](https://obsproject.com/)
2. **Ejecute el instalador**
3. **Siga los pasos del asistente**
4. **Finalice la instalación**

### Instalar el complemento de conexión de OBS

1. **Descargue el complemento** desde la página oficial del proyecto
2. **Extraiga el archivo ZIP**
3. **Copie la carpeta del complemento** a:
   - **Windows 10/11**: `C:\Users\<SuUsuario>\AppData\Roaming\OBS-Studio\plugins\`
4. **Reinicie OBS Studio** si estaba ejecutándose

!!! warning "⚠️ Importante"
    Reinicie OBS Studio después de instalar el plugin para que surta efecto.

---

## 🔧 Configurar OBS Studio

### Paso 1: Configurar Audio en OBS

1. **Abra OBS Studio**
2. **Navegue a Archivo** → **Configuración**
3. **Vaya a la pestaña "Audio"**
4. **Configure las fuentes de audio**:

   | Fuente de audio | Dispositivo |
   |----------------|-------------|
   | **Audio de escritorio** | Su dispositivo de audio predeterminado |
   | **Micrófono/Auxiliar** | Su micrófono conectado |

5. **Haga clic en "Aceptar"**

### Paso 2: Configurar Escena y Fuentes

1. **En la sección "Escenas"**, cree una nueva escena:
   - Nombre: "Grabación Llamada"

2. **En la sección "Fuentes"**, añada:
   - **Fuente 1**: "Captura de audio de aplicación"
     - Seleccione su softphone (Zoiper, 3CX, etc.)
   - **Fuente 2**: "Captura de audio de entrada"
     - Seleccione su micrófono

!!! tip "Consejo"
    Puede probar que el audio se captura correctamente hablando y verificando los medidores de audio en OBS.

### Paso 3: Configurar Salida de Grabación

1. **Vaya a Archivo** → **Configuración**
2. **Pestaña "Salida"**
3. **Sección "Grabación"**:
   - **Tipo de grabación**: Estándar
   - **Formato de grabación**: mp3 o wav (mp3 recomendado, menor tamaño)
   - **Codificador de audio**: AAC
   - **Bitrate**: 160 o 192 (mayor calidad)
4. **Pestaña "Avanzado"**:
   - **Sección "Grabación"**:
     - **Formato de archivo de grabación**: `%CCYY-%MM-%DD %hh-%mm-%ss` (nombre con fecha y hora)
     - **Ruta de grabación**: `D:\centralita_ia\rec\` (o su carpeta preferida)

5. **Haga clic en "Aceptar"**

### Paso 4: Activar la conexión con OBS

1. **Vaya a Herramientas** → **Ajustes de conexión**
2. **Configure los siguientes valores**:

   | Configuración | Valor |
   |---------------|-------|
| **Activar control remoto** | ✅ Marcado |
   | **Puerto** | 4455 |
   | **Contraseña** | (Déjelo en blanco o configure una) |
   | **Permitir conexiones desde** | Solo localhost |

3. **Haga clic en "Aceptar"**

!!! success "✅ OBS Studio Configurado"
    OBS Studio ahora está listo para integrarse con Centralita. Mantenga OBS Studio ejecutándose mientras usa Centralita.

---

## 🔌 Configurar Centralita con OBS Studio

### Paso 1: Abrir Configuración de Centralita

1. **Haga clic con el botón derecho** en el icono de Centralita (bandeja del sistema)
2. **Seleccione "Configuración"**

### Paso 2: Configurar Modo de Grabación

1. **Navegue a la sección "Grabación"**
2. **En "Modo de grabación"**, seleccione: `2` (OBS Studio)
3. **Haga clic en "Guardar"**

!!! info "Nota"
    Centralita detectará automáticamente si OBS Studio está ejecutándose y usará la conexión con OBS para controlar la grabación.

---

## 🎬 Flujo de Grabación con OBS Studio

### Durante una Llamada

1. **Llamada entrante/saliente**
2. **Centralita detecta la llamada**
3. **Centralita envía la orden a OBS Studio** para iniciar la grabación
4. **OBS Studio empieza a grabar automáticamente**
5. **Ambos lados de la conversación** se capturan
6. **Al colgar, Centralita detiene la grabación**

### Archivo de Audio Generado

El archivo se guarda en la ruta configurada en OBS Studio:

```
D:\centralita_ia\rec\2025-03-29 15-30-45.mp3
```

**Formato del nombre de archivo**:
- `Año-Mes-Día Hora-Minuto-Segundo.mp3`
- Facilita la organización cronológica

---

## 🔧 Solución de Problemas

### Problema: Centralita no controla OBS Studio

**Causa posible**: OBS Studio no está ejecutándose o la conexión con OBS no está habilitada.

**Solución**:
1. Verifique que OBS Studio está **ejecutándose**
2. Vaya a **Herramientas** → **Ajustes de conexión**
3. Verifique que el control remoto está **habilitado**
4. Verifique que el puerto es **4455**
5. Verifique que no hay firewall bloqueando el puerto

### Problema: El audio solo captura un lado

**Causa posible**: Las fuentes de audio no están configuradas correctamente.

**Solución**:
1. En OBS Studio, vaya a **Fuentes**
2. Añada **"Captura de audio de aplicación"** para el softphone
3. Añada **"Captura de audio de entrada"** para el micrófono
4. Verifique que ambas fuentes están **activadas**
5. Pruebe hablando y verifique los medidores de audio

### Problema: Los archivos de audio no se guardan

**Causa posible**: La ruta de grabación no existe o no tiene permisos.

**Solución**:
1. Cree la carpeta manualmente: `D:\centralita_ia\rec\`
2. Verifique que tiene **permisos de escritura** en la carpeta
3. En OBS Studio, vaya a **Archivo** → **Configuración** → **Salida**
4. Verifique que la ruta es correcta

### Problema: OBS Studio consume muchos recursos

**Causa posible**: Configuración de calidad demasiado alta.

**Solución**:
1. En OBS Studio, vaya a **Archivo** → **Configuración** → **Salida**
2. Reduzca el bitrate de audio (ej: 128 en lugar de 192)
3. Use formato mp3 en lugar de wav (tamaño menor)
4. Cierre otras aplicaciones que consuman recursos

---

## 💡 Consejos de Uso

### Para Mejorar la Calidad de Grabación

1. **Use un auricular con micrófono de calidad**
   - Minimiza el ruido ambiental
   - Mejora la claridad de la voz

2. **Realice llamadas en entorno silencioso**
   - Evita ruido de fondo (TV, tráfico, etc.)

3. **Ajuste los niveles de audio en OBS**
   - Medidores no deben llegar al rojo (clipping)
   - Nivel óptimo: alrededor de -12 dB a -6 dB

### Para Organizar las Grabaciones

1. **Use la carpeta por defecto**: `D:\centralita_ia\rec\`
2. **Los nombres incluyen fecha y hora**: Facilitan búsqueda
3. **Puede crear subcarpetas**: Ej: `D:\centralita_ia\rec\2025\03\`
4. **Backups regulares**: Copie grabaciones importantes a otra ubicación

### Para Integración con Softphones VoIP

**Softphones compatibles**:
- ✅ Zoiper
- ✅ 3CX
- ✅ Linphone
- ✅ Otros softphones estándar

**Configuración**:
1. En OBS Studio, añada **"Captura de audio de aplicación"**
2. Seleccione el softphone que usa
3. Verifique que el audio del softphone se captura hablando por el softphone

!!! tip "Verificación"
    Llame a un número de prueba (ej: su propio móvil) y verifique que OBS Studio captura el audio del softphone.

---

## 🎓 Alternativas a OBS Studio

Si OBS Studio le parece demasiado complejo:

### Opción 1: Grabación Interna de Centralita

- **Calidad**: Estándar
- **Configuración**: Automática
- **Uso**: Ideal para uso diario básico

Para activar:
1. Abra Configuración de Centralita
2. En "Grabación", seleccione modo `1` (Interna)
3. Guarde

### Opción 2: Software de Grabación de Llamadas

Existen aplicaciones dedicadas para grabar llamadas:
- **Call Recorder** (Android)
- **ACR** (Android)
- **Otros softphones con grabación integrada**

!!! info "Nota"
    La grabación interna de Centralita es suficiente para la mayoría de usuarios. Use OBS Studio solo si necesita calidad profesional.

---

## ✅ Checklist de Configuración

Antes de usar OBS Studio con Centralita, verifique:

- [ ] OBS Studio instalado
- [ ] Complemento de conexión de OBS preparado
- [ ] Control remoto habilitado (puerto 4455)
- [ ] Fuentes de audio configuradas (softphone + micrófono)
- [ ] Ruta de grabación configurada
- [ ] OBS Studio ejecutándose
- [ ] Centralita configurada en modo `2` (OBS Studio)
- [ ] Prueba de grabación realizada exitosamente

---

## 📞 Soporte

Si tiene problemas con la integración OBS Studio:

- **Email**: soporte@alcatic.com
- **Web**: [https://alca.co/](https://alca.co/)
- **Horario**: Lunes a Viernes, 9:00 - 18:00 (CET)

!!! tip "Consejo"
    Para una resolución más rápida, incluya capturas de pantalla de:
   - Configuración de audio en OBS Studio
   - Fuentes de audio configuradas
   - Ajustes de conexión con OBS

---

## ✅ Conclusión

La integración con **OBS Studio** permite grabaciones de muy alta calidad capturando ambos lados de la conversación. Es ideal para:

- ✅ Grabaciones profesionales
- ✅ Archivo legal de llamadas
- ✅ Usuarios de softphones VoIP (Zoiper, 3CX, etc.)
- ✅ Entornos donde la calidad de audio es crítica

!!! success "¿Configurado?"
    Una vez configurado, OBS Studio funcionará automáticamente con Centralita. No necesita controlar OBS manualmente durante las llamadas.

¿Prefiere usar la grabación interna más sencilla? Consulte la [Pantalla de Configuración](../castellano/pantalla-configuracion-centralita-teamleader.md) para cambiar el modo de grabación.
