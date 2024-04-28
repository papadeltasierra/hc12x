/*! @file main.c
 * @brief The main.c file of the Fixed packet length RX demo for Si446X devices.
 *
 * Contains the initialization of the MCU & the radio.
 * @n The main loop controls the program flow & the radio.
 *
 * @b CREATED
 * @n Silicon Laboratories Ltd.
 *
 * @b COPYRIGHT
 * @n Silicon Laboratories Confidential
 * @n Copyright 2012 Silicon Laboratories, Inc.
 * @n http://www.silabs.com
 *
 */

#include "stm8s.h"
#include "stm8s_it.h"
#include "stm8s_exti.h"
#include "hc12_conf.h"
#include "radio.h"
#include "si446x_api_lib.h"
#include "si446x_cmd.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
static void CLK_Config(void);
static void GPIO_Config(void);
static void UART_Config(void);
static void SPI_Config(void);
void Delay(uint32_t nCount);
/* Private functions ---------------------------------------------------------*/

/*------------------------------------------------------------------------*/
/*                          Global variables                              */
/*------------------------------------------------------------------------*/

/*------------------------------------------------------------------------*/
/*                          Local variables                               */
/*------------------------------------------------------------------------*/

/*------------------------------------------------------------------------*/
/*                      Local function prototypes                         */
/*------------------------------------------------------------------------*/
// void vPlf_McuInit        (void);
// void vInitializeHW       (void);
void Pollhandler(void);

/*------------------------------------------------------------------------*/
/*                          Function implementations                      */
/*------------------------------------------------------------------------*/
/** \fn void main(void)
 * \brief The main function of the demo.
 *
 * \todo Create description
 */
void main(void)
{
    /* Disable interrupts ------------------------------------------*/
    disableInterrupts();

    /* Clock configuration -----------------------------------------*/
    CLK_Config();

    /* UART configuration -----------------------------------------*/
    GPIO_Config();

    /* UART configuration -----------------------------------------*/
    UART_Config();

    /* SPI configuration ------------------------------------------*/
    SPI_Config();

    /* Initialize the Radio ---------------------------------------*/
    vRadio_Init();

    /* Enable interrupts ------------------------------------------*/
    enableInterrupts();

    /* Start the radio --------------------------------------------*/
		//!!PDS: Why does referencing pRadioconfiguration not work here?
    vRadio_StartRX(pRadioConfiguration->Radio_ChannelNumber);

    /**
     * We now sit waiting for an interrupt that indicates with data received on
     * the UART or the 4463 receiving data.
     */
    while (TRUE)
    {
        Pollhandler();
    }
}

/**
 *  Application Poll-Handler
 *
 *  @note This function just checks for work and processes any found.
 *
 */
void Pollhandler()
{
    uint8_t len;
    uint8_t *ptr;
    if (rxActive)
    {
        /*
         * 4463 is receiving data.
         */
        // Check if radio packet received
        if (TRUE == gRadio_CheckReceived())
        {
            len = Si446xCmd.FIFO_INFO.RX_FIFO_COUNT;
            ptr = &rxRadioPacket[0u];
            while (len--)
            {
                UART1_SendData8(*ptr++);
            }

            // Just stream the data out over the UART.
            rxActive = 0;
        }
    }

    if (UART1_GetFlagStatus(UART1_FLAG_RXNE))
    {
        /**
         * Variable numbers of bytes so keep receiving until the buffer is
         * full or there are no more.
         *
         * TODO: Will need to test to see whether a wait is required
         *       in order to capture all bytes.
         */
        ptr = &txRadioPacket[2];
        (*ptr++) = 0x18;
        ptr++;
        len = 0;
        while (
				(len <= 0x11) && UART1_GetFlagStatus(UART1_FLAG_RXNE))
        {
            *ptr++ = UART1_ReceiveData8();
            len++;
        }
        txRadioPacket[1] = (uint8_t)len;
        vRadio_StartTx(1, len, txRadioPacket);
    }
}

static void CLK_Config(void)
{
    /* Initialization of the clock */
    /* Clock divider to HSI/1 */
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
}
/**
 * @brief  Configure UART.
 * @param  None
 * @retval None
 *
 * UART usage is as follows:
 *
 * - UART1 (PD5/6) provides a UART at 115200 baud, 8,E,1.
 * - UART2 (PD5/6) provides a UART at 115200 baud, 8,E,1.
 * - UART sync clock is disabled as this is regular async serial.
 */
static void UART_Config(void)
{
    UART1_Init(
        UART1_BAUDRATE,
        UART1_WORDLENGTH,
        UART1_STOPBITS,
        UART1_PARITY,
        UART1_SYNCMODE,
        UART1_MODE);

    /*
     * Enable the UART Receive interrupt: this interrupt is generated when the UART
     * receive data register is not empty
     */
    UART1_ITConfig(UART1_IT_RXNE_OR, ENABLE);

    /*
     * Enable the UART Transmit complete interrupt: this interrupt is generated
     * when the UART transmit Shift Register is empty
     */
    // We do not need this; we just check each time! UART1_ITConfig(UART1_IT_TXE, ENABLE);
    // And it trips continually!

    /* Enable UART */
    UART1_Cmd(ENABLE);
}

/**
 * @brief  Configure LEDs available on the evaluation board
 * @param  None
 * @retval None
 */

static void GPIO_Config(void)
{
    /*
     *
     * GPIO usage for the stm8s is as follows:
     *
     * - PB4, 4463 GPIO0
     * - PB5, RESET pad on underside of board (by RXD)
     * - PC3, 4463 GPIO1
     * - PC4, 4463 nIRQ
     * - PC5/SPI_SCK, 4463 SCLK
     * - PC6/SPI_MIDO, 4463 SDI
     * - PC7/SPI_MISO, 4463 SDO
     * - PD1/SWIM, SWIM pad on underside of board (by TXD)
     *
     *   Suspect this might be wrong and might be PA3!
     * - PD2, 4463 nSEL
     * - PD4, 4463 SDN
     * - PD5/6, UART TX/RX
     *
     * The 4463 function of these pins is as follows and this guides the setting
     * of the stm8s GPIO pins.
     *
     * GPIO0 - 4463 => stm8s    TX_STATE, pull-up, high if transmitting else low
     * GPIO1 - 4463 => stm8s    CTS, pull-up, can send command over SPI
     * GPIO2 - 4463 => ANT      ANTENNA_2_SW
     * GPIO3 - 4463 => ANT      ANTENNA_1_SW
     * NIRQ  - 4463 => stm8s    SYNC_WORD_DETECT, pull-up, high at start of packet, low at end.
     * SDO   - 4468 => stm8s    SDO, pull-up
     * Drive strength - HIGH
     * SDN   - stm88 => SDN     Drive high to perform shutdown.
     *
     * We only need to change GPIO pins that are not their default setting.
     */
    /*
     * On the assumption that NSS/nSEL is actually PA4, switch PA4 to it's
     * alternate function.
     */
    GPIO_Init(TX_STATE_GPIOX, TX_STATE_GPIO_PIN, GPIO_MODE_IN_FL_NO_IT); // TX_STATE.
    GPIO_Init(NIRQ_GPIOX, NIRQ_GPIO_PIN, GPIO_MODE_IN_FL_IT);            // SYNC_WORD_DETECT.
    GPIO_Init(CTS_GPIOX, CTS_GPIO_PIN, GPIO_MODE_IN_FL_NO_IT);           // CTS.
    GPIO_Init(SDN_GPIOX, SDN_GPIO_PIN, GPIO_MODE_OUT_PP_LOW_FAST);       // SDN.

    /**
     * Trigger interrupt on falling edge, when we believe a packet has been
     * received.
     */
    EXTI_SetExtIntSensitivity(EXTI_PORT_GPIOC, EXTI_TLISENSITIVITY_FALL_ONLY);

#define AFR0 0x01
#define AFR2 0x02
    // ...
#define AFR7 0x80
    *((NEAR uint8_t *)0x4803) = AFR2;
    *((NEAR uint8_t *)0x4804) = (uint8_t)(~AFR2);
}
/**
 * @brief  Configure SPI for the full duplex communication with 4463
 * @param  None
 * @retval None
 *
 * The stm8s uses the following SPI pins
 *
 * - PA3 pulls nSEL low to signal about to send comment to 4463
 * - PC5/6/7 provide the SPI interface to the 4463
 * - CPU frequency is 16MHz and max SPI speed for the 4463 is 10MHz so divide
 *   by 2 and we can run at 8MHz.
 * - stm8s is the master in the relationship
 * - Communication is full duplex
 * - Data is written on low clock edge
 * - HC-12 uses the NSEL/NSS line via PD2 for hardware NSS
 * - No CRC is used but a value must be configured.
 */
static void SPI_Config(void)
{
    SPI_DeInit();
    /* Initialize SPI in Master mode  */
    SPI_Init(SPI_FIRSTBIT_LSB,
             SPI_BAUDRATEPRESCALER_2,
             SPI_MODE_MASTER,
             SPI_CLOCKPOLARITY_LOW,
             SPI_CLOCKPHASE_1EDGE,
             SPI_DATADIRECTION_2LINES_FULLDUPLEX,
             SPI_NSS_HARD,
             (uint8_t)0x07);
}

/**
 * @brief  Configure I/O Interupts
 * @param  None
 * @retval None
 *
 * HC-12X uses the following interrupts:
 *
 * - PC3 (4463 nIRQ) which signals the start of receiving a frame by going
 *   high until the packet receipt is complete
 * - UART RX to detect receipt of data to be transmitted.
 */
static void IT_Config(void)
{
}

#ifdef USE_FULL_ASSERT

/**
 * @brief  Reports the name of the source file and the source line number
 *   where the assert_param error has occurred.
 * @param file: pointer to the source file name
 * @param line: assert_param error line source number
 * @retval None
 */
void assert_failed(uint8_t *file, uint32_t line)
{
    /* User can add his own implementation to report the file name and line number,
       ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

    /* Infinite loop */
    while (1)
    {
    }
}
#endif
