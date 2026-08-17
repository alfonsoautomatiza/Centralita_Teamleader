---
title: Configurar Teamleader, grabación e ia
description: Configura de forma segura Teamleader, la grabación interna u OBS, el análisis de llamadas con ia y los servicios opcionales.
lang: es
tags:
  - contexto/proyecto/manual

---

# Configurar la centralita

Abre **Configuración** desde el menú de la aplicación. Los cambios generales no se aplican hasta pulsar **Guardar cambios** en la barra lateral; **Cancelar** descarta el borrador actual.

## Orden recomendado

1. Valida **API TEAMLEADER**.
2. Elige un modo en **GRABADORA LLAMADAS**.
3. Configura **ANALISIS LLAMADAS (IA)** si vas a utilizarlo.
4. Revisa **Prompts IA** y el catálogo de productos.
5. Configura solo después los servicios opcionales.
6. Guarda y comprueba el estado de conexiones.

## Conectar Teamleader

1. En Teamleader Focus, abre [Integraciones](https://developer.focus.teamleader.eu/integrations).
2. Crea una integración o usa una existente autorizada por tu organización.
3. En **API TEAMLEADER**, introduce el **Client ID** y el **API Secret**.
4. Pulsa **Validar Login**.
5. Espera el mensaje **Validación exitosa** antes de continuar.

La validación conserva los valores introducidos. Si cambias las credenciales, la aplicación elimina los tokens anteriores y solicita una sesión nueva.

!!! danger "Protege las credenciales"
    No pegues claves en correos, capturas ni tickets. No compartas `config.ini` y no publiques una API key de IA.

## Elegir el modo de grabación

| Modo | Cuándo usarlo | Qué debes configurar |
| --- | --- | --- |
| **No** | No se grabarán llamadas | Nada |
| **Interno** | Grabación directa en el equipo | Carpeta de audio con permisos de escritura |
| **OBS** | Tu flujo ya utiliza OBS Studio | Host, puerto, contraseña, ruta y escena |

Para OBS:

1. Inicia OBS Studio y habilita su WebSocket.
2. Selecciona **OBS** y activa **Grabadora Llamadas (OBS)**.
3. Completa host, puerto, contraseña y carpeta de grabaciones.
4. Elige una escena existente.
5. Pulsa **Probar Conexión OBS**.

Una ruta inexistente o sin permisos impide validar la configuración.

## Activar el análisis con IA

1. Abre **ANALISIS LLAMADAS (IA)** y activa la funcionalidad.
2. Elige **Google AI (Gemini)** u **OpenRouter**.
3. Introduce la API key del proveedor.
4. Selecciona uno de los modelos disponibles.
5. Revisa el catálogo de productos que aparecerá en la prenota.
6. Pulsa **Aplicar configuración IA**.
7. Pulsa **Verificar conexión IA**.

La lista de modelos depende del proveedor y de la clave. Si un modelo deja de existir, elige otro disponible y vuelve a guardar.

### Ajustar los prompts

En **Prompts IA** puedes modificar las instrucciones base y las instrucciones adicionales por tipo de llamada. Conserva las variables `{NOMBRE}`, `{CONTEXTO}` y `{PRODUCTO}` si quieres que la nota utilice los datos elegidos en la prenota.

## Configurar servicios opcionales

### App Android

Activa **¿Usar APP Android?** para detectar el estado y el número de llamadas de un teléfono enlazado mediante Just Remote Phone.

### Campos libres

**Campos libres (TL)** relaciona campos de empresa de Teamleader con campos de la fuente de datos disponible. Si las listas están vacías, valida primero la conexión CRM.

### Backup

Elige una carpeta existente y una frecuencia válida para tu instalación. Comprueba la copia manual antes de confiar en la programación automática.

### Netelip DTMF

Actívalo únicamente si tu instalación utiliza un endpoint Netelip preparado por el equipo técnico. La URL, el token y la extensión son datos sensibles.

## Verificación final

- [ ] Teamleader muestra una validación correcta.
- [ ] La carpeta de audio existe y permite escribir.
- [ ] OBS responde, si elegiste ese modo.
- [ ] IA responde con el proveedor y modelo guardados, si está activa.
- [ ] No quedan cambios pendientes en la barra lateral.

## Siguiente paso

Haz una prueba siguiendo [Gestionar llamadas](uso-diario.md).
