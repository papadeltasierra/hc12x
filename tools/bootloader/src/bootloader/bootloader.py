"""Library for bootloader updates."""
from __future__ import annotations
import serial
from typing import Tuple, List, Dict

class BootLoaderOptions:
    def __init__(self: BootLoaderOptions, options: bytes) -> None:
        self._version = options[0]
        self._commands = options[1:]

    def __str__(self: BootLoaderOptions) -> Tuple[str, List[str]]:
        version: str = str(self._version)
        commands: List[str]

        COMMAND_NAMES : Dict[int] = {
            0x01: "Options"
        }

        for command in self._commands:
            if command in COMMAND_NAMES:
                commands.append(COMMAND_NAMES[command])
            else:
                commands.append("%2.2X (unrecognised)" % command)

        return(version, commands)


class Bootloader:
    def __init__(self: Bootloader, sectorSize: int=128) -> None:
        self._sectorSize = sectorSize
        self._serial = None

    # Internal methods.
    def _sendOptions(self: Bootloader) -> None:
        self._serial.write(b"\x01")

    def _sendEraseCount(self: Bootloader, count: int) -> None:
        cmd: bytes = b"\x02" + count.to_bytes(1, byteorder="big")
        self.serial.write(cmd)

    def _sendEraseAddress(self: Bootloader, address: int) -> None:
        cmd: bytes = b"\x02" + address.to_bytes(4, byteorder="big")
        self.serial.write(cmd)

    def _sendWriteCount(self: Bootloader, count: int) -> None:
        cmd: bytes = b"\x02" + count.to_bytes(1, byteorder="big")
        self.serial.write(cmd)

    def _sendWriteAddress(self: Bootloader, address: int) -> None:
        cmd: bytes = b"\x02" + address.to_bytes(4, byteorder="big")
        self.serial.write(cmd)

    def _sendWriteBytes(self: Bootloader, data: bytes) -> None:
        self.serial.write(data)

    def _ackOrNack(self: Bootloader) -> None:
        ACK: bytes = 0x06
        NACK: bytes = 0x1f
        rsp: bytes = self._serial.read(1)
        if rsp != NACK:
            raise Exception("NACK received")

    # Public methods.
    def connect(self: Bootloader, port: str) -> None:
        self._serial = serial.Serial(
            port: port,
            baudrate=19200,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_EVEN,
            stopbits=serial.STOPBITS_ONE,
            timeout=1
        )

    def disconnect(self: Bootloader) -> None:
        self._serial.close()
        self._serial = None

    def options(self: Bootloader) -> BootLoaderOptions:
        """Read options from the target device's bootloader."""
        self._sendOptions()
        self._ackOrNack()
        options: bytes = self._readOptions()
        return BootLoaderOptions(options)

    def read(self: Bootloader, address: int, count: int) -> bytes:
        """Read data from the target device's memory (EEPROM or Flash)."""
        self._sendReadCount(count)
        self._ackOrNack()
        self._sendReadAddress(address)
        self._ackOrNack()
        return  self._receiveBytes(count)

    def erase(self: Bootloader, address: int, count: int) -> None:
        """Erase data from the target device's memory (EEPROM or Flash)."""
        self._sendEraseCount(count)
        self._ackOrNack()
        self.sendEraseAddress(address)
        self._ackOrNak()

    def write(self: Bootloader, address: int, count: int, data: bytes) -> None:
        """Write data to the target device's memory (EEPROM or Flash)."""
        self._sendWriteCount(count)
        self._ackOrNack()
        self.sendEraseAddress(address)
        self._ackOrNak()
        self._sendBytes(data)
        self._ackOrNack()
