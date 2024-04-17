"""Validate and report on a S19/Motorola format record file."""
import sys
from typing import List
from s19 import SRec, SRecType


def main(argv: List[str]) -> int:
    """Main function"""
    records: List[SRec] = SRec.readFile(argv[0])

    minAddress: int = 0xffffffff
    maxAddress: int = 0
    startAddress: int = 0

    recordsCount = {}

    for record in records:
        if record.type not in recordsCount:
            recordsCount[record.type] = 0
        recordsCount[record.type] = recordsCount[record.type] + 1

        if record.type == SRecType.DATA16:
            address = int(record.address, 16)
            minAddress = min(minAddress, address)
            maxAddress = max(maxAddress, address)

        elif record.type == SRecType.START16:
            startAddress = int(record.address, 16)

    print("Stats...")
    print(recordsCount)
    print("%4.4X" % minAddress)
    print("%4.4X" % maxAddress)
    print("%4.4X" % startAddress)

    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))