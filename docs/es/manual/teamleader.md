---
title: Integración de Centralita ia con Teamleader Focus
description: Cómo conecta Centralita ia con Teamleader Focus para buscar contactos y empresas y preparar el contexto de una llamada.
lang: es
tags:
  - contexto/proyecto/manual

---

# Integración con Teamleader

Centralita IA utiliza una integración autorizada de Teamleader Focus para relacionar un teléfono con información del CRM. Las funciones disponibles dependen de los permisos concedidos.

## Preparar la conexión

1. Abre [Integraciones de Teamleader](https://developer.focus.teamleader.eu/integrations).
2. Crea o selecciona una integración aprobada por tu organización.
3. Copia su **Client ID** y **API Secret** en **Configuración → API TEAMLEADER**.
4. Pulsa **Validar Login** y espera la confirmación.

No copies tokens manualmente ni reutilices las credenciales de otra organización.

## Qué consulta durante una llamada

| Información | Uso en la centralita |
| --- | --- |
| Contactos y empresas | Identificar a la persona y la organización |
| Oportunidades | Seleccionar el contexto comercial relevante |
| Tickets activos | Relacionar una incidencia o seguimiento |
| Notas anteriores | Recuperar antecedentes antes de responder |
| Enlaces de Teamleader | Abrir la ficha original para verificar los datos |

La prenota solo muestra la información disponible para la coincidencia y los permisos actuales.

## Cuando el teléfono no existe

Antes de confirmar un alta:

1. Busca el número con y sin prefijo internacional.
2. Comprueba si la persona ya existe con otro teléfono.
3. Decide si corresponde crear un contacto, una empresa o ambos.
4. Revisa nombre, apellidos, empresa, correo y dirección.
5. Corrige cualquier correo marcado como no válido.

## Seleccionar contexto para la nota

Selecciona solo elementos pertinentes. Incluir una oportunidad o un ticket que no corresponde puede producir un resumen convincente pero incorrecto.

## Campos libres de empresa

1. Valida Teamleader para cargar las listas disponibles.
2. Elige un campo de Teamleader y su campo de origen.
3. Pulsa **Añadir Relacion**.
4. Revisa **Relaciones Actuales**.
5. Pulsa **Guardar Relaciones**.

## Buenas prácticas

- Usa una integración específica y con los permisos mínimos necesarios.
- Revoca credenciales antiguas cuando cambie la persona responsable.
- Verifica en Teamleader cualquier dato crítico antes de actuar.
- Revisa posibles duplicados antes de crear contactos o empresas.

## Siguiente paso

Si la validación o la búsqueda falla, sigue [Solución de problemas](incidencias.md#teamleader-no-conecta).
