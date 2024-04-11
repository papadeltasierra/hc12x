"""S19, Motorola S-record, routines."""
from __future__ import annotations
import sys
from enum import Enum
from typing import List
import struct
import logging

log = logging.getLogger()


# class syntax
class SRecType:
    INVALID = ""
    HEADER = "0"
    DATA16 = "1"
    DATA24 = "2"
    DATA32 = "3"
    RESERVED4 = "4"
    COUNT16 = "5"
    COUNT24 = "6"
    START32 = "7"
    START24 = "8"
    START16 = "9"

    @classmethod
    def IsValid(cls: SRecType, type: str) -> bool:
        return type in [cls.HEADER, cls.DATA16, cls.DATA24, cls.DATA32, cls.COUNT16, cls.COUNT24, cls.START32, cls.START24, cls.START16]

    @classmethod
    def addressLength(cls: SRecType, type: str) -> int:
        _addressLength = {
            cls.HEADER: 16,
            cls.DATA16: 16,
            cls.DATA24: 24,
            cls.DATA32: 32,
            cls.COUNT16: 16,
            cls.COUNT24: 24,
            cls.START32: 32,
            cls.START24: 24,
            cls.START16: 16,
        }
        return _addressLength[type]


class SRec:
    def __init__(self: SRec):
        self._type: SRecType = SRecType.INVALID
        self._byteCount: int = -1
        self._address: str = None
        self._data: str = None

    @property
    def type(self: SRec):
        return self._type

    @type.setter
    def type(self: SRec, type: str):
        assert SRecType.IsValid(type), "Record type '%s' is not one of the valid types" % type
        self._type = type

    @property
    def byteCount(self: SRec):
        return self._byteCount

    @byteCount.setter
    def byteCount(self: SRec, byteCount: str):
        log.debug("byteCount: str: %s", byteCount)
        self._byteCount = int(byteCount, 16)
        assert self._byteCount >= 3 and self._byteCount <= 255, "Byte count '%d' is outside valid range of '3-255'" % self._byteCount

    @property
    def address(self: SRec):
        return self._address

    @address.setter
    def address(self: SRec, address: str):
        self._address = address

    @property
    def data(self: SRec):
        return self._data

    @data.setter
    def data(self: SRec, data: str):
        self._data = data

    @property
    def crc(self: SRec):
        crcData: bytearray = struct.pack("b", self.byteCount)
        crcData += bytes.fromhex(self.address)
        crcData += bytes.fromhex(self.data)
        return 0xff - (sum(crcData) & 0xff)

    @classmethod
    def readFile(cls, filename: str) -> List[SRec]:
        """Read an S-Record file and parse into a list of records."""
        records: List[SRec] = []
        start: str
        type: int
        byteCount: int
        address: int

        with open(filename, "r") as s19file:
            line = s19file.readline()
            while line:
                record: SRec = SRec()
                print(vars(record))
                line = line.strip()
                assert len(line) >= 10, "SRecord '%s' is too short." % line

                start = line[0]
                type = line[1]
                byteCount = line[2:4]
                assert start == "S", "SRecord started with '%d' instead of an 'S'." % start

                record.type = type
                record.byteCount = byteCount

                # Expected length field depends on the record type, and allow
                # for hex string representation.
                addressLength: int = int(SRecType.addressLength(type) / 4)
                log.debug("addresslength (hex-bytes): %d", addressLength)

                address = line[4:4 + addressLength]
                record.address = address

                # Store the data.
                record.data = line[4 + addressLength: -2]

                # Now validate the checksum which is calculated over byte count,
                # address and data fields.
                crcInput: str = int(line[-2:], 16)
                assert record.crc == crcInput, "CRC of '%2.2x' was not the expected value of '%s'." % (record.crc, crcInput)


                records.append(record)

                # Next line.
                line = s19file.readline()

        log.info("%d records read", len(records))
        return records

