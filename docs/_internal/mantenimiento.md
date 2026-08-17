---
title: Mantenimiento del manual
description: Instrucciones internas de compilación, publicación, Search Console y activos sociales.
robots: noindex
tags:
  - contexto/proyecto/manual

---

# Mantenimiento del manual

Este archivo está excluido del sitio público mediante `exclude_docs`.

## Desarrollo local

```bash
uvx --from mkdocs==1.6.1 --with mkdocs-material==9.7.6 mkdocs serve
uvx --from mkdocs==1.6.1 --with mkdocs-material==9.7.6 mkdocs build --strict
```

`uvx` mantiene las herramientas del manual separadas del entorno Windows de la aplicación.

## Publicación

El repositorio conserva las fuentes del manual de forma local y publica únicamente el sitio generado en la rama `gh-pages`.

1. Ejecuta `subir_a_github.bat` desde la raíz del manual.
2. El script construye el sitio con MkDocs 1.6.1 y Material 9.7.6 en modo estricto.
3. Revisa el resultado y confirma la publicación cuando el script lo solicite.
4. El script ejecuta `mkdocs gh-deploy --force --clean` con la misma toolchain fijada.
5. Verifica `https://wertymsd.github.io/Centralita_Teamleader/` y su `sitemap.xml`.

No añadas las fuentes a `master` ni cambies `.gitignore` para publicar. La rama `gh-pages` contiene la salida estática generada.

## Google Search Console

El override conserva el token de verificación que ya existía en este repositorio. Tras publicar, confirma la propiedad y envía:

`https://wertymsd.github.io/Centralita_Teamleader/sitemap.xml`

## Imagen social pendiente

Open Graph y Twitter publican título y descripción, pero no imagen. Añade `og:image` y `twitter:image` solo cuando exista un recurso aprobado de 1200 x 630 píxeles, sin datos personales ni placeholders.
