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

#include "stm8s"


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

//!!PDS: Not clear how this is used.
void radio_hal_AssertShutdown(void)
{
#if (defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB) || (defined SILABS_PLATFORM_WMB)
  RF_PWRDN = 1;
#else
  PWRDN = 1;
#endif
}

void radio_hal_DeassertShutdown(void)
{
#if (defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB) || (defined SILABS_PLATFORM_WMB)
  RF_PWRDN = 0;
#else
  PWRDN = 0;
#endif
}
#endif

void radio_hal_ClearNsel(void)
{
    GPIO_WriteLow(NSEL_GPIOX, NSEL_GPIO_PIN);
}

void radio_hal_SetNsel(void)
{
    GPIO_WriteHigh(NSEL_GPIOX, NSEL_GPIO_PIN);
}

BIT radio_hal_NirqLevel(void)
{
    return GPIO_ReadInputPin(NIQR_GPIOX, NIRQ_GPIO_PIN)
}

void radio_hal_SpiWriteByte(uint8_t byteToWrite)
{
  SPI_SendData(byteToWrite);
}

uint8_t radio_hal_SpiReadByte(void)
{
  return SPI_ReceiveData();
}

void radio_hal_SpiWriteData(uint8_t byteCount, uint8_t* pData)
{
  while (byteCount--) SPI_SendData(*pData++);
}

void radio_hal_SpiReadData(uint8_t byteCount, uint8_t* pData)
{
  while (byteCount--) (*pData++) = SPI_ReceiveData();
}

#if 0
#ifdef RADIO_DRIVER_EXTENDED_SUPPORT
BIT radio_hal_Gpio0Level(void)
{
  BIT retVal = FALSE;

#ifdef SILABS_PLATFORM_DKMB
  retVal = FALSE;
#endif
#ifdef SILABS_PLATFORM_UDP
  retVal = EZRP_RX_DOUT;
#endif
#if (defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB)
  retVal = RF_GPIO0;
#endif
#if (defined SILABS_PLATFORM_WMB930)
  retVal = FALSE;
#endif
#if defined (SILABS_PLATFORM_WMB912)
  #ifdef SILABS_IO_WITH_EXTENDER
    //TODO
    retVal = FALSE;
  #endif
#endif

  return retVal;
}

BIT radio_hal_Gpio1Level(void)
{
  BIT retVal = FALSE;

#ifdef SILABS_PLATFORM_DKMB
  retVal = FSK_CLK_OUT;
#endif
#ifdef SILABS_PLATFORM_UDP
  retVal = FALSE; //No Pop
#endif
#if (defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB) || (defined SILABS_PLATFORM_WMB930)
  retVal = RF_GPIO1;
#endif
#if defined (SILABS_PLATFORM_WMB912)
  #ifdef SILABS_IO_WITH_EXTENDER
    //TODO
    retVal = FALSE;
  #endif
#endif

  return retVal;
}

BIT radio_hal_Gpio2Level(void)
{
  BIT retVal = FALSE;

#ifdef SILABS_PLATFORM_DKMB
  retVal = DATA_NFFS;
#endif
#ifdef SILABS_PLATFORM_UDP
  retVal = FALSE; //No Pop
#endif
#if (defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB) || (defined SILABS_PLATFORM_WMB930)
  retVal = RF_GPIO2;
#endif
#if defined (SILABS_PLATFORM_WMB912)
  #ifdef SILABS_IO_WITH_EXTENDER
    //TODO
    retVal = FALSE;
  #endif
#endif

  return retVal;
}

BIT radio_hal_Gpio3Level(void)
{
  BIT retVal = FALSE;

#if (defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB) || (defined SILABS_PLATFORM_WMB930)
  retVal = RF_GPIO3;
#elif defined (SILABS_PLATFORM_WMB912)
  #ifdef SILABS_IO_WITH_EXTENDER
    //TODO
    retVal = FALSE;
  #endif
#endif

  return retVal;
}

#endif
#endif