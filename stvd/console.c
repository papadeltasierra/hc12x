/**
 * Console emulations using the UART.
 */
#include "stm8s_uart1.h"
#include "console.h"

char putchar (char c)
{
  /* Write a character to the UART1 */
  UART1_SendData8(c);
  /* Loop until the end of transmission */
  while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);

  return (c);
}

/**
  * @brief Retargets the C library scanf function to the USART.
  * @param None
  * @retval char Character to Read
  */
char getchar (void)
{
  char c = 0;
  /* Loop until the Read data register flag is SET */
  while (UART1_GetFlagStatus(UART1_FLAG_RXNE) == RESET);
    c = UART1_ReceiveData8();
  return (c);
}

// Very minimal implementation!
void printf(char *string)
{
    while (*string)
    {
        putchar(*string);
        string++;
    }
}
