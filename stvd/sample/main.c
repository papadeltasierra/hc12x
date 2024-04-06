/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "stm8s.h"
#include "stm8s_uart_mapping.h"

#define UART_BAUDRATE 115200
#define UART_WORDLENGTH UART(WORDLENGTH_8D)
#define UART_STOPBITS UART(STOPBITS_1)
#define UART_PARITY UART(PARITY_EVEN)
#define UART_SYNCMODE UART(SYNCMODE_CLOCK_DISABLE)
#define UART_MODE UART(MODE_TXRX_ENABLE)

void printf(char *string)
{
	UART(Flag_TypeDef) flag_def = UART(FLAG_TXE);
	while ((*string) != 0)
	{
		UART(SendData9(*string++));
		/* Loop until the end of transmission */
		while (UART(GetFlagStatus(flag_def)) == RESET);
		continue;
	}
}

main()
{
  /*High speed internal clock prescaler: 1*/
  CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);

  UART2_Init(
		19200,
		UART2_WORDLENGTH_9D, 
		UART2_STOPBITS_1, 
		UART2_PARITY_EVEN,
		UART2_SYNCMODE_CLOCK_DISABLE, 
		UART2_MODE_TX_ENABLE);
	

	printf("Sample & bootloader installed successfully!\n");
	
	while (1);
}
#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif
