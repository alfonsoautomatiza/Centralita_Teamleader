---
title: Gestionar llamadas y prenotas en Centralita ia
description: Flujo diario para buscar teléfonos, atender llamadas, seleccionar contexto en Teamleader y revisar las notas generadas por ia.
lang: es
tags:
  - contexto/proyecto/manual

---

# Gestionar llamadas

El flujo habitual empieza con una llamada detectada o una búsqueda manual. La aplicación consulta Teamleader, abre una prenota y, si corresponde, procesa la grabación con IA al finalizar.

## Antes de atender

- Comprueba que Centralita está activa en el área de notificación.
- Verifica **API CRM** en la configuración si vas a consultar Teamleader.
- Confirma el modo de grabación y el consentimiento aplicable.
- Si utilizas Just Remote Phone, comprueba que el móvil y el equipo estén enlazados.

## Atender una llamada detectada

1. Al comenzar una llamada externa, la aplicación identifica el número.
2. Teamleader busca contactos y empresas asociados.
3. Si encuentra una coincidencia, se abre la prenota con el cliente y su contexto.
4. Si no encuentra el número, se abre el formulario de alta para crear un contacto o una empresa.
5. Al colgar, se detiene la grabación activa y comienza el procesamiento posterior, si la IA está habilitada.

Las extensiones internas se identifican por separado y también pueden abrir una prenota, sin tratarlas como un teléfono externo.

## Buscar un teléfono manualmente

1. Abre **Buscar** desde el icono de la centralita.
2. Escribe el número en **Teléfono**.
3. Selecciona el **Tipo llamada**.
4. Pulsa **Buscar** o presiona Intro.
5. Revisa la coincidencia en Teamleader o completa el alta si no existe.

Si la búsqueda falla, revisa prefijo, país y número antes de crear un registro duplicado.

## Completar la prenota

1. Confirma el cliente mostrado.
2. Elige el tipo de llamada correcto.
3. Selecciona el producto tratado.
4. Resume el objetivo en **Objetivo o foco comercial**.
5. Anota datos concretos en **Apuntes en tiempo real**.
6. Marca solo las oportunidades, tickets, contactos, empresas o notas pertinentes.

!!! tip "Escribe hechos, no conclusiones vagas"
    Anota compromisos, fechas, objeciones y próximos pasos. Un contexto concreto produce un resumen más verificable.

## Grabar manualmente

1. Introduce el teléfono o usa `Local` si la grabación no está asociada a un número.
2. Pulsa el control de grabación para iniciar.
3. Pulsa de nuevo para detener y espera a que finalice el cierre del archivo.

No cierres la aplicación ni muevas el audio mientras se está procesando.

## Revisar la nota de IA

Antes de reutilizar el texto:

- [ ] Comprueba nombres, cifras, fechas y acuerdos.
- [ ] Distingue lo dicho en la llamada de las inferencias del modelo.
- [ ] Elimina información que no deba conservarse.
- [ ] Confirma el siguiente paso con la fuente original.

## Si cierras la aplicación durante el análisis

Al volver a iniciar, la centralita intenta recuperar tareas pendientes que tengan audio válido. No genera IA si el audio falta, es inválido o no contiene material suficiente.

## Siguiente paso

Consulta [Integración con Teamleader](teamleader.md) para entender qué datos aparecen y cómo evitar duplicados.
