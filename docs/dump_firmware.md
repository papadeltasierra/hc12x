# Firmware Download
## References
- [HC-12 tools by rumpeltux][rumpeltux/hc12]
- [PM0044; Programming manuual; STM8 CPU programming manual][PM0044]


## Dump Code (hex)
From `hc12/firmwaredump.py`

```
25 00 8b a0 93 d4 81 ae 42 00 a6 08 c7 b2 35
90 5f 90 bf f4 7e 0f 52 30 fb f6 78 52 31 5c
26 ef 84 84 17 01 be
```

This consists of:
- A 1-byte length
- A 1-byte 0x00
- A 2-byte address
- Opcodes to write
- A CRC that ensures that `mod(sum(all), 256) == 0`

From _rumpletux's_ notes, the address 8ba0 falls in the section of code that performs the _printVersion_ function.

```
25              Length = 37 = 1 + 1 + 2 + 32 + 1
00
8b a0           Address = 8ba0
93 d4 81 ae 42 00 a6 08 c7 b2 35 90 5f 90 bf f4
7e 0f 52 30 fb f6 78 52 31 5c 26 ef 84 84 17 01
be              CRC
```

|Register|Purpose|
|-|-|
|A|Accumulator|
|X, Y|Index registers|
|PC|Program counter|
|SP|Stack pointer|
|CFG_GCR| Global configuration register|
|CC|Condition register|

So decoding the opcodes written...

```
8ba0:   93          LDW X, Y                Load, make X = Y
8ba1:   d4 81 ae    AND A, (81ae, X)        Logical AND: A = A & (81ae + X)
8ba4:   42          MUL X, A                Multiply XL by A and store in X
8ba5:   00 a6       NEG (a6, SP)            Negate value at SP+a6
8ba7:   08 c7       SLL (c7, SP)            Shift left logical value at SP+c7
# Interesting that we are walking back 53 and the "buffer" is 52?
8ba9:   b2 35       SBC A, 35               Subtraction with carry/borrow (53)
8bab:   90 5f       CLRW Y                  Zero Y
8bad:   90 bf f4    LDW f4, Y
8bb0:   7e          SWAP X                  Swap high and low bytes of X
# Suspect SP+52 is an output buffer.
8bb1:   0f 52       CLR (52, SP)            Clear address SP+52 to zeros
8bb3:   30 fb       NEG fb                  Negate the value at fb
8bb5:   f6          LD A, (X)               load A from the value at address X
8bb6:   78          SLL X                   Shift logical left (x 2)
8bb8:   52 31       SUB SP, 31              0x31 = 49 = 16 x 3 + 1
8bb9:   5c          INCW X                  X = X + 1
8bba:   26 ef       JRNE ef                 Jump if INCW X didn't return zero
8bbc:   84          POP A
8bbd:   84          POP A
8bbe:   17 01       LDW (01, SP), Y         Load, make (SP+1) = Y
```

> This seems to assume code around it which we cannot do if we have a clone HC-12 and not an original so this code is probably useless to us.

[rumpeltux/hc12]: https://github.com/rumpeltux/hc12
[PM0044]: https://www.st.com/resource/en/programming_manual/pm0044-stm8-cpu-programming-manual-stmicroelectronics.pdf