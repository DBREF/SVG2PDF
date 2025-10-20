# SVG zu PDF Konverter

Ein eigenständiges Windows-Tool zur parallelen Konvertierung von SVG-Dateien zu PDF-Dateien.

## Features

✅ **Multiprocessing**: Nutzt alle CPU-Kerne für maximale Geschwindigkeit  
✅ **Ordnerstruktur**: Erhält die ursprüngliche Verzeichnisstruktur  
✅ **InfraQGIS-Kompatibel**: Verwendet identische Einstellungen wie export.py  
✅ **Robuste Fehlerbehandlung**: Einzelne Fehler brechen nicht den ganzen Prozess ab  
✅ **Fortschrittsanzeige**: Zeigt Geschwindigkeit und Status in Echtzeit  
✅ **Windows-optimiert**: Native Windows-Pfad-Behandlung  

## Voraussetzungen

- Python 3.6+
- Erforderliche Pakete:
  ```bash
  pip install svglib reportlab
  ```

## Verwendung

### Kommandozeile (Empfohlen)

```bash
# Standard-Pfade verwenden (einfachste Verwendung)
python svg2pdf.py

# Mit 8 parallelen Prozessen
python svg2pdf.py --workers 8 --verbose

# Nur Dateien ab bestimmtem Datum
python svg2pdf.py --min-date "01.01.2024"

# Eigene Pfade angeben
python svg2pdf.py "C:\Profile\SVG" "C:\Profile\PDF"

# Kombiniert: Eigene Pfade + Datum + Performance
python svg2pdf.py "C:\Profile\SVG" "C:\Profile\PDF" --min-date "15.09.2025" --workers 8 --verbose

# Dry-Run (nur anzeigen, was passieren würde)
python svg2pdf.py --dry-run
```

### Standard-Pfade
- **Eingabe**: `C:\Users\FabianSchoepflin\Downloads\Lichtraum\Profile\SVG`
- **Ausgabe**: `C:\Users\FabianSchoepflin\Downloads\Lichtraum\Profile\PDF`

### Windows Batch-Datei (Einfach)

Doppelklick auf `svg2pdf_run.bat` und den Anweisungen folgen.

## Parameter

| Parameter | Beschreibung | Standard |
|-----------|--------------|----------|
| `input_dir` | Eingabeverzeichnis mit SVG-Dateien | Standard-Pfad |
| `output_dir` | Ausgabeverzeichnis für PDF-Dateien | Standard-Pfad |
| `--min-date` | Minimales Erstellungsdatum (DD.MM.YYYY) | 01.01.1900 |
| `--workers` | Anzahl paralleler Prozesse | 12 |
| `--verbose` | Detaillierte Ausgabe | Aus |
| `--dry-run` | Nur Simulation, keine Konvertierung | Aus |

## Beispiele

### Typische Verwendung (Standard-Pfade)
```bash
python svg2pdf.py
```

### Nur neue Dateien (ab heute)
```bash
python svg2pdf.py --min-date "30.09.2025"
```

### Standard Performance (12 Worker)
```bash
python svg2pdf.py --verbose
```

### Angepasste Performance
```bash
python svg2pdf.py --workers 8   # Weniger Worker für schwache Systeme
python svg2pdf.py --workers 16  # Mehr Worker für starke Systeme
```

### Eigene Pfade mit Datumsfilter
```bash
python svg2pdf.py "D:\LIRA\Profile" "D:\LIRA\Profile-PDF" --min-date "01.01.2024"
```

## Ordnerstruktur

✅ **Das Tool erhält die ursprüngliche Verzeichnisstruktur 1:1:**

**Eingabe-Beispiel (beliebige Struktur):**
```
SVG/
├── datei1.svg                    ← Direkt im Hauptordner
├── datei2.svg
├── ordnerA/
│   ├── unterA1.svg
│   └── unterordner/
│       └── tief_verschachtelt.svg
├── ordnerB/
│   └── einzeldatei.svg
├── zufaelliger_ordner/
│   ├── abc.svg
│   ├── xyz.svg
│   └── noch_ein_ordner/
│       ├── test1.svg
│       └── test2.svg
└── leerer_ordner/               ← Wird ignoriert (keine SVGs)
```

**Ausgabe-Ergebnis (exakt gleiche Struktur):**
```
PDF/
├── datei1.pdf                    ← Gleiche Position
├── datei2.pdf
├── ordnerA/
│   ├── unterA1.pdf
│   └── unterordner/
│       └── tief_verschachtelt.pdf
├── ordnerB/
│   └── einzeldatei.pdf
├── zufaelliger_ordner/
│   ├── abc.pdf
│   ├── xyz.pdf
│   └── noch_ein_ordner/
│       ├── test1.pdf
│       └── test2.pdf
└── (leerer_ordner wird nicht erstellt)
```

📝 **Funktionsweise:**
- **Keine Logik**: Tool macht keine Annahmen über Ordnerstruktur
- **Rekursive Suche**: Findet SVGs in beliebig tiefen Verschachtelungen
- **1:1 Kopie**: Jeder relative Pfad wird exakt übernommen
- **Flexible Struktur**: Dateien im Hauptordner, Unterordnern, oder gemischt
- **Nur SVGs**: Andere Dateien werden ignoriert
- **Automatische Ordner**: Zielordner werden bei Bedarf erstellt

## Performance

- **Single-Core**: ~2-5 PDF/s (je nach SVG-Komplexität)
- **12 Worker (Standard)**: ~20-50 PDF/s (optimaler Durchsatz)
- **Speicherverbrauch**: ~50-100 MB pro Worker-Prozess (~600 MB-1.2 GB total)
- **Empfehlung**: 12 Worker sind für die meisten Systeme optimal

## PDF-Einstellungen

Das Tool verwendet identische Einstellungen wie InfraQGIS export.py:

- **Seitengröße**: A4 (210 × 297 mm)
- **Rand**: 10 mm auf allen Seiten
- **Skalierung**: Automatisch, um SVG optimal zu positionieren
- **Zentrierung**: Horizontal und vertikal zentriert

## Fehlerbehebung

### "Bibliotheken nicht gefunden"
```bash
pip install svglib reportlab
```

### "Permission denied"
- Prüfen Sie Schreibrechte im Ausgabeverzeichnis
- Schließen Sie PDF-Dateien, die möglicherweise geöffnet sind

### Langsame Performance
- Erhöhen Sie `--workers` (max. 2x CPU-Kerne)
- Prüfen Sie Festplatten-I/O (SSD vs. HDD)
- Verwenden Sie lokale Pfade (nicht Netzwerk)

### Speicher-Probleme
- Reduzieren Sie `--workers`
- Schließen Sie andere Anwendungen

## Technische Details

- **Multiprocessing**: `concurrent.futures.ProcessPoolExecutor`
- **PDF-Engine**: ReportLab Canvas
- **SVG-Parser**: svglib
- **Pfad-Handling**: `pathlib` für plattformübergreifende Kompatibilität
- **Memory Management**: Automatische Garbage Collection

## Integration in InfraQGIS

Dieses Tool kann als Fallback oder Alternative zum eingebauten PDF-Export verwendet werden. Die PDF-Einstellungen sind identisch, sodass die Ergebnisse konsistent sind.

## Version

**1.0.0** - Erste Veröffentlichung
- Multiprocessing-Support
- Windows-Optimierungen
- Vollständige Ordnerstruktur-Erhaltung