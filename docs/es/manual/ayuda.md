---
title: Preguntas frecuentes y soporte de Centralita ia
description: Respuestas sobre grabación, privacidad, Teamleader e ia y checklist para solicitar soporte sin exponer credenciales.
lang: es
tags:
  - contexto/proyecto/manual

---

# Preguntas frecuentes y soporte

## Preguntas frecuentes

### ¿Necesito instalar Python?

No. La aplicación de usuario se entrega como un paquete para Windows. Python y `uv` solo son necesarios para desarrollo.

### ¿Teamleader es obligatorio?

La aplicación puede iniciarse con **Terminar Rápido**, pero la búsqueda de clientes y el contexto CRM no estarán operativos hasta validar Teamleader.

### ¿La grabación y la IA son obligatorias?

No. Puedes usar Teamleader sin grabar y grabar sin activar IA. Elige el modo que corresponda a las políticas de tu organización.

### ¿La IA guarda siempre una nota correcta?

No. La calidad depende del audio, el contexto, el prompt y el modelo. Revisa nombres, cifras, fechas, acuerdos e inferencias antes de utilizar el resultado.

### ¿Qué ocurre si cierro la aplicación durante un análisis?

Al iniciar de nuevo, la centralita intenta recuperar tareas pendientes con audio válido. No puede recuperar un archivo ausente, dañado o insuficiente.

### ¿Puedo enviar `config.ini` a soporte?

No. Puede contener credenciales, tokens y rutas internas. Envía el mensaje de error y los datos de diagnóstico, nunca secretos.

## Pedir soporte

Utiliza el canal de soporte indicado en tu contrato, licencia o por la persona responsable de la instalación. Antes de contactar, reúne:

- Versión de la aplicación y de Windows.
- Fecha y hora del problema.
- Pasos mínimos para reproducirlo.
- Texto completo del mensaje de error.
- Estado visible de Teamleader, grabación e IA.
- Captura recortada, solo si no muestra datos personales ni secretos.
- Fragmento de log relevante, revisado y enviado por un canal autorizado.

## Qué no debes enviar

- Client ID o API Secret de Teamleader.
- API keys de Google AI u OpenRouter.
- Tokens de Netelip o contraseñas de OBS.
- `config.ini`, `licencia.lic` o bases de datos completas.
- Grabaciones de clientes sin autorización.

## Antes de cerrar la incidencia

- [ ] Repite el flujo que fallaba.
- [ ] Comprueba que los cambios se guardaron.
- [ ] Verifica una llamada o búsqueda de prueba.
- [ ] Documenta qué acción resolvió el problema.

También puedes consultar el sitio de [ALCATIC](https://alcatic.es/) para información general. Los canales contractuales de tu instalación tienen prioridad para soporte del producto.
