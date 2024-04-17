/*! @file radio.h
 * @brief This file is contains the public radio interface functions.
 *
 * @b COPYRIGHT
 * @n Silicon Laboratories Confidential
 * @n Copyright 2012 Silicon Laboratories, Inc.
 * @n http://www.silabs.com
 */

#ifndef RADIO_H_
#define RADIO_H_

/*****************************************************************************
 *  Global Macros & Definitions
 *****************************************************************************/
/*! Maximal packet length definition (FIFO size) */
#define RADIO_MAX_PACKET_LENGTH     64u

/*****************************************************************************
 *  Global Typedefs & Enums
 *****************************************************************************/
typedef struct
{
    uint8_t   *Radio_ConfigurationArray;

    uint8_t   Radio_ChannelNumber;
    uint8_t   Radio_PacketLength;
    uint8_t   Radio_State_After_Power_Up;

    uint16_t  Radio_Delay_Cnt_After_Reset;
} tRadioConfiguration;

/*****************************************************************************
 *  Global Variable Declarations
 *****************************************************************************/
// !!PDS: Not clear what we need here but these need to be variables of some sort!
#if defined(STM8S003) || defined(STM8S105)
extern const tRadioConfiguration *pRadioConfiguration;
extern uint8_t fixRadioPacket[RADIO_MAX_PACKET_LENGTH];

/*! Si446x configuration array */
extern const uint8_t Radio_Configuration_Data_Array[];
#else
extern const SEGMENT_VARIABLE_SEGMENT_POINTER(pRadioConfiguration, tRadioConfiguration, SEG_CODE, SEG_CODE);
extern SEGMENT_VARIABLE(fixRadioPacket[RADIO_MAX_PACKET_LENGTH], uint8_t, SEG_XDATA);

/*! Si446x configuration array */
extern const SEGMENT_VARIABLE(Radio_Configuration_Data_Array[], uint8_t, SEG_CODE);
#endif
/*****************************************************************************
 *  Global Function Declarations
 *****************************************************************************/
void  vRadio_Init(void);
BitStatus   gRadio_CheckReceived(void);
void  vRadio_StartRX(uint8_t);
uint8_t    bRadio_Check_Ezconfig(uint16_t);

#endif /* RADIO_H_ */
