# Watermelon Badge CadQuery Project

This project creates a fully parametric, multicolor-ready watermelon badge for FDM printing. The model is designed as a single printable object with distinct rind, white ring, and flesh regions that can be assigned different filament colors.

## Features
- Parametric badge diameter, thickness, and dome height
- Three color regions: green rind, white inner ring, and red flesh
- Mathematically generated seed rings
- Printable keyhole-style pin channel with reinforcement
- Optional magnet pockets and optional back text
- STEP, STL, and 3MF export workflow

## Installation

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

## Generate the model

```bash
python build.py
```

## Export

```bash
python export.py
```

## Change the size

Use the example scripts:

```bash
python examples/badge_40mm.py
python examples/badge_50mm.py
python examples/badge_60mm.py
```

## Parameters

Edit [parameters.py](parameters.py) to change dimensions, pin options, text, and magnet mode.
