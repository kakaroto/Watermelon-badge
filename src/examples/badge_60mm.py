from pathlib import Path
import sys

sys.path.append(str(Path(__file__).resolve().parents[1]))

from build import main
from parameters import BadgeParameters


if __name__ == "__main__":
    params = BadgeParameters(badge_diameter=60.0)
    main(params)
