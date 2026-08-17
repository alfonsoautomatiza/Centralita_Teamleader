@echo off
setlocal
cd /d "%~dp0"
set PYTHONUTF8=1

echo Verificando el manual en modo estricto...
uvx --from mkdocs==1.6.1 --with mkdocs-material==9.7.6 mkdocs build --strict
if errorlevel 1 (
    echo.
    echo ERROR: El sitio no se publicara porque la compilacion ha fallado.
    exit /b 1
)

echo.
echo Build correcto.
echo El siguiente paso reemplazara el contenido publicado de la rama gh-pages.
choice /C SN /N /M "Deseas publicar ahora? [S/N]: "
if errorlevel 2 (
    echo Publicacion cancelada. No se ha enviado ningun cambio.
    exit /b 0
)

echo.
echo Publicando el sitio generado en la rama gh-pages...
uvx --from mkdocs==1.6.1 --with mkdocs-material==9.7.6 mkdocs gh-deploy --force --clean
if errorlevel 1 (
    echo.
    echo ERROR: No se pudo publicar el manual.
    exit /b 1
)

echo.
echo Publicacion completada en:
echo https://wertymsd.github.io/Centralita_Teamleader/

endlocal
