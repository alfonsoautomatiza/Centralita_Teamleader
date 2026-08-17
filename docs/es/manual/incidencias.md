---
title: Solución de problemas de Centralita ia Teamleader
description: Diagnóstico paso a paso para errores de Teamleader, detección de llamadas, grabación, OBS y análisis con ia.
lang: es
tags:
  - contexto/proyecto/manual

---

# Solución de problemas

Empieza por el síntoma visible y realiza una sola comprobación cada vez. Guarda los cambios antes de repetir la prueba.

## Teamleader no conecta

1. Confirma que el **Client ID** y el **API Secret** pertenecen a la misma integración.
2. Elimina espacios al principio o al final.
3. Comprueba que la integración sigue activa y autorizada en Teamleader.
4. Guarda y vuelve a validar.
5. Si cambiaste las credenciales, completa de nuevo la autorización.

No publiques la pantalla de credenciales ni adjuntes `config.ini`.

## El asistente vuelve a aparecer

El asistente solo se considera completado después de pulsar **Iniciar Centralita**. Si el estado no se conserva, comprueba permisos de escritura en la carpeta de la aplicación.

## No se detectan llamadas

1. Abre **Configuración → App Android**.
2. Comprueba que **¿Usar APP Android?** está activado.
3. Verifica que Just Remote Phone está instalado y enlazado en móvil y Windows.
4. Reinicia la centralita tras corregir la conexión.
5. Usa [una búsqueda manual](uso-diario.md#buscar-un-telefono-manualmente) para separar un fallo telefónico de un fallo de Teamleader.

## No se graba audio

1. Revisa el modo en **GRABADORA LLAMADAS**.
2. En modo **Interno**, confirma que la carpeta de audio existe y permite escribir.
3. En modo **OBS**, inicia OBS y revisa host, puerto, contraseña, ruta y escena.
4. Pulsa **Probar Conexión OBS**.
5. Repite con una llamada breve de prueba y comprueba el archivo antes de activar IA.

## La IA no responde

1. Confirma que **Activar Funcionalidad IA** está marcado.
2. Revisa proveedor, API key y modelo.
3. Pulsa **Aplicar configuración IA** y después **Verificar conexión IA**.
4. Si el modelo no existe, selecciona uno de la lista actual.
5. Comprueba primero que la grabación produjo audio válido.

Una grabación vacía, demasiado corta, dañada o todavía en escritura puede quedar marcada sin análisis.

## La prenota no muestra datos

1. Verifica **API CRM**.
2. Busca la persona directamente en Teamleader.
3. Prueba el número con su prefijo internacional.
4. Abre el enlace original y confirma la coincidencia antes de continuar.

## La configuración no se guarda

1. Pulsa **Guardar cambios** en la barra lateral.
2. Comprueba que no quede el aviso de cambios pendientes.
3. Revisa permisos de escritura sobre la carpeta de la aplicación y `config.ini`.
4. Evita abrir dos instancias a la vez.

## Reunir información para soporte

- Versión de Centralita IA Teamleader y de Windows.
- Hora aproximada del fallo.
- Acción exacta y mensaje completo.
- Estado de API CRM, grabadora e IA.
- Si ocurre siempre o solo con un número o llamada.

## Siguiente paso

Si el problema continúa, prepara la consulta con [Preguntas frecuentes y soporte](ayuda.md#pedir-soporte).
