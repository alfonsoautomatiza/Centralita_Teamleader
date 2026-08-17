---
title: Novedades de la versión 0.1.1 de Centralita IA Teamleader
description: La 0.1.1 estrena el canal oficial de AlfonsoAutomatiza, la infraestructura de actualizaciones firmadas y mejoras de estabilidad y seguridad.
lang: es
tags:
  - contexto/proyecto/manual
---

# Novedades de Centralita IA Teamleader

## Versión 0.1.1 — 17 de agosto de 2026

Primera versión pública de Centralita IA Teamleader, la aplicación de escritorio para Windows que relaciona sus llamadas con Teamleader Focus y mantiene todo el contexto del cliente a mano.

### Novedades de la versión 0.1.1

Esta es la primera versión publicada a través del nuevo canal oficial de distribución de AlfonsoAutomatiza. Además de estrenar la nueva infraestructura de actualizaciones firmadas, la 0.1.1 incorpora mejoras de estabilidad, seguridad y correcciones detectadas desde la versión 0.1.0.

- **Nuevo canal de distribución oficial**: Centralita IA Teamleader se distribuye ahora desde `alfonsoautomatiza/Centralita_Teamleader`, con instalador oficial para Windows.
- **Nueva infraestructura de actualizaciones firmadas**: las próximas versiones se publicarán con manifiestos firmados digitalmente, garantizando que solo se distribuyan versiones oficiales verificables.
- **Mayor estabilidad con tareas simultáneas**: se han corregido bloqueos y posibles incoherencias de datos cuando varias tareas (llamadas, registros) se procesan a la vez.
- **Telefonía más segura**: la integración con Netelip exige ahora un token de seguridad cuando el webhook está expuesto en una dirección pública.
- **Comunicación local reforzada**: el servidor interno de la aplicación escucha únicamente en el propio equipo y valida los datos que recibe.
- **Mejor protección de las credenciales**: las claves de configuración ya no se guardan en el repositorio; se proporciona una plantilla de ejemplo.
- **Empresas mejor registradas en el CRM**: al crear una empresa en Teamleader ya no se usan apellidos como nombre de la empresa.
- **Arranque y bienvenida pulidos**: la pantalla de bienvenida muestra siempre su botón de cierre y la app se cierra correctamente sin licencia activa.
- **Paquete más ligero y fiable**: se elimina código sin uso y dependencias obsoletas.

### Lo que incluye esta versión

- **Integración con Teamleader Focus**: al recibir o emitir una llamada, la centralita busca el contacto o la empresa y abre su ficha en el navegador.
- **Prenota con contexto comercial**: oportunidades, tickets y notas anteriores del cliente, visibles mientras atiende la llamada.
- **Marcación con un clic**: lance llamadas desde la centralita sin teclear el número.
- **Grabación de llamadas**: grabación interna o mediante OBS Studio, según su configuración.
- **Análisis con IA**: transcripción y resumen automático de cada llamada grabada para no tomar notas a mano.
- **Búsqueda manual y hoja de tiempo**: consulte cualquier teléfono y revise el historial completo de llamadas.
- **Bandeja del sistema**: acceso rápido a búsquedas, última llamada, hoja de tiempo y configuración.
- **Configuración web**: ajuste la centralita desde el navegador, sin reiniciar la aplicación.
- **Instalador oficial para Windows**: instalador para Windows de 64 bits, con la nueva infraestructura de actualizaciones firmadas lista para las próximas versiones.

### Cómo empezar

1. Descargue el instalador desde [Descargar software](../es/castellano/link-descarga-software-centralita-teamleader.md).
2. Siga los pasos de [Instalación y primer inicio](../es/manual/instalacion.md).
3. Conecte Teamleader con la [guía de configuración](../es/manual/configuracion.md).

!!! tip "Configure solo lo que use"
    La grabación, la IA y la telefonía por software son opcionales y pueden activarse más adelante.
