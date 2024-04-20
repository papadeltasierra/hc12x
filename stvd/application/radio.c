/*! @file radio.c
 * @brief This file contains functions to interface with the radio chip.
 *
 * @b COPYRIGHT
 * @n Silicon Laboratories Confidential
 * @n Copyright 2012 Silicon Laboratories, Inc.
 * @n http://www.silabs.com
 */

#include "stm8s.h"
#include "radio.h"
#include "radio_config_wmbus.h"
#include "si446x_cmd.h"
#include "si446x_api_lib.h"

/*****************************************************************************
 *  Local Macros & Definitions
 *****************************************************************************/

/*****************************************************************************
 *  Global Variables
 *****************************************************************************/
#if defined(STM8S003) || defined(STM8S105)
uint8_t Radio_Configuration_Data_Array[] = RADIO_CONFIGURATION_DATA_ARRAY;

const tRadioConfiguration FixedRadioConfiguration = RADIO_FIXED_CONFIGURATION_DATA;
#pragma segment(ecode)
const tRadioConfiguration CustomRadioConfiguration = RADIO_CUSTOM_CONFIGURATION_DATA;
#pragma segment()
const tRadioConfiguration PowerRadioConfiguration = RADIO_POWER_CONFIGURATION_DATA;

const tRadioConfiguration *pFixedRadioConfiguration = &FixedRadioConfiguration;
const tRadioConfiguration *pCustomRadioConfiguration = &CustomRadioConfiguration;
const tRadioConfiguration *pPowerRadioConfiguration = &PowerRadioConfiguration;

uint8_t rxRadioPacket[RADIO_MAX_PACKET_LENGTH];
uint8_t txRadioPacket[RADIO_MAX_PACKET_LENGTH];
#else
const SEGMENT_VARIABLE(Radio_Configuration_Data_Array[], uint8_t, SEG_CODE) =
    RADIO_CONFIGURATION_DATA_ARRAY;

const SEGMENT_VARIABLE(RadioConfiguration, tRadioConfiguration, SEG_CODE) =
    RADIO_CONFIGURATION_DATA;

const SEGMENT_VARIABLE_SEGMENT_POINTER(pRadioConfiguration, tRadioConfiguration, SEG_CODE, SEG_CODE) =
    &RadioConfiguration;

SEGMENT_VARIABLE(fixRadioPacket[RADIO_MAX_PACKET_LENGTH], uint8_t, SEG_XDATA);
#endif
/*****************************************************************************
 *  Local Function Declarations
 *****************************************************************************/
void vRadio_PowerUp(void);

/*!
 *  Power up the Radio.
 *
 *  @note
 *
 */
@tiny static uint16_t wDelay = 0u;
void vRadio_PowerUp(void)
{
    @tiny uint16_t wDelay = 0u;

    /* Hardware reset the chip */
    si446x_reset();

    /* Wait until reset timeout or Reset IT signal */
    for (; wDelay < pFixedRadioConfiguration->Radio_Delay_Cnt_After_Reset; wDelay++)
        ;
}

/*!
 *  Radio Initialization.
 *
 *  @author Sz. Papp
 *
 *  @note
 *
 */
void vRadio_Init(void)
{
    uint16_t wDelay;

    /* Power Up the radio chip */
    vRadio_PowerUp();

    /* Load radio configuration */
    while (SI446X_SUCCESS != si446x_configuration_init(
        pFixedRadioConfiguration->Radio_ConfigurationArray,
        pCustomRadioConfiguration->Radio_ConfigurationArray,
        pPowerRadioConfiguration->Radio_ConfigurationArray
        ))
    {
        /* Error hook */
        for (wDelay = 0x7FFF; wDelay--;)
            ;

        /* Power Up the radio chip */
        vRadio_PowerUp();
    }

    // Read ITs, clear pending ones
    si446x_get_int_status(0u, 0u, 0u);
}

/*!
 *  Check if Packet received IT flag is pending.
 *
 *  @return   TRUE - Packet successfully received / FALSE - No packet pending.
 *
 *  @note
 *
 */
BitStatus gRadio_CheckReceived(void)
{
    /* Read ITs, clear pending ones */
    si446x_get_int_status(0u, 0u, 0u);

    /* check the reason for the IT */
    if (Si446xCmd.GET_INT_STATUS.PH_PEND & SI446X_CMD_GET_INT_STATUS_REP_PH_PEND_PACKET_RX_PEND_BIT)
    {
        /* Packet RX */

        /* Get payload length */
        si446x_fifo_info(0x00);

        si446x_read_rx_fifo(Si446xCmd.FIFO_INFO.RX_FIFO_COUNT, &rxRadioPacket[0]);
        return TRUE;
    }

    if (Si446xCmd.GET_INT_STATUS.PH_PEND & SI446X_CMD_GET_INT_STATUS_REP_PH_STATUS_CRC_ERROR_BIT)
    {
        /* Reset FIFO */
        si446x_fifo_info(SI446X_CMD_FIFO_INFO_ARG_FIFO_RX_BIT);
    }
    return FALSE;
}

/*!
 *  Set Radio to RX mode, fixed packet length.
 *
 *  @param channel Freq. Channel
 *
 *  @note
 *
 */
void vRadio_StartRX(uint8_t channel)
{
    // Read ITs, clear pending ones
    si446x_get_int_status(0u, 0u, 0u);

    /* Start Receiving packet, channel 0, START immediately, Packet n bytes long */
		// !!PDS: Duplication.
    si446x_start_rx(channel, 0u, FixedRadioConfiguration.Radio_PacketLength,
                    SI446X_CMD_START_RX_ARG_NEXT_STATE1_RXTIMEOUT_STATE_ENUM_NOCHANGE,
                    SI446X_CMD_START_RX_ARG_NEXT_STATE2_RXVALID_STATE_ENUM_RX,
                    SI446X_CMD_START_RX_ARG_NEXT_STATE3_RXINVALID_STATE_ENUM_RX);
}

/*!
 *  Set Radio to TX mode, fixed packet length.
 *
 *  @param channel Freq. Channel, Packet to be sent
 *
 *  @note
 *
 */
void  vRadio_StartTx(uint8_t channel, uint8_t length, uint8_t *pioFixRadioPacket)
{
  // Read ITs, clear pending ones
  si446x_get_int_status(0u, 0u, 0u);

  /* Fill the TX fifo with datas */
  si446x_write_tx_fifo(length, pioFixRadioPacket);

  /* Start sending packet, channel 0, START immediately, Packet n bytes long, go READY when done */
  si446x_start_tx(channel, 0x80,  length);
}
