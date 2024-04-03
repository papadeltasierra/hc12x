"""Small script to add up resource usage from map file."""
import sys
import re
from typing import List
import argparse

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

SEGMENTS_TO_IGNORE=[".debug", ".info."]


def analyze(args: argparse.Namespace) -> None:
    """Analyze the mapfile."""
    with open(args.mapfile, "r") as mapfile:
        mapdata = mapfile.read()

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

    # Add up the resources, ignoring resources that are not present.
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
        if key in SEGMENTS_TO_IGNORE:
            continue

        if segValue[LENGTH] == 0:
            continue

        if segValue[START] >= args.rom:
            rom += segValue[LENGTH]
            romMin = min(romMin, segValue[START])
            romMax = max(romMax, segValue[END])
        elif segValue[START] >= args.eeprom:
            eeprom += segValue[LENGTH]
            eepromMin = min(eepromMin, segValue[START])
            eepromMax = max(eepromMax, segValue[END])
        else:
            ram += segValue[LENGTH]
            ramMin = min(ramMin, segValue[START])
            ramMax = max(ramMax, segValue[END])

    if ram == 0:
        ramMin = args.ram
        ramMax = args.ram
    if eeprom == 0:
        eepromMin = args.eeprom
        eepromMax = args.eeprom
    if rom == 0:
        romMin = args.rom
        romMax = args.rom

    print("Resource: start     end      length  waste")
    print("RAM:      %8.8X, %8.8X, %5d, %5d" % (ramMin, ramMax, ram, (ramMax - ramMin - ram)))
    print("EEPROM:   %8.8X, %8.8X, %5d, %5d" % (eepromMin, eepromMax, eeprom, (eepromMax - eepromMin - eeprom)))
    print("ROM:      %8.8X, %8.8X, %5d, %5d" % (romMin, romMax, rom, (romMax - romMin - rom)))

def parse_args(argv: List[str]) -> argparse.Namespace:
    """Parse command  line arguments"""
    def hexint(arg: str) -> int:
        """Validate and parse a headecimal string"""
        try:
            return hex(arg)
        except:
            argparse.ArgumentTypeError("Expected a hexadecimal value")

    parser = argparse.ArgumentParser("Create COSMIC linker mapfile report")
    parser.add_argument("-a", "--ram", help="Starting address of RAM", type=hexint, default=0)
    parser.add_argument("-e", "--eeprom", help="Starting address of EEPROM", type=hexint, default=0x4000)
    parser.add_argument("-o", "--rom", help="Starting address of ROM", type=hexint, default=0x8000)
    parser.add_argument("mapfile", help="COSMIC linker mapfile.")
    args: argparse.Namespace = parser.parse_args(argv)
    if ((args.rom < args.eeprom) or (args.eeprom < args.ram)):
        argparse.ArgumentError("Expected RAM, EEPROM, ROM spaces in that order")

    return args


def main(argv: List[str]):
    """Mainline"""
    args: argparse.Namespace = parse_args(argv)
    analyze(args)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))