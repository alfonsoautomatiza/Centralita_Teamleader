---
title: Instalación y primer inicio de Centralita ia Teamleader
description: Requisitos, instalación en Windows y primeros pasos para abrir Centralita ia Teamleader y completar su asistente inicial.
lang: es
tags:
  - contexto/proyecto/manual

---

# Instalación y primer inicio

La aplicación se distribuye como un paquete para Windows. Para usarla no necesitas instalar Python, MkDocs ni herramientas de desarrollo.

## Antes de empezar

Confirma que dispones de:

- Un equipo con Windows 10 u 11.
- El paquete de Centralita IA Teamleader entregado por una fuente autorizada.
- Una licencia válida de la aplicación.
- Tu **Client ID** y **API Secret** de Teamleader.
- Permiso de escritura en la carpeta donde se ejecutará la aplicación.
- Una API key de Google AI o OpenRouter, solo si vas a activar el análisis con IA.

Para detectar llamadas de un teléfono Android también necesitas Just Remote Phone en el móvil y su componente CallCenter para Windows. Puedes añadirlo después.

## Instalar la aplicación

1. Cierra cualquier versión anterior de Centralita IA Teamleader.
2. Extrae o instala el paquete completo en la ubicación indicada por tu responsable.
3. Mantén juntos `centralita_teamleader.exe` y las carpetas incluidas en el paquete. No ejecutes una copia aislada del `.exe`.
4. Abre `centralita_teamleader.exe`.
5. Si Windows muestra una advertencia, comprueba el origen y la firma del archivo. No continúes si no puedes verificar quién lo entregó.

!!! warning "No reutilices configuraciones sin revisar"
    `config.ini` puede contener credenciales y rutas propias de otro equipo. Usa únicamente el archivo preparado para tu instalación.

## Completar el asistente inicial

En el primer inicio, la aplicación abre la configuración en el navegador y muestra siete pasos:

1. **Bienvenida**: resume los servicios que puedes configurar.
2. **Conexión CRM**: introduce y valida las credenciales de Teamleader.
3. **Grabadora**: elige **No grabar**, **Interno** u **OBS Studio**.
4. **Análisis IA**: activa Google AI u OpenRouter si lo necesitas.
5. **Prompts IA**: revisa las instrucciones según los tipos de llamada.
6. **Netelip DTMF**: configúralo solo si tu organización utiliza ese servicio.
7. **Finalizar**: revisa el resumen y pulsa **Iniciar Centralita**.

Los pasos opcionales se pueden omitir y completar más adelante desde **Configuración**. **Terminar Rápido** permite entrar sin validar el CRM, pero las funciones de Teamleader quedarán pendientes.

## Comprobar que está lista

- [ ] La aplicación permanece activa en el área de notificación de Windows.
- [ ] La página de configuración no muestra errores de guardado.
- [ ] **API CRM** aparece conectada después de validar Teamleader.
- [ ] La grabadora refleja el modo elegido.
- [ ] Si activaste IA, el proveedor y el modelo responden a la verificación.
- [ ] Una búsqueda manual abre una ficha o solicita crear el contacto.

Si alguna comprobación falla, ve a [Solución de problemas](incidencias.md).

## Siguiente paso

Continúa con [Configurar la centralita](configuracion.md) para revisar Teamleader, audio e IA.
