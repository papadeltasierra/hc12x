/**
  ******************************************************************************
  * @file main.h
  * @brief This file contains all definition for AN2659 user-Bootloader examples
  * @author STMicroelectronics - APG Application Team
  * @version V2.0.0
  * @date 25/11/2010
  ******************************************************************************
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2008 STMicroelectronics</center></h2>
  * @image html logo.bmp
  ******************************************************************************
  */


#include "stm8s.h"

/*********************************************************/
/*              USER BOOT CODE PROTOCOL PARAMETERS	     */
/*********************************************************/

/* Un-comment one of the listed protocol 								 */
/* Only one protocol can be selected for the UBC 			   */
/* application																					 */

/* #define I2C_protocol */
/* #define SPI_Protocol */
#ifdef STM8SB003
#define UART1_Protocol
#elif defined(STM8S105)
#define UART2_Protocol
#endif
/* #define UART3_Protocol */

/*********************************************************/
/*              USER BOOT CODE Customisation 	     			 */
/*********************************************************/

// user application start (user interrupt table address; This has to be the
// address of the BOOTLOADER table not the application.
#define MAIN_USER_RESET_ADDR 0x8200ul
#define MAIN_USER_APP_RESET_ADDR 0x8A00ul

// bootloader enable pin definition
/* #define BL_ENABLE_PORT  GPIOD */
/* #define BL_ENABLE_PIN   GPIO_PIN_2 */
#define BL_ENABLE_PORT  GPIOB
#define BL_ENABLE_PIN   GPIO_PIN_5

// I2C - Adress (only if I2C protocol used)
#ifdef I2C_protocol
	#define I2C_ADDR 0xA2
#endif


//ACK, NACK, SYNCHR bytes
#define ACK             0x79				/* 	hex Value send for acknowledge */
#define NACK            0x1F				/*  hex Value send for non-acknowledge */
#define IDENT           0x7F				/*  hex Value rfequired for master identification */

//commands numbers
#define  GT_Command           0x00   /* Get command */
#define  RM_Command           0x11   /* Read Memory command */
#define  GO_Command           0x21   /* Go command */
#define  WM_Command           0x31   /* Write Memory command */
#define  EM_Command           0x43   /* Erase Memory command */

//commands related parameters
#define  Version_Number       0x10   /* BL version number */
#define  Num_GT_Command       0x05   /* Indicates the number of bytes (Version+commands) */

//indexes used for received data buffer
#define  N_COMMAND            0
#define  N_NEG_COMMAND        1
#define  N_ADDR_4             2
#define  N_ADDR_3             3
#define  N_ADDR_2             4
#define  N_ADDR_1             5
#define  N_CHECKSUM           6
#define  N_DATACOUNT          7
#define  N_NEG_DATACOUNT      8



/*********************************************************/
/*              USER BOOT CODE MEMORY PARAMETERS	       */
/*********************************************************/

/* Parameters of this section depend of the used Microcontroler */
/* see microcontroler's data sheet for more information 				*/

/* According to UM0560, a SECTOR is always 1kB */
#ifdef AN2659
//mask for memory block boundary
#define  BLOCK_BYTES          128
#define  ADDRESS_BLOCK_MASK   127 	/*(BLOCK_BYTES - 1)*/

//memory boundaries
#define  RAM_START            0x000000ul
#define  RAM_END              0x0007FFul
#define  OPTION_START         0x004800ul
#define  OPTION_END           0x0048FFul
#define  UBC_OPTION_LOCATION  0x004801ul
#define  BLOCK_SIZE           0x80
#define  BLOCK_PER_SECTOR     0x08

#define  FLASH_START          0x008000ul
#define  FLASH_END            0x02FFFFul
#define  FLASH_BLOCKS_NUMBER  0x500 /*((FLASH_END  - FLASH_START  + 1)/BLOCK_SIZE)*/
#define  SECTORS_IN_FLASH     0xA0 /*((FLASH_END  - FLASH_START  + 1)/BLOCK_SIZE/BLOCK_PER_SECTOR)*/
#define  FLASH_CLEAR_BYTE     0xA5

#define  EEPROM_START         0x004000ul
#define  EEPROM_END           0x0043FFul
#define  EEPROM_BLOCKS_NUMBER 0x08 /*((EEPROM_END - EEPROM_START + 1)/BLOCK_SIZE)*/
#define  SECTORS_IN_EEPROM    0x01 /*((EEPROM_END - EEPROM_START + 1)/BLOCK_SIZE/BLOCK_PER_SECTOR)*/

#define  SECTORS_COUNT        0x21 /*(SECTORS_IN_FLASH + SECTORS_IN_EEPROM)*/
#define  MAX_SECTOR_NUMBER    0x20 /*(SECTORS_IN_FLASH + SECTORS_IN_EEPROM - 1)*/

#elif defined(STM8S003)
//mask for memory block boundary
#define  BLOCK_BYTES          128
#define  ADDRESS_BLOCK_MASK   127 	/*(BLOCK_BYTES - 1)*/

//memory boundaries
#define  RAM_START            0x000000ul
#define  RAM_END              0x0007FFul
#define  OPTION_START         0x004800ul
#define  OPTION_END           0x00480Aul
#define  UBC_OPTION_LOCATION  0x004801ul
#define  BLOCK_SIZE           0x40
#define  BLOCK_PER_SECTOR     0x08

#define  FLASH_START          0x008000ul
#define  FLASH_END            0x008FFFul
#define  FLASH_BLOCKS_NUMBER  0x40 /*((FLASH_END  - FLASH_START  + 1)/BLOCK_SIZE)*/
#define  SECTORS_IN_FLASH     0x08 /*((FLASH_END  - FLASH_START  + 1)/BLOCK_SIZE/BLOCK_PER_SECTOR)*/
#define  FLASH_CLEAR_BYTE     0xA5

#define  EEPROM_START         0x004000ul
#define  EEPROM_END           0x00407Ful
#define  EEPROM_BLOCKS_NUMBER 0x02 /*((EEPROM_END - EEPROM_START + 1)/BLOCK_SIZE)*/
#define  SECTORS_IN_EEPROM    0x00 /*((EEPROM_END - EEPROM_START + 1)/BLOCK_SIZE/BLOCK_PER_SECTOR)*/

#define  SECTORS_COUNT        0x08 /*(SECTORS_IN_FLASH + SECTORS_IN_EEPROM)*/
#define  MAX_SECTOR_NUMBER    0x07 /*(SECTORS_IN_FLASH + SECTORS_IN_EEPROM - 1)*/

#elif defined(STM8S105C6)
//mask for memory block boundary
#define  BLOCK_BYTES          128
#define  ADDRESS_BLOCK_MASK   127 	/*(BLOCK_BYTES - 1)*/

//memory boundaries
#define  RAM_START            0x000000ul
#define  RAM_END              0x0007FFul
#define  OPTION_START         0x004800ul
#define  OPTION_END           0x00487Ful
#define  UBC_OPTION_LOCATION  0x004801ul
#define  BLOCK_SIZE           0x40
#define  BLOCK_PER_SECTOR     0x08

#define  FLASH_START          0x008000ul
#define  FLASH_END            0x00FFFFul
#define  FLASH_BLOCKS_NUMBER  0x100 /*((FLASH_END  - FLASH_START  + 1)/BLOCK_SIZE)*/
#define  SECTORS_IN_FLASH     0x20 /*((FLASH_END  - FLASH_START  + 1)/BLOCK_SIZE/BLOCK_PER_SECTOR)*/
#define  FLASH_CLEAR_BYTE     0xA5

#define  EEPROM_START         0x004000ul
#define  EEPROM_END           0x0043FFul
#define  EEPROM_BLOCKS_NUMBER 0x08 /*((EEPROM_END - EEPROM_START + 1)/BLOCK_SIZE)*/
#define  SECTORS_IN_EEPROM    0x01 /*((EEPROM_END - EEPROM_START + 1)/BLOCK_SIZE/BLOCK_PER_SECTOR)*/

#define  SECTORS_COUNT        0x08 /*(SECTORS_IN_FLASH + SECTORS_IN_EEPROM)*/
#define  MAX_SECTOR_NUMBER    0x07 /*(SECTORS_IN_FLASH + SECTORS_IN_EEPROM - 1)*/
#endif
/* Exported types ------------------------------------------------------------*/


