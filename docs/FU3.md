# AT+DEFAULT Settings
Ref: [Board HC-12](https://github.com/TG9541/stm8ef/wiki/Board-HC12)

## 4463 Registry Settings
```
0,0x02,   0x01,        0x00,                      0x01,0xC9,0xC3,0x80
POWER_UP, EZRadio PRO, External TXCO (oscilator), Frequency, 30MHz

1,0x13,       0x60, 0x48, 0x57, 0x56, 0x5A, 0x4B
GPIO_PIN_CFG, GPIO0: 0x60: PULL_UP, TX_STATE
              GPIO1: 0x48: PULL_UP, CTS
              GPIO2: 0x57: PULL_UP, ANTENNA_SW_2
              GPIO3: 0x56, PULL_UP, ANTENNA_SW_1
              NIRQ:  0x5A, PULL_UP, SYNC_WORD_DETECT
              SDO:   0x4B, PULL_UP, SDO
              GEN_CONFIG ??????  Assume 0x00, HIGH
PDS: OK.

SET_PROPERTY...
2,0x11,0x00,0x01,0x00,0x48
GLOBAL_XO_TUNE, value = 0x48
PDS: OK

3,0x11,0x00,0x01,0x03,0x40
GLOBAL_CONFIG, Fast TX, Split_FIFO (64/64), Generic protocol (not 801.15.4g), High performance mode

4,0x11,0x01,0x01,0x00,0x00
INT_CTL_ENABLE, no chip interupts to NIRQ.

5,0x11,0x02,0x04,0x00,0x03,0x07,0x00,0x00
FFR modes: Packet handler status, INT chip status, disabled, disabled
// Can read fast registers A and B to read status.

6,0x11,0x10,0x09,0x00,0x06,0x14,0x00,0x50,0x31,0x00,0x00,0x00,0x00
PREAMBLE: 0x06: length: 6
          0x14: valid length: 20,
          0x00: non-standard: None
          0x50: (long) timeout: 5 x 15 (60bits)
          0x31: config: First "1", length = bytes, PRE_1010, no Manchester encoding
          0x00, 0x00, 0x00, 0x00: Preamble pattern - not used as using standard

7,0x11,0x11,0x05,0x00,0x21,0x89,0x89,0x00,0x00
SYNC_CONFIG: 0x21: 2 errors allowed in sync, 2 bytes sync word
             0x89, 0x89, 0x00, 0x00 - Sync words 0x8989.

8,0x11,0x12,0x01,0x00,0x81
CRC_CONFIG, CRC seed, all 1s, ITU CRC8, X8+X8+X+1

9,0x11,0x12,0x01,0x06,0x02
PKT_CONFIG_1: CRC MSB first, not inverted

10,0x11,0x12,0x03,0x08,0x00,0x00,0x00
PKG_LEN: Fixed length so no length calculation.

11,0x11,0x12,0x0C,0x0D,0x00,0x40,0x06,0xAA,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
PKT_FIELD_1_LENGTH: 0x00, 0x40: 64 packet field length?
                    0x06: load 1 and whiten field
                    0xAA: CRC full enabled
PKT_FIELD_2_LENGTH: 0x00, 0x00: field length 2 0x0000
                    0x00: F2 config
                    0x00: F2 CRC.
PKT_FIELD_3_LENGTH: 0x00, 0x00: field length 2 0x0000
                    0x00: F2 config
                    0x00: F2 CRC.

12,0x11,0x12,0x08,0x19,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
PKT_FIELD_4_LENGTH: 0x00....
PKT_FIELD_5_LENGTH: 0x00....

13,0x11,0x20,0x0C,0x00,0x03,0x00,0x07,0x26,0x25,0xA0,0x01,0xC9,0xC3,0x80,0x00,0x22
MODEM_MOD_TYPE:     0x03: 2GFSK,
MODEM_MAP_CONTOL:   0x00: Alll disabled
MODEM_DSM_CTRL:     0x07: Delta signal modulator


14,0x11,0x20,0x01,0x0C,0x22
15,0x11,0x20,0x08,0x18,0x01,0x00,0x08,0x03,0x80,0x00,0x00,0x30
16,0x11,0x20,0x09,0x22,0x00,0x78,0x04,0x44,0x44,0x04,0x44,0x02,0x00
17,0x11,0x20,0x07,0x2C,0x00,0x23,0x8F,0xFF,0x00,0xDE,0xA0
18,0x11,0x20,0x01,0x35,0xE2
19,0x11,0x20,0x09,0x38,0x22,0x0D,0x0D,0x00,0x1A,0x40,0x00,0x00,0x28
20,0x11,0x20,0x0B,0x42,0xA4,0x03,0xD6,0x03,0x01,0x0A,0x01,0x80,0xFF,0x0C,0x00
21,0x11,0x20,0x01,0x4E,0x40
22,0x11,0x20,0x01,0x51,0x0A
MODEM_CLKGEN_BAND:      SYS_SEL = 1, div-by-2
                        BAND = 2, div-by-8

Channel filters
23,0x11,0x21,0x0C,0x00,0x5B,0x47,0x0F,0xC0,0x6D,0x25,0xF4,0xDB,0xD6,0xDF,0xEC,0xF7
24,0x11,0x21,0x0C,0x0C,0xFE,0x01,0x15,0xF0,0xFF,0x03,0x5B,0x47,0x0F,0xC0,0x6D,0x25
25,0x11,0x21,0x0C,0x18,0xF4,0xDB,0xD6,0xDF,0xEC,0xF7,0xFE,0x01,0x15,0xF0,0xFF,0x03

PA mode
26,0x11,0x22,0x04,0x00,0x08,0x7F,0x00,0x5D

PLL Synthesizer
27,0x11,0x23,0x07,0x00,0x01,0x05,0x0B,0x05,0x02,0x00,0x03

Match values (address????)
28,0x11,0x30,0x0C,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
None!

Frequency
29,0x11,0x40,0x08,0x00,
0x38,
0x0D,0xDD,0xDD,
0x36,0x9D,
0x20,
0xFE

30,0x20,0x00,0x00,0x00
GET_INT_STATUS, clearing all interrupts


Wait, we are changing stuff here!!!!!!!!!!!!!!!


!!PDS: Working back up from here...

31,0x11,0x20,0x0C,0x00,0x03,0x00,0x07,0x00,0xEA,0x60,0x04,0x2D,0xC6,0xC0,0x00,0x04
32,0x11,0x20,0x01,0x0C,0x19
33,0x11,0x20,0x08,0x18,0x01,0x80,0x08,0x03,0x80,0x00,0x20,0x10
34,0x11,0x20,0x09,0x22,0x00,0xA7,0x03,0x12,0x6F,0x01,0x88,0x02,0xC2
35,0x11,0x20,0x07,0x2C,0x04,0x36,0x80,0x2C,0x07,0xE9,0x80
36,0x11,0x20,0x09,0x38,0x11,0x25,0x25,0x00,0x1A,0x80,0x00,0x00,0x29
37,0x11,0x20,0x0B,0x42,0xA4,0x02,0xD6,0x83,0x01,0x44,0x01,0x80,0xFF,0x0C,0x00

38,0x11,0x21,0x0C,0x00,0xCC,0xA1,0x30,0xA0,0x21,0xD1,0xB9,0xC9,0xEA,0x05,0x12,0x11
39,0x11,0x21,0x0C,0x0C,0x0A,0x04,0x15,0xFC,0x03,0x00,0xCC,0xA1,0x30,0xA0,0x21,0xD1
40,0x11,0x21,0x0C,0x18,0xB9,0xC9,0xEA,0x05,0x12,0x11,0x0A,0x04,0x15,0xFC,0x03,0x00
41,0x11,0x22,0x04,0x00,0x08,0x7F,0x00,0x3D
42,0x11,0x23,0x07,0x00,0x2C,0x0E,0x0B,0x04,0x0C,0x73,0x03
43,0x11,0x22,0x01,0x01,0x7F




44,0x15,0x00
FIFO_INFO. resetting FIFOs

45,0x44,0xFF
READ_CMD_BUFF

46,0x44,0xFF
READ_CMD_BUFF

47,0x44,0xFF,0xFF,0xFF
READ_CMD_BUFF

48,0x33
REQUEST_DEVICE_STATE

49,0x44,0xFF
READ_CMD_BUFF

49,0x44,0xFF,0xFF,0xFF,0xFF
READ_CMD_BUFF

50,0x44,0xFF,0xFF,0xFF,0xFF
READ_CMD_BUFF

51,0x32,  0x02,0x00,0x00,0x14,0x00,0x01,0x03
START_RX, 0x02: Channel 2
          0x00: Use RX parameters, immediate start
          0x00, 0x14: Length of packet, 20 bytes
          0x00: RX timeout state, NOCHANGE
          0x01: RX valid state, SLEEP or STANDBY
          0x03: RX invalid state, READY (but not receiving)
```