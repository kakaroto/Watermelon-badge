import sys
sys.path.append('.')

from parameters import BadgeParameters
from geometry.dome import build_dome
from geometry.rind import build_rind
from geometry.flesh import build_flesh
from geometry.seeds import build_seeds
from geometry.pin_channel import build_pin_channel
from geometry.reinforcement import build_reinforcement
from geometry.badge import build_badge

params = BadgeParameters()
print('building dome')
dome = build_dome(params)
print('dome ok')
print('building rind')
rind = build_rind(params)
print('rind ok')
print('building flesh')
flesh = build_flesh(params)
print('flesh ok')
print('building seeds')
seeds = build_seeds(params)
print('seeds ok')
print('building pin')
pin = build_pin_channel(params)
print('pin ok')
print('building reinforcement')
rein = build_reinforcement(params)
print('rein ok')
print('building badge')
badge = build_badge(params)
print('badge ok')
