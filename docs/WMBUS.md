# 44363 Settings for WMBUS

## T1 mode
- Only RX is supported initially.

|Register|Purpose|Value|
|-|-|-|
|Interupts|Interupt to indicate RX of a packet|
||Modulation type|FSK|
||FSK deviation|
||Asynchronous modulation (4.2.1.2)<br/>Required since using non-standard preamble|
||Preamble sense mode|
||RX FIFO mode
||TX FIFO mode
||AFC (RX mode)
|FREQ_CONTROL_INTE<br/>FREQ_CONTROL_FRAC2<br/>FREQ_CONTROL_FRAC1<br/>FREQ_CONTROL_FRAC0|Radio frequency
|FREQ_CONTROL_CHANNEL_STEP_SIZE_0<br/>FREQ_CONTROL_CHANNEL_STEP_SIZE_1|Frequency step size
|RX_HOP_CONTROL|RX frequency hopping|Disabled|
|CRC|Data whitening|3-of-6 encoding
||Wake-up timer|Disabled (always active)
||Low duty Cycle Mode|Disabled (always active)

## Commands
All commands are hexadecimal.

|Number|Command|Byte stream|
|-|-|-|
|00|NOP|00|
|02|POWER_UP|02 01 01 01 C9 C3 80|
|13|GPIO_PIN_CFG|13 48 00 00 00 67 4B 01|
|32|START_RX|32 00 00 00 00 00 00 08|