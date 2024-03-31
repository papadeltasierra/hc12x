"""Small script to add up resource usage from map file."""
import sys
import re

SEGMENTS = r"segments"
RGX_SEGMENTS = re.compile(
    r".*?Segments.*?\-+(?P<" + SEGMENTS + r">.*?)\-+.*?Modules.*",
    re.DOTALL | re.MULTILINE)
START = r"start"
END = r"end"
LENGTH = r"length"
NAME = r"NAME"
RGX_SEGDATA = re.compile(
    r"start\s+(?P<" + START + r">[0-9a-f]{8})\s+end\s+(?P<" + END + r">[0-9a-f]{8})\s+length\s+(?P<" +
    LENGTH +
    r">\d+)\s+segment\s+(?P<" + NAME + r">.+)",
    re.IGNORECASE)
with open(sys.argv[1], "r") as mapfile:
    mapdata = mapfile.read()

ROM_SEGMENTS = [".text", ".const", ".bsct", ".init"]
RAM_SEGMENTS = [".ubsct", ".bit", ".data", ".bsct", ".bss", ".share"]
EEPROM_SEGMENTS = [".eeprom"]
HOST_SEGMENTS = [".debug", ".info."]

match = RGX_SEGMENTS.search(mapdata)
assert match, "Unexpected mapfile format"
segments = match.group(SEGMENTS)
segments = segments.strip()
segarray = segments.split("\n")
segmap = {}
for segment in segarray:
    match = RGX_SEGDATA.match(segment)
    assert match, "Unexpected segment data format: %s" % segment
    segmap[match.group(NAME)] = {
        START: int(match.group(START), 16),
        END: int(match.group(END), 16),
        LENGTH: int(match.group(LENGTH))
    }

# Add up the reosurces, ignoring resources that are not present.
rom = 0
romMax = 0
romMin = 0xFFFFFFFF
ram = 0
ramMax = 0
ramMin = 0xFFFFFFFF
eeprom = 0
eepromMax = 0
eepromMin = 0xFFFFFFFF

for key, segValue in segmap.items():
    if key.endswith("initialized"):
        ram += segValue[LENGTH]
        ramMin = min(ramMin, segValue[START])
        ramMax = max(ramMax, segValue[END])
    elif key.endswith("from"):
        rom += segValue[LENGTH]
        romMin = min(romMin, segValue[START])
        romMax = max(romMax, segValue[END])
    elif key in ROM_SEGMENTS:
        rom += segValue[LENGTH]
        romMin = min(romMin, segValue[START])
        romMax = max(romMax, segValue[END])
    elif key in RAM_SEGMENTS:
        ram += segValue[LENGTH]
        ramMin = min(ramMin, segValue[START])
        ramMax = max(ramMax, segValue[END])
    elif key in EEPROM_SEGMENTS:
        eeprom += segValue[LENGTH]
        eepromMin = min(eepromMin, segValue[START])
        eepromMax = max(eepromMax, segValue[END])
    elif key not in HOST_SEGMENTS:
        print("Unexpected segment: %s: %s" % (key, segValue[LENGTH]))

print("Resource: start     end      length  waste")
print("ROM:      %8.8X, %8.8X, %5d, %5d" % (romMin, romMax, rom, (romMax - romMin - rom)))
print("RAM:      %8.8X, %8.8X, %5d, %5d" % (ramMin, ramMax, ram, (ramMax - ramMin - ram)))
print("EEPROM:   %8.8X, %8.8X, %5d, %5d" % (eepromMin, eepromMax, eeprom, (eepromMax - eepromMin - eeprom)))
