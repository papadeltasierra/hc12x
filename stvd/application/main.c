/*
 * This is an example to prove that we manage to run the "firmware".
 */

#include "stm8s.h"

#ifdef STM8S105
#define UART1_Init UART2_Init
#define UART1_SendData8 UART2_SendData8
#define UART1_WORDLENGTH_8D UART2_WORDLENGTH_8D
#define UART1_PARITY_EVEN UART2_PARITY_EVEN
#define UART1_SYNCMODE_CLOCK_DISABLE UART2_SYNCMODE_CLOCK_DISABLE
#define UART1_MODE_TXRX_ENABLE UART2_MODE_TXRX_ENABLE
#define UART1_GetFlagStatus UART1_GetFlagStatus
#define UART1_FLAG_TXE UART2_FLAG_TXE
#endif

char putchar(char c)
{
  /* Write a character to the UART1 */
  UART1_SendData8(c);
  /* Loop until the end of transmission */
  while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);

  return (c);
}

int printf(char *s)
{
	while (*s != 0)
	{
		putchar(*s++);
	}
	return 0;
}

void main(void)
{
	UART1_Init(
		19200,
	 	UART1_WORDLENGTH_8D,
	 	UART1_STOPBITS_1,
		UART1_PARITY_EVEN,
		UART1_SYNCMODE_CLOCK_DISABLE,
		UART1_MODE_TXRX_ENABLE);
	printf("HC-12-X v0.0.1");
	while (1);
}