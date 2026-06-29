# Watermelon Badge CadQuery Project

This project creates a simple enamel-style badge model suitable for multicolor 3D printing.

## Files
- badge.py: CadQuery script that generates the badge parts
- output/: generated STL and STEP files

## Run
From the project folder, run:

```powershell
./generate_badge.cmd
```

Or directly with Python:

```powershell
./.venv/Scripts/python.exe generate_badge.py
```

## Output
The script exports:
- badge_base.stl / badge_base.step
- badge_enamel.stl / badge_enamel.step

## Notes
- The badge base is the structural part.
- The enamel insert is a separate part intended for a different filament/color.
- You can adjust the dimensions in badge.py for a different size or style.
