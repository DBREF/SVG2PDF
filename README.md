# SVG2PDF

Eigenständiges Tool zur Stapelkonvertierung von SVG-Dateien in PDF-Dateien mit Multiprocessing-Unterstützung.

## Funktionen

- **Multiprocessing:** Parallele Konvertierung mehrerer SVG-Dateien für maximale Geschwindigkeit (konfigurierbare Worker-Anzahl)
- **Ordnerstruktur:** Erhaltung der ursprünglichen Verzeichnisstruktur im Ausgabeordner (1:1-Übertragung)
- **Datumsfilter:** Konvertierung nur von SVG-Dateien ab einem bestimmten Erstellungsdatum (`--min-date`)
- **Dry-Run:** Vorschau der zu konvertierenden Dateien ohne tatsächliche Konvertierung (`--dry-run`)
- **Verbose-Ausgabe:** Detaillierte Fortschritts- und Statusmeldungen (`--verbose`)
- **Fehlerbehandlung:** Robuste Verarbeitung fehlerhafter SVG-Dateien mit Fehlerprotokollierung
- **Windows-Batch:** Interaktive Ausführung über `svg2pdf_run.bat` ohne Kommandozeilenkenntnisse
- **PDF-Layout:** Automatische Skalierung auf A4 mit konfigurierbarem Rand

## Voraussetzungen

- Python 3.x
- Python-Pakete:
  - `svglib`, `reportlab`

```bash
pip install svglib reportlab
```

## Verwendung

### Über das Batch-Skript (empfohlen für Windows)

```bat
svg2pdf_run.bat
```

Das Skript fragt interaktiv nach Eingabe-/Ausgabeordner, Minimaldatum und Worker-Anzahl.

### Über die Kommandozeile

```bash
# Standard-Pfade verwenden
python svg2pdf.py

# Eigene Pfade angeben
python svg2pdf.py "C:\Profile\SVG" "C:\Profile\PDF"

# Mit Datumsfilter und Worker-Anzahl
python svg2pdf.py "C:\Profile\SVG" "C:\Profile\PDF" --min-date "01.01.2024" --workers 8 --verbose

# Vorschau ohne Konvertierung
python svg2pdf.py "C:\Profile\SVG" "C:\Profile\PDF" --dry-run
```

### Parameter

| Parameter | Kurz | Standard | Beschreibung |
|-----------|------|----------|--------------|
| `input_dir` | – | *(hardcoded)* | Eingabeverzeichnis mit SVG-Dateien (rekursiv) |
| `output_dir` | – | *(hardcoded)* | Ausgabeverzeichnis für PDF-Dateien |
| `--min-date` | – | `01.01.1900` | Minimales Erstellungsdatum (DD.MM.YYYY) |
| `--workers` | `-w` | `12` | Anzahl paralleler Worker-Prozesse |
| `--verbose` | `-v` | – | Detaillierte Ausgabe |
| `--dry-run` | – | – | Nur Vorschau, keine Konvertierung |

## Lizenz

Copyright © 2026 Fabian Schöpflin. Alle Rechte vorbehalten.  
Autor: Fabian Schöpflin  
Kontakt: Fabian.Schoepflin@infrageo.de
