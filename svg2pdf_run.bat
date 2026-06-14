@echo off
REM SVG zu PDF Konverter - Windows Batch Script
REM Einfache Ausführung des Python-Tools

echo ==========================================
echo  SVG zu PDF Konverter
echo ==========================================
echo.

REM Prüfen ob Python verfügbar ist
python --version >nul 2>&1
if errorlevel 1 (
  echo FEHLER: Python ist nicht installiert oder nicht im PATH verfügbar.
  echo Bitte installieren Sie Python 3.x von https://python.org
  pause
  exit /b 1
)

REM Standard-Pfade
set DEFAULT_INPUT="C:\Profile\SVG"
set DEFAULT_OUTPUT="C:\Profile\PDF"

REM Beispiel-Aufruf anzeigen
echo Verwendung:
echo  svg2pdf.py [Eingabe-Ordner] [Ausgabe-Ordner] [Optionen]
echo.
echo Standard-Pfade:
echo  Eingabe: %DEFAULT_INPUT%
echo  Ausgabe: %DEFAULT_OUTPUT%
echo.
echo Beispiele:
echo  python svg2pdf.py (verwendet Standard-Pfade)
echo  python svg2pdf.py --workers 8 --verbose
echo  python svg2pdf.py --min-date "01.01.2024"
echo.

REM Benutzer-Eingabe
echo Druecken Sie Enter fuer Standard-Pfade oder geben Sie eigene Pfade ein:
set /p INPUT_DIR="Eingabe-Ordner (Enter=Standard): "
set /p OUTPUT_DIR="Ausgabe-Ordner (Enter=Standard): "
set /p MIN_DATE="Minimaldatum DD.MM.YYYY (Enter=01.01.1900): "

REM Standard-Werte setzen wenn leer
if "%INPUT_DIR%"=="" set INPUT_DIR=%DEFAULT_INPUT%
if "%OUTPUT_DIR%"=="" set OUTPUT_DIR=%DEFAULT_OUTPUT%
if "%MIN_DATE%"=="" set MIN_DATE=01.01.1900

REM Worker-Anzahl optional
set /p WORKERS="Anzahl Worker-Prozesse (Enter für Standard): "

echo.
echo ==========================================
echo Starte Konvertierung...
echo ==========================================

REM Python-Skript ausführen
if "%WORKERS%"=="" (
  if "%MIN_DATE%"=="01.01.1900" (
    python "%~dp0svg2pdf.py" %INPUT_DIR% %OUTPUT_DIR% --verbose
    ) else (
    python "%~dp0svg2pdf.py" %INPUT_DIR% %OUTPUT_DIR% --min-date "%MIN_DATE%" --verbose
  )
  ) else (
  if "%MIN_DATE%"=="01.01.1900" (
    python "%~dp0svg2pdf.py" %INPUT_DIR% %OUTPUT_DIR% --workers %WORKERS% --verbose
    ) else (
    python "%~dp0svg2pdf.py" %INPUT_DIR% %OUTPUT_DIR% --workers %WORKERS% --min-date "%MIN_DATE%" --verbose
  )
)

echo.
echo ==========================================
echo Konvertierung abgeschlossen!
echo ==========================================
pause
