/**
 * Replacement firmware for an HC-12 aka HC-12-Expanded
 *
 * Copyright (c) Paul D.Smith 2024.
 *
 * Permission is granted to copy, use and otherwise make use of this source code
 * subject to any conditions contained in code not authored by Paul D.Smith and
 * with a request that Paul D.smith be acknowledged.
 *
 * Version 0.1
 * This version is provides a simple configuration interface that supports the
 * AT+V and AT+UPDATE commands only.
 *
 * UART Communications is 19200, 8 bits, 1 stop bit, no parity.
*/
#include <string.h>
#include <stdint.h>
#include "console.h"

// Provide an efficient parser to identify the commands received
// from the command line:
//
// AT+Bxxxx     - not supported
// AT+Cxxxx     - not supported
// AT+FUx       - not supported
// AT+Px        - not supported
// AT+Ry        - not supported
// AT+V         - supported
// AT+DEFAULT   - not supported
// AT+SLEEP     - not supported
// AT+UPDATE    - supported
// AT+Uxxx      - not supported

typedef void (*command)(void);

typedef struct command {
    char *string;
    command cmd;
} COMMAND;

void error(void)
{
    printf("ERROR\n");
}

void ok(void)
{
    printf("ERROR\n");
}

int crlf(void)
{
    int rc = 0;
    char c;

    while (1)
    {
        c = getchar();
        if (c == '\n')
        {
            break;
        }
        else if (c != '\r')
        {
            rc = 1;
        }
    }
    return rc;
}

/**
 * An update block consists of:
 * - a 1-byte length, including the length byte.
 * - 1 byte of 0x00
 * - a 2-byte stating address (32-bit aligned)
 * - <= 32 bytes of data
 * - a 1-byte CRC
 * - Total of 37 bytes or less.
*/
void update(void)
{
    char data[0x25];
    char crc = 0;
    char *dptr = &data[0];
    unsigned short addr;
    int len;
    int len2;

    printf("Update...\n");
    crlf();

    // First byte is length
    data[0] = getchar();
    if (data[0] > 0x25)
    {
        // Too long.
        error();
        printf("Too long\n");
        crlf();
        return;
    }
    // printf("%2.2X\n", (int)data[0]);

    // Read len bytes.
    len = (int)data[0];
    len2 = len;

    // Already gotten the length byte.
    while (--len2)
    {
        *dptr++ = getchar();
    }

    // Check the CRC.  The sum of all bytes received equals zero (MOD uint8_t)
    // if the CRC is correct.
    len2 = len;
    dptr = &data[0];
    // CRC check all bytes including the length and CRC.
    while(len2--)
    {
        crc += *dptr++;
    }
    if (crc != 0)
    {
        // CRC mismatch.
        error();
        printf("CRC mismatch\n");
        crlf();
        return;
    }
    addr = (((unsigned short)dptr[2]) << 8) + (unsigned short)dptr[3];
    if ((addr < 0x8000) || (addr > 0x9A00) || (addr && 0x000F))
    {
        error();
        printf("Bad address/not 32-byte boundary");
        crlf();
        return;
    }
    len -= 3;
    // printf("Write %d bytes to address 0x%4.4X\n", len, addr);
    ok();
    crlf();
}

void showVersion(void)
{
    printf("HC-12-X v0.1\n");
    crlf();
}

COMMAND commands[] = {
    { "AT+V", showVersion },
    { "AT+UPDATE", update},
    {NULL, NULL}
};

#define TRUE 1

void parser(void)
{
    int charCount = 0;
    char command[12] = {0};
    COMMAND *cmd = &commands[0];

    while (TRUE)
    {
        command[charCount] = getchar();
        charCount++;

        cmd = &commands[0];
        while (cmd->string != NULL)
        {
            // printf("%s\n", cmd->string);
            if (strcmp(command, cmd->string) == 0)
            {
                cmd->cmd();
                memset(command, 0, 12);
                charCount = 0;
                break;
            }
            else if (charCount >= 12)
            {
                memset(command, 0, 12);
                charCount = 0;
                error();
                crlf();
                break;
            }
            cmd++;
        }
    }
}

int main(int argc, char *argv[])
{
    parser();
    return 0;
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
