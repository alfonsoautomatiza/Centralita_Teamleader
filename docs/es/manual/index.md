---
title: Manual de uso de Centralita ia Teamleader
description: Elige una tarea para instalar, configurar y usar Centralita ia Teamleader o resolver una incidencia sin recorrer toda la referencia.
lang: es
tags:
  - contexto/proyecto/manual

---

# Trabaja con Centralita IA Teamleader

Esta ruta breve reúne las tareas habituales. Las guías detalladas y la referencia técnica siguen disponibles en la navegación cuando necesites más contexto.

## Elige tu punto de partida

| Si necesitas... | Ve a... | Resultado |
| --- | --- | --- |
| Preparar un equipo nuevo | [Instalación y primer inicio](instalacion.md) | Aplicación abierta y asistente inicial disponible |
| Conectar Teamleader, audio o IA | [Configurar la centralita](configuracion.md) | Servicios necesarios validados |
| Atender o buscar una llamada | [Gestionar llamadas](uso-diario.md) | Prenota abierta con el contexto correcto |
| Entender qué consulta en el CRM | [Integración con Teamleader](teamleader.md) | Contactos, empresas y actividad identificados |
| Recuperarte de un error | [Solución de problemas](incidencias.md) | Diagnóstico y siguiente acción claros |
| Preparar una consulta de soporte | [Preguntas frecuentes y soporte](ayuda.md) | Información útil reunida sin compartir secretos |

## Primera puesta en marcha

1. Abre `centralita_teamleader.exe` desde la carpeta entregada por tu responsable o proveedor.
2. Completa la conexión con Teamleader en el asistente de configuración.
3. Elige si vas a grabar llamadas y si quieres analizarlas con IA.
4. Pulsa **Iniciar Centralita** y comprueba el estado de las conexiones.
5. Haz una [búsqueda manual de prueba](uso-diario.md#buscar-un-telefono-manualmente).

!!! tip "Configura solo lo que uses"
    Teamleader es la conexión principal. La grabación, la IA, Just Remote Phone, OBS y Netelip son opcionales y pueden configurarse más tarde.

## Cómo funciona una llamada

1. La centralita detecta el número o recibe una búsqueda manual.
2. Teamleader busca coincidencias entre contactos y empresas.
3. La prenota muestra el cliente y, cuando existen, oportunidades, tickets y notas anteriores.
4. Tú eliges el tipo de llamada, el producto y el contexto relevante.
5. Si la grabación y la IA están activadas, el análisis se genera después de finalizar el audio.

La IA puede ahorrar tiempo, pero su resultado debe revisarse antes de usarlo como información comercial, técnica o administrativa.

## Privacidad y seguridad

- No compartas claves de Teamleader, API keys de IA, tokens ni contraseñas de OBS.
- No adjuntes `config.ini` a una solicitud de soporte: puede contener credenciales.
- Informa a las personas participantes y aplica la normativa de tu organización antes de grabar llamadas.
- Revisa los resúmenes generados por IA antes de copiarlos a un sistema de registro.

## Siguiente paso

Si es la primera vez que usas la aplicación, continúa con [Instalación y primer inicio](instalacion.md).
