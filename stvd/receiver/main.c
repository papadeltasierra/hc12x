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
#include "stm8s_uart_mapping.h"
#include "hc12_conf.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
?? static void GPIO_Config(void);
?? static void CLK_Config(void);
static void UART_Config(void);
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
void vPlf_McuInit        (void);
void vInitializeHW       (void);
void DemoApp_Pollhandler (void);

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
  /* Clock configuration -----------------------------------------*/
  CLK_Config();

  /* UART configuration -----------------------------------------*/
  UART_Config();

  /* SPI configuration -----------------------------------------*/
  SPI_Config();









#if 0
  // Initialize the Hardware and Radio
  vInitializeHW();

#ifdef SILABS_LCD_DOG_GLCD
  /* Initialize graphic LCD */
  vLcd_InitLcd();

  /* Set logo location to center */
  bLcd_LcdSetPictureCursor(bLcd_Line1_c, 35u);

  /* Draw SiLabs logo */
  vLcd_LcdDrawPicture(silabs66x30);
#endif
#endif

  // Start RX
  vRadio_StartRX(pRadioConfiguration->Radio_ChannelNumber);

  while (TRUE)
  {
#if !defined(STM8S003) && !defined(STM8S105)
    // The following Handlers requires care on invoking time interval
    if (wIsr_Timer2Tick)
    {
      vHmi_LedHandler();
      vHmi_BuzzHandler();
      vHmi_PbHandler();

      wIsr_Timer2Tick = 0;
    }
#endif
    // Demo Application Poll-Handler function
    DemoApp_Pollhandler();
  }
}

/**
 *  Demo Application Poll-Handler
 *
 *  @note This function must be called periodically.
 *
 */
void DemoApp_Pollhandler()
{
  uint8_t lButton = 0xFF;

  // Check if radio packet received
  if (TRUE == gRadio_CheckReceived())
  {
#if defined (STM8S0003) || defined(STM8S105)
    // Just stream the data out over the UART.
#else
    // Check if the radio packet contains "BUTTON" string
    if (gSampleCode_StringCompare((uint8_t *) &fixRadioPacket[0u], "BUTTON", 6u) == TRUE)
    {
      // Search for button index number (from '1' to '4')
      lButton = fixRadioPacket[6u] - 0x30;

      vHmi_ChangeBuzzState(eHmi_BuzzOnce_c);
    }
    else if (fixRadioPacket[0u] == fixRadioPacket[2u])
    {
      /* Packet sent by old Keyfob */

      switch (fixRadioPacket[0u])
      {
        case 0xD7:
          lButton = 0x01;
          break;

        case 0xF5:
          lButton = 0x02;
          break;

        case 0x5F:
          lButton = 0x03;
          break;

        case 0x7D:
          lButton = 0x04;
          break;

        default:
          break;
      }
    }
    else
    {
      /* Packet sent by new Keyfob */

      if (fixRadioPacket[4u] & (1u << 0u))
      {
        lButton = 0x01;
      }
      else if (fixRadioPacket[4u] & (1u << 1u))
      {
        lButton = 0x02;
      }
      else if (fixRadioPacket[4u] & (1u << 2u))
      {
        lButton = 0x03;
      }
      else if (fixRadioPacket[4u] & (1u << 3u))
      {
        lButton = 0x04;
      }
    }

    switch (lButton)
    {
    /* Show the button number in BCD form on LEDs */
    case 0x01:
      vHmi_ChangeLedState(eHmi_Led2_c, eHmi_LedBlinkOnce_c);
      break;

    case 0x02:
      vHmi_ChangeLedState(eHmi_Led3_c, eHmi_LedBlinkOnce_c);
      break;

    case 0x03:
      vHmi_ChangeLedState(eHmi_Led2_c, eHmi_LedBlinkOnce_c);
      vHmi_ChangeLedState(eHmi_Led3_c, eHmi_LedBlinkOnce_c);
      break;

    case 0x04:
      vHmi_ChangeLedState(eHmi_Led4_c, eHmi_LedBlinkOnce_c);
      break;

    default:
      /* Wrong number */
      vHmi_ChangeLedState(eHmi_Led2_c, eHmi_LedBlinkOnce_c);
      vHmi_ChangeLedState(eHmi_Led3_c, eHmi_LedBlinkOnce_c);
      vHmi_ChangeLedState(eHmi_Led4_c, eHmi_LedBlinkOnce_c);
      break;
    }
  }
#endif
}

/**
 *  Calls the init functions for the used peripherals/modules
 *
 *  @note Should be called at the beginning of the main().
 *
 */
void vInitializeHW()
{
  // Initialize the MCU peripherals
  !!PDS: Here
  vPlf_McuInit();

#if ! defined(STM8S003) && !defined(STM8S105)
  // Initialize IO ports
  vCio_InitIO();
#endif

  !!PDS: what is this for?
  // Start Timer2 peripheral with overflow interrupt
  vTmr_StartTmr2(eTmr_SysClkDiv12_c, wwTmr_Tmr2Periode.U16, TRUE, bTmr_TxXCLK_00_c);

  // Initialize the Radio
  vRadio_Init();

  // Enable configured interrupts
  mIsr_EnableAllIt();
}

/** \fn void MCU_Init(void)
 *  \brief Initializes ports of the MCU.
 *
 *  \return None
 *
 *  \note It has to be called from the Initialization section.
 *  \todo Create description
 */
void vPlf_McuInit(void)
{
#if defined(STM8S003) || defined(STM8S105)
  UART_Config();

#else
  U16 wDelay = 0xFFFF;

  /* disable watchdog */
  PCA0MD &= (~M_WDTE);

  /* Init Internal Precision Oscillator (24.5MHz) */
  SFRPAGE = LEGACY_PAGE;
  FLSCL   = M_BYPASS;

  OSCICN |= M_IOSCEN; // p7: Internal Prec. Osc. enabled
  CLKSEL  = 0x00;     // Int. Prec. Osc. selected (24.5MHz)

#if ((defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB))
  P0MDOUT = M_P0_UART_TX; //PBs: P0.0-P0.3 (same as RF_GPIO0-3) used as input
  P1MDOUT = M_P1_SPI1_SCK | M_P1_SPI1_MOSI | M_P1_RF_NSEL | M_P1_RF_PWRDN;
  P2MDOUT = M_P2_LED1 | M_P2_LED2 | M_P2_LED3 | M_P2_LED4 | M_P2_BZ1;
#if (defined SILABS_PLATFORM_LCDBB)
  P1MDOUT |= M_P1_LCD_NSEL | M_P1_LCD_A0;
#endif

  P0SKIP  = (~M_P0_UART_TX) & (~M_P0_UART_RX) & (~M_P0_I2C_SCL) & (~M_P0_I2C_SDA); //skip all on port, but UART & SMBus
  P1SKIP  = (~M_P1_SPI1_SCK) & (~M_P1_SPI1_MISO) & (~M_P1_SPI1_MOSI); //skip all on port, but SPI1
  P2SKIP  = (~M_P2_BZ1); //skip all on port, but buzzer with PCA CEX0
#elif ((defined SILABS_MCU_DC_EMIF_F930) || (SILABS_MCU_DC_EMIF_F930_STANDALONE))

#if (defined SILABS_MCU_DC_EMIF_F930)
  // Init master hw SPI interface (SCK clock: 2.45MHz)
  // Init SPI0 (LCD)
  SPI0CFG = M_MSTEN0; //p6: SPI0 enable master mode
  SPI0CN  = M_SPI0EN; //p1: SPI0 enable
  SPI0CKR = 0x04;     //fSCK = SYSCLK / 10
#endif

  P0MDOUT = M_P0_UART_TX | M_P0_LED1 | M_P0_LED2 | M_P0_LED3 | M_P0_LED4;
  P1MDOUT = M_P1_SPI1_SCK | M_P1_SPI1_MOSI | M_P1_RF_NSEL;
  P2MDOUT = M_P2_RF_PWRDN;
#if (defined SILABS_MCU_DC_EMIF_F930)
  P1MDOUT |= M_P1_SPI0_SCK | M_P1_SPI0_MOSI;
  P2MDOUT |=  M_P2_LCD_NSEL | M_P2_LCD_A0;
#endif

  P0SKIP  = (~M_P0_UART_TX) & (~M_P0_UART_RX) ; //skip all on port, but UART
  P1SKIP  = (~M_P1_SPI1_SCK) & (~M_P1_SPI1_MISO) & (~M_P1_SPI1_MOSI); //skip all on port, but SPI1
  P2SKIP  = (~M_P2_I2C_SCL) & (~M_P2_I2C_SDA); //skip all on port, but SMBus
#if (defined SILABS_MCU_DC_EMIF_F930)
  P1SKIP  &= (~M_P1_SPI0_SCK) & (~M_P1_SPI0_MISO) & (~M_P1_SPI0_MOSI); //do not skip SPI0 for LCD
#endif

#elif (defined SILABS_PLATFORM_WMB930)
  /* Port IN/OUT init */
  P0MDOUT = 0x80;
  P1MDOUT = 0xF5;
  P2MDOUT = 0x49;

  P0SKIP  = 0xCF;
  P1SKIP  = 0x18;
  P2SKIP  = 0xB9;
#elif (defined SILABS_PLATFORM_WMB912)
  /* Port IN/OUT init */
  /* P0: 2,3,4,6,7 push-pull */
  /* P1: 0,2,3,6 push-pull */
  /* P2: no push-pull */
  P0MDOUT   = 0xDC;
  P1MDOUT   = 0x4D;

  /* P0: 0,1,2,3,6,7 skipped */
  /* P1: 3,6 skipped */
  /* P2: 7 skipped */
  P0SKIP    = 0xCF;
  P1SKIP    = 0x48;

  /* Set SMBUS clock speed */
  Set115200bps_24MHZ5;
  /* Start Timer1 */
  TR1 = 1;
  /* Initialize SMBus */
  vSmbus_InitSMBusInterface();
#else
#error TO BE WRITTEN FOR OTHER PLARFORMS!
#endif

  P0MDIN  = 0xFF; // All pin configured as digital port
  P1MDIN  = 0xFF; // All pin configured as digital port
#if !(defined SILABS_PLATFORM_WMB912)
  P2MDIN  = 0xFF; // All pin configured as digital port
#endif

  /* Set Drive Strenght */
  SFRPAGE = CONFIG_PAGE;
  P0DRV   = 0x00;
  P1DRV   = 0x00;
#if !(defined SILABS_PLATFORM_WMB912)
  P2DRV   = 0x00;
#endif

  SFRPAGE = LEGACY_PAGE;

  /* Crossbar configuration */
  XBR0    = M_URT0E | M_SMB0E; //p0: UART enabled on XBAR
  XBR1    = M_SPI1E ; //p6: SPI1 enabled on XBAR
#if ((defined SILABS_PLATFORM_RFSTICK) || (defined SILABS_PLATFORM_LCDBB))
  XBR1    |= (1 << BF_PCA0ME_0); //p0: PCA CEX0 enabled on XBAR
#elif(defined SILABS_MCU_DC_EMIF_F930)
  XBR0    |= M_SPI0E ; //p6: SPI1 enabled on XBAR
#elif (defined SILABS_MCU_DC_EMIF_F930_STANDALONE)

#elif (defined SILABS_PLATFORM_WMB930)
  XBR1    |= (1 << BF_PCA0ME_0); //p0: PCA CEX0 enabled on XBAR
  XBR0    |= M_SPI0E;
#elif (defined SILABS_PLATFORM_WMB912)

#else
#error TO BE WRITTEN FOR OTHER PLARFORMS!
#endif
  XBR2    = M_XBARE; //p6: XBAR enable

  /* latch all inputs to '1' */
  P0      = ~P0MDOUT;
  P1      = ~P1MDOUT;
#if !(defined SILABS_PLATFORM_WMB912)
  P2      = ~P2MDOUT;
#endif

  /* set all output to its default state */
  LED1      = EXTINGUISH;
#if !(defined SILABS_PLATFORM_WMB912)
  LED2      = EXTINGUISH;
  LED3      = EXTINGUISH;
  LED4      = EXTINGUISH;
#endif
  RF_NSEL   = TRUE;
  RF_PWRDN  = FALSE;

  /* SPI1 & SPI0 Config & Enable */
  SPI0CFG   = 0x40;
  SPI1CFG   = 0x40;
#if !(defined SILABS_PLATFORM_WMB912)
  SPI0CN    = 0x01;
#else
  SPI0CN    = 0x00;
#endif
  SPI1CN    = 0x01;
  SPI0CKR   = 0x0B;
  SPI1CKR   = 0x0B;

#ifdef UART_LOGGING_SUPPORT
  /* UART must be enabled, cannot be disabled */
  Comm_IF_EnableUART();
#endif

  /* De-select radio SPI */
  vSpi_SetNsel(eSpi_Nsel_RF);

#if ((defined SILABS_LCD_DOG_GLCD) || (defined SILABS_MCU_DC_EMIF_F930) || (defined SILABS_PLATFORM_WMB))
  /* De-select LCD SPI */
  vSpi_SetNsel(eSpi_Nsel_LCD);

  LCD_A0    = FALSE;
#endif

  /* Startup delay */
  for (; wDelay; wDelay--)  ;
#endif
}

#ifdef SDCC
/**
 * \brief External startup function of SDCC.
 *
 * It performs operations
 * prior static and global variable initialization.
 * Watchdog timer should be disabled this way, otherwise it
 * can expire before variable initialization is carried out,
 * and may prevent program execution jumping into main().
 *
 * \param None
 * \return None
 */
void _sdcc_external_startup(void)
{
  !!PDS: What is this for?
  PCA0MD &= ~0x40;      // Disable Watchdog timer
}
#endif

/**
  * @brief  Configure system clock to run at 16Mhz
  * @param  None
  * @retval None
  */
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
  UART(Init(UART_BAUDRATE, UART(WORDLENGTH), UART(STOPBITS), UART(PARITY,
                   UART(SYNCMODE), UART(MODE)));

  /*
   * Enable the UART Receive interrupt: this interrupt is generated when the UART
   * receive data register is not empty
   *
   * Not used in this application - UART sending only.
   *
   * UART(ITConfig(UART(IT_RXNE_OR), ENABLE));
   */

  /* Enable the UART Transmit complete interrupt: this interrupt is generated
     when the UART transmit Shift Register is empty */
  UART(ITConfig(UART(IT_TXE), ENABLE));

  /* Enable UART */
  UART(Cmd(ENABLE));

    /* Enable general interrupts */
  enableInterrupts();
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
   * - PB4 connects to 4463 GPIO0; goes high once power on reset is done
   * - PC3 connects to 4463 GPIO1; goes high for CTS (can send over SPI)
   * - PC4 receives an interrupt signal from the 4463; goes low on interrupt
   */
  GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
  GPIO_Init(GPIOC, GPIO_PIN_4, GPIO_MODE_IN_PU_IT);
  GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_IN_FL_NO_IT);
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
