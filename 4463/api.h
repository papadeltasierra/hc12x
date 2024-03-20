// POWER_UP options
#define POWER_UP 0x02
#define BOOT_OPTIONS_PATCH 0x80
#define BOOT_OPTIONS_FUNC_EZR_PRO 0x01
#define XTAL_OPTIONS_XTAL 0x00
#define XTAL_OPTIONS_TCXO 0x01

#define NOP 0x00

#define GPIO_PIN_CFG 0x13
#define PULL_DIS 0x00
#define PULL_EN 0x40

#define GPIO_MODE_DONOTHING	0	// Behavior of this pin is not modified.	revB1A
#define GPIO_MODE_TRISTATE	1	// Input and output drivers disabled.	revB1A
#define GPIO_MODE_DRIVE0	2	// Pin is configured as a CMOS output and driven low.	revB1A
#define GPIO_MODE_DRIVE1	3	// Pin is configured as a CMOS output and driven high.	revB1A
#define GPIO_MODE_INPUT	    4	// Pin is configured as a CMOS input. This is used for all GPIO functions that require the pin to be an input (e.g., TXDATA input for TX Direct Mode). However, configuration of this pin as an input does NOT additionally select which internal circuit receives that input; that functionality is controlled by other properties, as appropriate.	revB1A
#define GPIO_MODE_32K_CLK	5	// Outputs 32 kHz clock selected using GLOBAL_CLK_CFG:CLK_32K_SEL. Output low if the 32 kHz clock is not enabled.	revB1A
#define GPIO_MODE_BOOT_CLK	6	// Outputs the boot clock signal. This signal will only be present when the chip is in the SPI_ACTIVE state as that is the only state in which the boot clock is active.	revB1A
#define GPIO_MODE_DIV_CLK	7	// Outputs the divided clock signal (or the divided boot clock signal in SPI ACTIVE state). This output is low while the chip is in SLEEP state as the source (e.g., the Xtal Oscillator) for the divided clock signal is not running, and outputs the divided XtalOsc signal in all other states. The divider is configured using the GLOBAL_CLK_CFG:DIVIDED_CLK_SEL.	revB1A
#define GPIO_MODE_CTS	    8	// Clear To Send signal. This output goes high when the command handler is able to receive a new command, and is low otherwise.	revB1A
#define GPIO_MODE_INV_CTS	9	// Inverted Clear To Send signal. This output goes low when clear to send a new command, and is high otherwise.	revB1A
#define GPIO_MODE_CMD_OVERLAP	10	// This output is low unless a command overlap occurs (i.e., another command is sent before the command handler completes processing a previous command). When command overlap occurs, this output goes high until the rising edge of CTS.	revB1A
#define GPIO_MODE_SDO	        11	// Outputs the Serial Data Out (SDO) signal for the SPI bus.	revB1A
#define GPIO_MODE_POR	    12	// This output goes low during Power-On Reset and goes high upon completion of POR.	revB1A
#define GPIO_MODE_CAL_WUT	13	// This output is normally low, and pulses high for one cycle of the 32 kHz clock upon expiration of the Calibration Timer. The 32 kHz clock must be enabled in order to use the Calibration Timer. The Calibration Timer period is configured using GLOBAL_WUT_CONFIG:WUT_CAL_PERIOD and enabled by GLOBAL_WUT_CONFIG:CAL_EN.	revB1A
#define GPIO_MODE_WUT	    14	// This output is normally low, and pulses high for 2(WUT_R+1) cycles of the 32 kHz clock upon expiration of the Wake-Up Timer (WUT). The 32 kHz clock must be enabled in order to use the WUT. The period of the WUT is configured using GLOBAL_WUT_M, and GLOBAL_WUT_R and enabled by GLOBAL_WUT_CONFIG:WUT_EN.	revB1A
#define GPIO_MODE_EN_PA	    15	// This output goes high when the internal PA is enabled.	revB1A
#define GPIO_MODE_TX_DATA_CLK	16	// Outputs the TX Data Clock signal. This signal is a square wave at the selected TX data rate, and is intended for use in TX Direct Synchronous Mode (i.e., in conjunction with a pin configured for TX Data Input).	revB1A
#define GPIO_MODE_RX_DATA_CLK	17	// Outputs the RX Data CLK signal. This signal is nominally a square wave that is synchronized to the received data rate, and is typically used to latch the RX Data signal into the host MCU.	revB1A
#define GPIO_MODE_EN_LNA	18	// This output goes low when the internal LNA is enabled.	revB1A
#define GPIO_MODE_TX_DATA	19	// Outputs the TX data bits pulled from the TX FIFO and sent to the TX modulator. This is an output signal (primarily for diagnostic purposes) and is NOT used as an input for TX Direct Sync/Async mode.	revB1A
#define GPIO_MODE_RX_DATA	20	// Outputs the demodulated RX Data stream, after synchronization and re-timing by the local RX Data Clock.	revB1A
#define GPIO_MODE_RX_RAW_DATA	21	// Outputs the demodulated RX Raw Data stream, prior to synchronization and re-timing by the local RX Data Clock.	revB1A
#define GPIO_MODE_ANTENNA_1_SW	22	// Antenna-1 Switch signal used for control of an RF switch during Antenna Diversity operation. This signal normally assumes the complementary polarity of the Antenna-2 Switch signal (except during SLEEP state).	revB1A
#define GPIO_MODE_ANTENNA_2_SW	23	// Antenna-2 Switch signal used for control of an RF switch during Antenna Diversity operation. This signal normally assumes the complementary polarity of the Antenna-1 Switch signal (except during SLEEP state).	revB1A
#define GPIO_MODE_VALID_PREAMBLE	24	// This output goes high when a valid preamble is detected, and returns low after the packet is received or Sync Word timeout occurs.	revB1A
#define GPIO_MODE_INVALID_PREAMBLE	25	// Output low normally, pulses output high when the preamble is not detected within a period time (determined by PREAMBLE_CONFIG_STD_2:RX_PREAMBLE_TIMEOUT) after the demodulator is enabled.	revB1A
#define GPIO_MODE_SYNC_WORD_DETECT	26	// This output goes high when a Sync Word is detected, and returns low after the packet is received.	revB1A
#define GPIO_MODE_CCA	    27	// Clear Channel Assessment. This output goes high when the Current RSSI signal exceeds the threshold value set by the MODEM_RSSI_THRESH property, and is low when the Current RSSI is below threshold. This is a real-time (non-latched) signal.	revB1A
#define GPIO_MODE_IN_SLEEP	28	// This output goes high when the chip is NOT in SLEEP state, and goes low when in SLEEP state.	revB1A
#define GPIO_MODE_TX_STATE	32	// This output is set high while in TX state and is low otherwise. The TX_STATE and RX_STATE signals are typically used for control of peripheral circuits (e.g., a T/R Switch).	revB1A
#define GPIO_MODE_RX_STATE	33	// This output is set high while in RX state and is low otherwise. The TX_STATE and RX_STATE signals are typically used for control of peripheral circuits (e.g., a T/R Switch).	revB1A
#define GPIO_MODE_RX_FIFO_FULL	34	// This output is high while the number of bytes stored in the RX FIFO exceeds the threshold value set by the PKT_RX_THRESHOLD property, and is low otherwise.	revB1A
#define GPIO_MODE_TX_FIFO_EMPTY	35	// This output is high while the number of bytes of empty space in the TX FIFO exceeds the threshold value set by the PKT_TX_THRESHOLD property, and is low otherwise.	revB1A
#define GPIO_MODE_LOW_BATT	36	// This output is high while the battery voltage drops below the threshold value set by the GLOBAL_LOW_BATT_THRESH property, and is low otherwise.
#define GPIO_MODE_CCA_LATCH	37	// This output goes high if the Current RSSI signal exceeds the threshold value set by the MODEM_RSSI_THRESH property and remains high (i.e., is latched) even if the Current RSSI signal subsequently drops below the threshold value. The signal returns low upon detection of the Sync Word or upon exiting RX state.	revB1A
#define GPIO_MODE_HOPPED	38	// This output toggles (i.e., switches from low to high, or high to low) whenever an automatic hop within the RX Hop Table occurs. This signal is not affected by a manual hop initiated through the RX_HOP command.
#define GPIO_MODE_HOP_TABLE_WRAP	39	// This output toggles (i.e., switches from low to high, or high to low) whenever the automatic hop table wraps. This signal is not affected by a manual hop initiated through the RX_HOP command.

#define NIQR_MODE_DONOTHING	0	// Behavior of this pin is not modified.	revB1A
#define NIQR_MODE_TRISTATE	1	// Input and output drivers disabled.	revB1A
#define NIQR_MODE_DRIVE0	2	// Pin is configured as a CMOS output and driven low.	revB1A
#define NIQR_MODE_DRIVE1	3	// Pin is configured as a CMOS output and driven high.	revB1A
#define NIQR_MODE_INPUT	    4	// Pin is configured as a CMOS input. This is used for all GPIO functions that require the pin to be an input (e.g., TXDATA input for TX Direct Mode). However, configuration of this pin as an input does NOT additionally select which internal circuit receives that input; that functionality is controlled by other properties, as appropriate.	revB1A
#define NIQR_MODE_DIV_CLK	7	// Outputs the divided clock signal (or the divided boot clock signal in SPI ACTIVE state). This output is low while the chip is in SLEEP state as the source (e.g., the Xtal Oscillator) for the divided clock signal is not running, and outputs the divided XtalOsc signal in all other states. The divider is configured using the GLOBAL_CLK_CFG:DIVIDED_CLK_SEL.	revB1A
#define NIQR_MODE_CTS	    8	// Clear To Send signal. This output goes high when the command handler is able to receive a new command, and is low otherwise.	revB1A
#define NIQR_MODE_SDO	    11	// Outputs the Serial Data Out (SDO) signal for the SPI bus.	revB1A
#define NIQR_MODE_POR	    12	// This output goes low during Power-On Reset and goes high upon completion of POR.	revB1A
#define NIQR_MODE_EN_PA	    15	// This output goes high when the internal PA is enabled.	revB1A
#define NIQR_MODE_TX_DATA_CLK	16	// Outputs the TX Data Clock signal. This signal is a square wave at the selected TX data rate, and is intended for use in TX Direct Synchronous Mode (i.e., in conjunction with a pin configured for TX Data Input).	revB1A
#define NIQR_MODE_RX_DATA_CLK	17	// Outputs the RX Data CLK signal. This signal is nominally a square wave that is synchronized to the received data rate, and is typically used to latch the RX Data signal into the host MCU.	revB1A
#define NIQR_MODE_EN_LNA	18	// This output goes low when the internal LNA is enabled.	revB1A
#define NIQR_MODE_TX_DATA	19	// Outputs the TX data bits pulled from the TX FIFO and sent to the TX modulator. This is an output signal (primarily for diagnostic purposes) and is NOT used as an input for TX Direct Sync/Async mode.	revB1A
#define NIQR_MODE_RX_DATA	20	// Outputs the demodulated RX Data stream, after synchronization and re-timing by the local RX Data Clock.	revB1A
#define NIQR_MODE_RX_RAW_DATA	21	// Outputs the demodulated RX Raw Data stream, prior to synchronization and re-timing by the local RX Data Clock.	revB1A
#define NIQR_MODE_ANTENNA_1_SW	22	// Antenna-1 Switch signal used for control of an RF switch during Antenna Diversity operation. This signal normally assumes the complementary polarity of the Antenna-2 Switch signal (except during SLEEP state).	revB1A
#define NIQR_MODE_ANTENNA_2_SW	23	// Antenna-2 Switch signal used for control of an RF switch during Antenna Diversity operation. This signal normally assumes the complementary polarity of the Antenna-1 Switch signal (except during SLEEP state).	revB1A
#define NIQR_MODE_VALID_PREAMBLE	24	// This output goes high when a valid preamble is detected, and returns low after the packet is received or Sync Word timeout occurs.	revB1A
#define NIQR_MODE_INVALID_PREAMBLE	25	// Output low normally, pulses output high when the preamble is not detected within a period time (determined by PREAMBLE_CONFIG_STD_2:RX_PREAMBLE_TIMEOUT) after the demodulator is enabled.	revB1A
#define NIQR_MODE_SYNC_WORD_DETECT	26	// This output goes high when a Sync Word is detected, and returns low after the packet is received.	revB1A
#define NIQR_MODE_CCA	27	// Clear Channel Assessment. This output goes high when the Current RSSI signal exceeds the threshold value set by the MODEM_RSSI_THRESH property, and is low when the Current RSSI is below threshold. This is a real-time (non-latched) signal.	revB1A
#define NIQR_MODE_NIRQ	39	// Active low interrupt signal.

#define SDA_MODE_DONOTHING	0	// Behavior of this pin is not modified.	revB1A
#define SDA_MODE_TRISTATE	1	// Input and output drivers disabled.	revB1A
#define SDA_MODE_DRIVE0	    2	// Pin is configured as a CMOS output and driven low.	revB1A
#define SDA_MODE_DRIVE1	    3	// Pin is configured as a CMOS output and driven high.	revB1A
#define SDA_MODE_INPUT	    4	// Pin is configured as a CMOS input. This is used for all GPIO functions that require the pin to be an input (e.g., TXDATA input for TX Direct Mode). However, configuration of this pin as an input does NOT additionally select which internal circuit receives that input; that functionality is controlled by other properties, as appropriate.	revB1A
#define SDA_MODE_32K_CLK	5	// Outputs 32 kHz clock selected using GLOBAL_CLK_CFG:CLK_32K_SEL. Output low if the 32 kHz clock is not enabled.	revB1A
#define SDA_MODE_DIV_CLK	7	// Outputs the divided clock signal (or the divided boot clock signal in SPI ACTIVE state). This output is low while the chip is in SLEEP state as the source (e.g., the Xtal Oscillator) for the divided clock signal is not running, and outputs the divided XtalOsc signal in all other states. The divider is configured using the GLOBAL_CLK_CFG:DIVIDED_CLK_SEL.	revB1A
#define SDA_MODE_CTS	    8	// Clear To Send signal. This output goes high when the command handler is able to receive a new command, and is low otherwise.	revB1A
#define SDA_MODE_SDO	    11	// Outputs the Serial Data Out (SDO) signal for the SPI bus.	revB1A
#define SDA_MODE_POR	    12	// This output goes low during Power-On Reset and goes high upon completion of POR.	revB1A
#define SDA_MODE_WUT	    14	// This output is normally low, and pulses high for 2(WUT_R+1) cycles of the 32 kHz clock upon expiration of the Wake-Up Timer (WUT). The 32 kHz clock must be enabled in order to use the WUT. The period of the WUT is configured using GLOBAL_WUT_M, and GLOBAL_WUT_R and enabled by GLOBAL_WUT_CONFIG:WUT_EN.	revB1A
#define SDA_MODE_EN_PA	    15	// This output goes high when the internal PA is enabled.	revB1A
#define SDA_MODE_TX_DATA_CLK	16	// Outputs the TX Data Clock signal. This signal is a square wave at the selected TX data rate, and is intended for use in TX Direct Synchronous Mode (i.e., in conjunction with a pin configured for TX Data Input).	revB1A
#define SDA_MODE_RX_DATA_CLK	17	// Outputs the RX Data CLK signal. This signal is nominally a square wave that is synchronized to the received data rate, and is typically used to latch the RX Data signal into the host MCU.	revB1A
#define SDA_MODE_EN_LNA	    18	// This output goes low when the internal LNA is enabled.	revB1A
#define SDA_MODE_TX_DATA	19	// Outputs the TX data bits pulled from the TX FIFO and sent to the TX modulator. This is an output signal (primarily for diagnostic purposes) and is NOT used as an input for TX Direct Sync/Async mode.	revB1A
#define SDA_MODE_RX_DATA	20	// Outputs the demodulated RX Data stream, after synchronization and re-timing by the local RX Data Clock.	revB1A
#define SDA_MODE_RX_RAW_DATA	21	// Outputs the demodulated RX Raw Data stream, prior to synchronization and re-timing by the local RX Data Clock.	revB1A
#define SDA_MODE_ANTENNA_1_SW	22	// Antenna-1 Switch signal used for control of an RF switch during Antenna Diversity operation. This signal normally assumes the complementary polarity of the Antenna-2 Switch signal (except during SLEEP state).	revB1A
#define SDA_MODE_ANTENNA_2_SW	23	// Antenna-2 Switch signal used for control of an RF switch during Antenna Diversity operation. This signal normally assumes the complementary polarity of the Antenna-1 Switch signal (except during SLEEP state).	revB1A
#define SDA_MODE_VALID_PREAMBLE	24	// This output goes high when a valid preamble is detected, and returns low after the packet is received or Sync Word timeout occurs.	revB1A
#define SDA_MODE_INVALID_PREAMBLE	25	// Output low normally, pulses output high when the preamble is not detected within a period time (determined by PREAMBLE_CONFIG_STD_2:RX_PREAMBLE_TIMEOUT) after the demodulator is enabled.	revB1A
#define SDA_MODE_SYNC_WORD_DETECT	26	// This output goes high when a Sync Word is detected, and returns low after the packet is received.	revB1A
#define SDA_MODE_CCA	    27	// Clear Channel Assessment. This output goes high when the Current RSSI signal exceeds the threshold value set by the MODEM_RSSI_THRESH property, and is low when the Current RSSI is below threshold. This is a real-time (non-latched) signal.

#define DRV_STRENGTH_HIGH 0
#define DRV_STRENGTH_MED_HIGH 1
#define DRV_STRENGTH_MED_LOW 2
#define DRV_STRENGTH_LOW 3

#define START_RX 0x32
#define CONDITION_START_IMMEDIATE 0
#define CONDITION_START_WUT 1
#define RXTIMEOUT_STATE_NOCHANGE	0	// Remain in RX state if RXTIMEOUT occurs.
#define RXTIMEOUT_STATE_SLEEP	    1	// SLEEP or STANDBY state, according to the mode of operation of the 32K R-C Osc selected by GLOBAL_CLK_CFG:CLK_32K_SEL.
#define RXTIMEOUT_STATE_SPI_ACTIVE	2	// SPI ACTIVE state.
#define RXTIMEOUT_STATE_READY	    3	// READY state.
#define RXTIMEOUT_STATE_READY2	    4	// Another enumeration for READY state.
#define RXTIMEOUT_STATE_TX_TUNE	    5	// TX_TUNE state.
#define RXTIMEOUT_STATE_RX_TUNE	    6	// RX_TUNE state.
#define RXTIMEOUT_STATE_TX	        7	// TX state.
#define RXTIMEOUT_STATE_RX	        8	// RX state (briefly exit and re-enter RX state to re-arm for acquisition of another packet).

#define RXVALID_STATE_REMAIN	    0	// Remain in RX state (but do not re-arm to acquire another packet).	revB1A
#define RXVALID_STATE_SLEEP	        1	// SLEEP or STANDBY state, according to the mode of operotion of the 32K R-C Osc selected by GLOBAL_CLK_CFG:CLK_32K_SEL.	revB1A
#define RXVALID_STATE_SPI_ACTIVE	2	// SPI ACTIVE state.	revB1A
#define RXVALID_STATE_READY	        3	// READY state.	revB1A
#define RXVALID_STATE_READY2	    4	// Another enumeration for READY state.	revB1A
#define RXVALID_STATE_TX_TUNE	    5	// TX_TUNE state.	revB1A
#define RXVALID_STATE_RX_TUNE	    6	// RX_TUNE state.	revB1A
#define RXVALID_STATE_TX	        7	// TX state.	revB1A
#define RXVALID_STATE_RX	        8	// RX state (briefly exit and re-enter RX state to re-arm for acquisition of another packet).

#define RXVALID_STATE_REMAIN	    0	// Remain in RX state (but do not re-arm to acquire another packet).	revB1A
#define RXVALID_STATE_SLEEP	        1	// SLEEP or STANDBY state, according to the mode of operotion of the 32K R-C Osc selected by GLOBAL_CLK_CFG:CLK_32K_SEL.	revB1A
#define RXVALID_STATE_SPI_ACTIVE	2	// SPI ACTIVE state.	revB1A
#define RXVALID_STATE_READY	        3	// READY state.	revB1A
#define RXVALID_STATE_READY2	    4	// Another enumeration for READY state.	revB1A
#define RXVALID_STATE_TX_TUNE	    5	// TX_TUNE state.	revB1A
#define RXVALID_STATE_RX_TUNE	    6	// RX_TUNE state.	revB1A
#define RXVALID_STATE_TX	        7	// TX state.	revB1A
#define RXVALID_STATE_RX	        8	// RX state (briefly exit and re-enter RX state to re-arm for acquisition of another packet).