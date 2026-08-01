# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projekt

Eigenständiges CLI-Tool zur Stapelkonvertierung von SVG- zu PDF-Dateien (svglib → ReportLab) mit Multiprocessing. Windows-fokussiert, Ausgaben und Docstrings auf Deutsch. Der gesamte Code liegt in [svg2pdf.py](svg2pdf.py) — kein Package, keine Tests, kein Build-Schritt.

## Befehle

```powershell
# Umgebung (venv vorhanden, Python 3.14)
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt

# Ausführen
python svg2pdf.py                                      # hardcodierte Defaults C:\Profile\SVG → C:\Profile\PDF
python svg2pdf.py "<in>" "<out>" --workers 8 --verbose
python svg2pdf.py "<in>" "<out>" --dry-run             # Vorschau ohne Konvertierung
python svg2pdf.py "<in>" "<out>" --min-date "01.01.2024"

# Lint/Format — Ruff ist NICHT installiert (weder im .venv noch im PATH).
# Format-on-Save läuft nur über die VS-Code-Extension charliermarsh.ruff
# (siehe .vscode/settings.json), die ihre eigene Binary mitbringt.
pip install ruff   # einmalig nötig, bevor die CLI nutzbar ist
ruff check .
ruff format .

# Smoke-Test (keine Testsuite vorhanden) — prüft Konvertierung + Strukturerhalt
mkdir -Force tmp\in\unter\tief, tmp\out
'<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50"><rect width="100" height="50" fill="#36c"/></svg>' | Set-Content tmp\in\unter\tief\test.svg
.\.venv\Scripts\python.exe svg2pdf.py tmp\in tmp\out --workers 2 --verbose
# erwartet: tmp\out\unter\tief\test.pdf
```

Es gibt kein `ruff.toml`/`pyproject.toml` — Ruff läuft mit Defaults.

## Architektur

Ablauf in [svg2pdf.py](svg2pdf.py): `main()` → `find_svg_files()` (rglob + optionaler Datumsfilter) → `ProcessPoolExecutor` über `process_svg_file()` → `create_output_path()` + `convert_single_svg_to_pdf()`.

**Import-Guard und Modulkonstanten.** `reportlab`/`svglib` werden in einem `try/except ImportError` importiert, das gleichzeitig `LIBRARIES_AVAILABLE`, `MARGIN_MM` und `PAGE_SIZE` setzt ([svg2pdf.py:33-52](svg2pdf.py#L33-L52)). Neue Layout-Konstanten gehören in **beide** Zweige, sonst gibt es `NameError` im Fallback-Pfad. `convert_single_svg_to_pdf()` prüft das Flag erneut, weil bei `spawn` jeder Worker-Prozess das Modul neu importiert und den Fehler unabhängig vom Elternprozess trifft.

**Multiprocessing-Randbedingungen (Windows/spawn).** `process_svg_file()` muss auf Modulebene bleiben und ein einzelnes picklebares Tupel entgegennehmen. `mp.freeze_support()` steht im `__main__`-Block. Worker geben `(success, filename, error)` zurück statt Exceptions zu werfen — Fehler einzelner Dateien dürfen den Pool nie abbrechen. Nach jeder Konvertierung wird explizit `gc.collect()` gerufen (ReportLab-Canvas-Speicher bei großen Batches).

**1:1-Strukturübertragung.** `find_svg_files()` macht bewusst *keine* Annahmen über Ordnernamen oder -tiefe; der relative Pfad wird unverändert übernommen und nur die Endung getauscht. Diese Eigenschaft ist im Docstring explizit festgehalten — keine Sonderbehandlung für bestimmte Ordner einbauen.

**Datumsfilter.** Der Default `"01.01.1900"` ist ein Sentinel, der per **String-Vergleich** geprüft wird ([svg2pdf.py:275](svg2pdf.py#L275)) — explizit `--min-date "01.01.1900"` anzugeben deaktiviert den Filter, statt ihn zu setzen. Gefiltert wird über `st_birthtime` (auf Windows erst ab Python 3.12 verfügbar); schlägt der Zugriff fehl, wird die Datei **eingeschlossen**, nicht übersprungen.

**Exit-Codes.** `sys.exit(1)` bei fehlenden Bibliotheken, ungültigem Eingabepfad, ungültigem Datumsformat, null gefundenen SVGs, Abbruch per Ctrl+C und bei mindestens einer fehlgeschlagenen Konvertierung. Der Batch-Wrapper wertet das nicht aus.

## Gotchas

**Namenskollision `svg2pdf`.** `svglib` installiert ein gleichnamiges Console-Script (`.venv/Scripts/svg2pdf.exe` → `svglib:main`). Im aktivierten venv startet `svg2pdf` deshalb svglibs Tool, nicht dieses Projekt. Immer `python svg2pdf.py` aufrufen.

**`svg2pdf_run.bat` nutzt `python` aus dem PATH**, nicht das `.venv`. Sind dort `reportlab`/`svglib` nicht installiert, bricht der Wrapper mit „Erforderliche Bibliotheken nicht gefunden" ab — aktuell auf dieser Maschine der Fall. Zum Testen stattdessen `.\.venv\Scripts\python.exe svg2pdf.py ...` verwenden.

## Konventionen

- Benutzerausgaben auf Deutsch mit Emoji-Präfix (✅ ❌ 📊 🗓️ 🚀); Fortschritt alle 10 Dateien.
- Docstrings und Kommentare auf Deutsch, Google-Style-Args/Returns.
- **Bezeichner auf Englisch.** Neue Variablen, Funktionen, Methoden, Klassen und Konstanten werden englisch benannt — Ausnahme: fachliche deutsche Begriffe oder Eigenbegriffe (z. B. Domänen- oder Produktnamen), die bleiben deutsch. Bestehende deutsche Bezeichner **nicht** nebenbei umbenennen; eine Umstellung erfolgt ggf. separat und geplant.
- Type Hints im modernen Stil (`tuple[bool, str, str | None]`).
- `create_output_path()` hat einen bewusst ungenutzten `input_dir`-Parameter (API-Konsistenz, im Docstring vermerkt) — nicht "aufräumen".
