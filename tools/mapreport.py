"""Small script to add up resource usage from map file."""
import sys
import re
from typing import List, Tuple
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
RGX_HEX_RANGE = re.compile(r"^(?P<start>0x[0-9a-f]+),(?P<end>0x[0-9a-f])$", re.IGNORECASE)

SEGMENTS_TO_IGNORE=[".debug", ".info."]

class Resource:
    def __init__(self, desc, start_addr, end_addr):
        self._desc = desc
        self._start = start_addr
        self._end = end_addr
        self._min = end_addr
        self._max = start_addr
        self._length = 0

    def add(self, start_addr, end_addr):
        self._length += end_addr - start_addr - 1
        self._min = min(self._min, start_addr)
        self._max = max(self._max, end_addr)

    @property
    def desc(self):
        return self._desc

    @property
    def length(self):
        return self._length

    @property
    def start(self):
        return self._start

    @property
    def end(self):
        return self._end

    @property
    def max(self):
        if self.length > 0:
            return self._max
        else:
            return self._end

    @property
    def min(self):
        if self.length > 0:
            return self._min
        else:
            return self._start

    @property
    def waste(self):
        if self.length > 0:
            return self.max - self.min - self.length
        else:
            return 0

resources: List[Resource] = []


def analyze(args: argparse.Namespace) -> None:
    """Analyze the mapfile."""
    global resources
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

    for key, segValue in segmap.items():
        if key in SEGMENTS_TO_IGNORE:
            continue

        if segValue[LENGTH] == 0:
            continue

        for resource in resources:
            if segValue[START] >= resource.start:
                resource.add(segValue[START], segValue[END])
                break

    resources.reverse()
    print("Resource:   start     end      length  waste remains")
    for resource in resources:
        print("%-10s: %8.8X, %8.8X, %5d, %5d %5d" % (resource.desc, resource.min, resource.max, resource.length, (resource.max - resource.min - resource.length), (resource.end - resource.start - resource.length)))

def parse_args(argv: List[str]) -> argparse.Namespace:
    """Parse command  line arguments"""
    def hexrange(arg: str) -> Tuple[int, int]:
        """Validate and parse a headecimal string"""
        try:
            match = RGX_HEX_RANGE.match(arg)
            assert match
            return hex(match.group("start")), hex(match.group("end"))
        except:
            argparse.ArgumentTypeError("Expected a hexadecimal range e.g. '0x1234,0x5678'")

    parser = argparse.ArgumentParser("Create COSMIC linker mapfile report")
    parser.add_argument("-t", "--tiny-ram", help="Starting address of RAM", type=hexrange, default=(0,0x0100))
    parser.add_argument("-n", "--near-ram", help="Starting address of RAM", type=hexrange, default=(0x0100,0x0400))
    parser.add_argument("-e", "--eeprom", help="Starting address of EEPROM", type=hexrange, default=(0x4000,0x407f))
    parser.add_argument("-o", "--rom", help="Starting address of ROM", type=hexrange, default=(0x8000,0x9FFF))
    parser.add_argument("mapfile", help="COSMIC linker mapfile.")
    args: argparse.Namespace = parser.parse_args(argv)
    if ((args.rom < args.eeprom) or (args.eeprom < args.near_ram) or (args.near_ram < args.tiny_ram)):
        argparse.ArgumentError("Expected RAM, EEPROM, ROM spaces in that order")

    tiny_ram = Resource("RAM (tiny)", args.tiny_ram[0], args.tiny_ram[1])
    near_ram = Resource("RAM (near)", args.near_ram[0], args.near_ram[1])
    eeprom = Resource("EEPROM", args.eeprom[0], args.eeprom[1])
    rom = Resource("ROM", args.rom[0], args.rom[1])
    resources.append(rom)
    resources.append(eeprom)
    resources.append(near_ram)
    resources.append(tiny_ram)

    return args


def main(argv: List[str]):
    """Mainline"""
    args: argparse.Namespace = parse_args(argv)
    analyze(args)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))