/*!
 * File:
 *  radio_hal.c
 *
 * Description:
 *  This file contains RADIO HAL.
 *
 * Silicon Laboratories Confidential
 * Copyright 2011 Silicon Laboratories, Inc.
 */

/* ======================================= *
 *              I N C L U D E              *
 * ======================================= */

#include "stm8s.h"
#include "stm8s_gpio.h"
#include "stm8s_spi.h"
#include "hc12_conf.h"

/* ======================================= *
 *          D E F I N I T I O N S          *
 * ======================================= */

/* ======================================= *
 *     G L O B A L   V A R I A B L E S     *
 * ======================================= */

/* ======================================= *
 *      L O C A L   F U N C T I O N S      *
 * ======================================= */

/* ======================================= *
 *     P U B L I C   F U N C T I O N S     *
 * ======================================= */

void radio_hal_AssertShutdown(void)
{
    /**
     * Shutdown the 4463 by pulling PD4/SDN high.
     */
    GPIO_WriteHigh(SDN_GPIOX, SDN_GPIO_PIN);
}

void radio_hal_DeassertShutdown(void)
{
    /**
     * Shutdown the 4463 by pulling PD4/SDN low.
     */
    GPIO_WriteLow(SDN_GPIOX, SDN_GPIO_PIN);
}

void radio_hal_ClearNsel(void)
{
    GPIO_WriteLow(NSEL_GPIOX, NSEL_GPIO_PIN);
}

void radio_hal_SetNsel(void)
{
    GPIO_WriteHigh(NSEL_GPIOX, NSEL_GPIO_PIN);
}

/**
 * HC-12 does not use nIRQ so always claim true.
*/
BitStatus radio_hal_NirqLevel(void)
{
    BitStatus nIrqAlwaysHigh = 1;
    return nIrqAlwaysHigh;
}

void radio_hal_SpiWriteByte(uint8_t byteToWrite)
{
    SPI_SendData(byteToWrite);
}

uint8_t radio_hal_SpiReadByte(void)
{
    return SPI_ReceiveData();
}

void radio_hal_SpiWriteData(uint8_t byteCount, uint8_t *pData)
{
    while (byteCount--)
        SPI_SendData(*pData++);
}

void radio_hal_SpiReadData(uint8_t byteCount, uint8_t *pData)
{
    while (byteCount--)
        (*pData++) = SPI_ReceiveData();
}
