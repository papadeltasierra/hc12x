/**
  ******************************************************************************
  * File main.c
  * Description: Example of implementation of user bootloader (for Application Note AN2659)
  * Author: STMicroelectronics - MCD Prague Application Team
  * Version V2.0.0
  * Date 25/11/2010
  * Product: STM8S
  ******************************************************************************
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * COPYRIGHT 2008 STMicroelectronics
  ******************************************************************************
  */

//#pragma SRC is required for assembler code with raisonance
#pragma SRC
#include "main.h"
#ifdef _RAISONANCE_
//needed by memcpy for raisonance
#include <string.h>
extern int __address__Mem_ProgramBlock;
extern int __size__Mem_ProgramBlock;
#endif /*_RAISONANCE_*/


//typedef FAR void (*)(void) TFunction;
typedef void ( *TFunction)(void);
typedef enum {
     FLASH_MEMTYPE_PROG      = (u8)0x00,
     FLASH_MEMTYPE_DATA      = (u8)0x01
} FLASH_MemType_TypeDef;


//main application code (user reset) - init user code start - to interrupt table reset jump
const TFunction MainUserApplication = (TFunction)MAIN_USER_RESET_ADDR;
//address for GO command
TFunction GoAddress;

//Declare input buffer and its pointer
u8 DataBuffer[130];
u8 *ReceivedData;
//Declare loaded into RAM
u8 RoutinesInRAM = 0;

#ifdef _COSMIC_
int _fctcpy(char name);
#endif /* _COSMIC*/

void main(void);
void ProcessCommands(void);
u8 GT_Command_Process(void);
u8 RM_Command_Process(void);
u8 WM_Command_Process(void);
u8 GO_Command_Process(void);
u8 CheckTimeout(void);
u8 WriteBuffer(u8 FAR* DataAddress, u8 DataCount);
u8 WriteBufferFlash(u8 FAR* DataAddress, u8 DataCount, FLASH_MemType_TypeDef MemType);
void DeInitBootloader(void);
void protocol_init(void);
u8 Master_ident(u8 IDENT_byte);
void Transmit(u8 Data);
u8 Receive(u8* ReceivedData);
u8 ReceiveAddress(void);
u8 ReceiveCount(u8 max, u8 enablechecksum);
void unlock_PROG(void);
void unlock_DATA(void);
void FLASH_ProgramOptionByte(u16 Address, u8 Data);
void Mem_ProgramBlock(u16 BlockNum, FLASH_MemType_TypeDef MemType, u8 *Buffer);
u32 CLK_GetClockFreq(void);

//**************************************************************************
void main(void){
  sim();               // disable interrupts
  RoutinesInRAM = 0;

  // Set GPIO for bootloader Pin status detection
  BL_ENABLE_PORT->DDR &= ~0x20; 	  // BL ENABLE as Input
	BL_ENABLE_PORT->CR1 |= 0x20; 		// BL ENABLE as Pull Up
	BL_ENABLE_PORT->CR2 &= ~0x20;	  // no external interrupt

	// Detect if bootloader is enabled (pin in high state)
	if( (BL_ENABLE_PORT->IDR & 0x20) == 0x20 )
  {
    //if user application is not virgin - valid reset vector jump
    if((*((u8 FAR*)MainUserApplication)==0x82) || (*((u8 FAR*)MainUserApplication)==0xAC))
    {
      //De-init PortD bootloader detection
			BL_ENABLE_PORT->ODR=0x00;
			BL_ENABLE_PORT->DDR=0x00;
			BL_ENABLE_PORT->CR1=0x00;
			BL_ENABLE_PORT->CR2=0x00;
      //reset stack pointer (lower byte - because compiler decreases SP with some bytes)
#ifdef _COSMIC_
 _asm("LDW X,  SP ");
 _asm("LD  A,  $FF");
 _asm("LD  XL, A  ");
 _asm("LDW SP, X  ");
 _asm("JPF $9000");
#elif defined  _IAR_
 asm("LDW X,  SP ");
 asm("LD  A,  $FF");
 asm("LD  XL, A  ");
 asm("LDW SP, X  ");
 asm("JPF $9000");
#else /*_RAISONANCE_*/
#pragma ASM
 LDW X,SP
 LD A,0FFH
 LD XL,A
 LDW SP,X
 JPF 09000H
#pragma ENDASM
#endif
    }
  }

  //Else start bootloader itself

	//De-init PortD bootloader detection
	BL_ENABLE_PORT->ODR=0x00;
	BL_ENABLE_PORT->DDR=0x00;
	BL_ENABLE_PORT->CR1=0x00;
	BL_ENABLE_PORT->CR2=0x00;

  /* Set High speed internal clock prescaler */
  CLK->CKDIVR = 0x00;

  /* initialisation of selected protocol peripheral	*/
  protocol_init();

  //wait for identification
  if(!Master_ident(IDENT))
  {
		Transmit(NACK);
		//identification FAILED
    DeInitBootloader();     // then set back all microcontroller changes to reset values
    //reset stack pointer (lower byte - because compiler decreases SP with some bytes)
#ifdef _COSMIC_
 _asm("LDW X,  SP ");
 _asm("LD  A,  $FF");
 _asm("LD  XL, A  ");
 _asm("LDW SP, X  ");
 _asm("JPF $9000");
#elif defined _IAR_
 asm("LDW X,  SP ");
 asm("LD  A,  $FF");
 asm("LD  XL, A  ");
 asm("LDW SP, X  ");
 asm("JPF $9000");
#else /*_RAISONANCE_*/
#pragma ASM
 LDW X,SP
 LD A,0FFH
 LD XL,A
 LDW SP,X
 JPF 09000H
#pragma ENDASM
#endif
  }
  //identification SUCESS - copy routines to RAM
#ifdef _COSMIC_
  _fctcpy('F');
#endif /*_COSMIC_*/
#ifdef _RAISONANCE_
 memcpy(Mem_ProgramBlock,
 (void *)&__address__Mem_ProgramBlock,
 (int)&__size__Mem_ProgramBlock);
#endif /*_RAISONANCE_*/
  RoutinesInRAM = 1;
  unlock_PROG();
	unlock_DATA();
	//send ACK to host
  Transmit(ACK);
  do
  {
    //process commands from host
    ProcessCommands();

    //received GO command - set back all microcontroller changes to reset values
    DeInitBootloader();

    //jump to GO address
    GoAddress();
  }while (1);

}//main

void ProcessCommands(void){
  u8 result;
  u8 wait;
  u8 command;
	do
  {
		wait = 8;
		while(wait)
			wait --;
    //init pointer
    ReceivedData = DataBuffer;

    //receive data 1-st byte
    if(!Receive(ReceivedData++))
      continue;

    //receive data 2-nd byte
    if(!Receive(ReceivedData++))
      continue;

    //check if command bytes are complements
    if(DataBuffer[N_COMMAND] != (u8)(~DataBuffer[N_NEG_COMMAND]))
    {
      Transmit(NACK);
      continue;
    }

    //parse commands
    Transmit(ACK);
    command = DataBuffer[0];
    switch(DataBuffer[0])
    {
      case (GT_Command): result = GT_Command_Process(); break;
      case (RM_Command): result = RM_Command_Process(); break;
      case (GO_Command): result = GO_Command_Process(); break;
      case (WM_Command): result = WM_Command_Process(); break;
    }
  }while( (!result) || (command != GO_Command) ); //until GO command received
}//ProcessCommands

u8 GT_Command_Process(void){
  //send bytes number (Version+commands)=N
  Transmit(Num_GT_Command);

  //Send the BL Version Number
  Transmit(Version_Number);

  //Send GET command
  Transmit(GT_Command);

  //Send Read Memory command
  Transmit(RM_Command);

  //Send GO command
  Transmit(GO_Command);

  //Send Write Memory command
  Transmit(WM_Command);

  //Send Erase Memory command
  Transmit(EM_Command);

  //Send Erase Memory command
  Transmit(ACK);

  return 1;
}//GT_Command

u8 RM_Command_Process(void){
  u8 i;
	u8 FAR* DataAddress;
  u8 Checksum;
  //receive address
  if(!ReceiveAddress())
  {
    Transmit(NACK);// if not valid - NACK
    return 0;
  }

  //update address to read from
  DataAddress = *(u8 FAR**)(&DataBuffer[N_ADDR_3]);

  //receive count
  if(!ReceiveCount(0xFF, 1))
  {
    Transmit(NACK);// if not valid - NACK
    return 0;
  }

  //send data
  Checksum = 0;
  for(i=0; i<=DataBuffer[N_DATACOUNT]; i++)
  {
    Checksum ^= DataAddress[i];
    Transmit(DataAddress[i]);
  }
  return 1;
}//RM_Command

u8 GO_Command_Process(void){
	u32 Address32;
	u16 Address16;
  //receive address
  if(!ReceiveAddress())
  {
    Transmit(NACK);// if not valid - NACK
    return 0;
  }
  //update GO address
  Address32 = *(u32*)(&DataBuffer[N_ADDR_3]);
	Address16 = (u16)(Address32 >> 8);
  GoAddress = (TFunction)Address16;
  return 1;
}//GO_Command

u8 WM_Command_Process(void){
  u8 i;
	u8 FAR* DataAddress;
  u8 Checksum;
  u8 DataCount;
  u8 ChecksumByte;
  int ierror = 0;

  //receive address
  if(!ReceiveAddress())
  {
    Transmit(NACK);// if not valid - NACK
    return 0;
  }

  //update address to write to
  DataAddress = *(u8 FAR**)(&DataBuffer[N_ADDR_3]);

  //receive count
   if(!ReceiveCount(BLOCK_SIZE-1, 0))
  {
    Transmit(NACK);// if not valid - NACK
    return 0;
  }

  //receive data
  DataCount = DataBuffer[N_DATACOUNT]; // init count
  Checksum = DataCount;                //init checksum
  for(i=0; i<=DataCount; i++)
  {
    if(!Receive(&DataBuffer[i]))
		{
      ierror = 1;
		}
		//calculate checksum from received bytes
    Checksum ^= DataBuffer[i];
  }

  //receive checksum byte
  if(!Receive(&ChecksumByte))
  {
		ierror = 1;
	}
	//check checksum
  if(ChecksumByte != Checksum)
	{
    ierror = 1;
  }
  //if some error occured during data reception
  if (ierror == 1)
  {
    Transmit(NACK); //send error
    return 0;
  }

  //write buffer to memory
  if (!WriteBuffer(DataAddress, DataCount+1))
  {
    Transmit(NACK); //send error
    return 0;
  }
  //confirm correct writing
  Transmit(ACK);
  return 1;
}//WM_Command

u8 CheckAddress(u32 DataAddress){
  //for Flash
  if ((DataAddress >= FLASH_START) && (DataAddress <= FLASH_END))
    return 1;
  else
    //for EEPROM
    if ((DataAddress >= EEPROM_START) && (DataAddress <= EEPROM_END))
      return 1;
    else
      //for RAM
      if ((DataAddress >= RAM_START) && (DataAddress <= RAM_END))
        return 1;
      else
        //for Option bytes
        if ((DataAddress >= OPTION_START) && (DataAddress <= OPTION_END))
          return 1;
  return 0;
}//CheckAddress

u8 WriteBuffer(u8 FAR* DataAddress, u8 DataCount){
  u8 i;

  //for Flash
  if (((u32)DataAddress >= FLASH_START) && (((u32)DataAddress + DataCount - 1) <= FLASH_END))
    return WriteBufferFlash(DataAddress, DataCount, FLASH_MEMTYPE_PROG);

  //for EEPROM
  if (((u32)DataAddress >= EEPROM_START) && (((u32)DataAddress + DataCount - 1) <= EEPROM_END))
    return WriteBufferFlash(DataAddress, DataCount, FLASH_MEMTYPE_DATA);

  //for RAM
  if (((u32)DataAddress >= RAM_START) && (((u32)DataAddress + DataCount - 1) <= RAM_END))
  {
    for(i=0; i<DataCount; i++)
      DataAddress[i] = DataBuffer[i];
    return 1;
  }

  //for Option bytes
  if (((u32)DataAddress >= OPTION_START) && (((u32)DataAddress + DataCount - 1) <= OPTION_END))
  {
    for(i=0; i<DataCount; i++)
    {
       FLASH_ProgramOptionByte((u32)(&DataAddress[i]), DataBuffer[i]);
    }
    return 1;
  }

  //otherwise fail
  return 0;
}//WriteBuffer

u8 WriteBufferFlash(u8 FAR* DataAddress, u8 DataCount, FLASH_MemType_TypeDef MemType){
  u32 Address = (u32) DataAddress;
  u8 * DataPointer = DataBuffer;
  u32 Offset;
  //set offset according memory type
  if(MemType == FLASH_MEMTYPE_PROG)
    Offset = FLASH_START;
  else
    Offset = EEPROM_START;
  //program beginning bytes before words
  while((Address % 4) && (DataCount))
  {
    *((PointerAttr u8*) Address) = *DataPointer;
		while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
		Address++;
    DataPointer++;
    DataCount--;
	}
  //program beginning words before blocks
	while((Address % BLOCK_BYTES) && (DataCount >= 4))
  {
		FLASH->CR2 |= (u8)0x40;
		FLASH->NCR2 &= (u8)~0x40;
		*((PointerAttr u8*)Address) = (u8)*DataPointer  ; 	 /* Write one byte - from lowest address*/
		*((PointerAttr u8*)(Address + 1)) = *(DataPointer + 1); /* Write one byte*/
		*((PointerAttr u8*)(Address + 2)) = *(DataPointer + 2); /* Write one byte*/
		*((PointerAttr u8*)(Address + 3)) = *(DataPointer + 3); /* Write one byte - from higher address*/
    while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
		Address    += 4;
    DataPointer+= 4;
    DataCount  -= 4;
  }
  //program blocks
  while(DataCount >= BLOCK_BYTES)
  {
    Mem_ProgramBlock((Address - Offset)/BLOCK_BYTES, MemType, DataPointer);
    Address    += BLOCK_BYTES;
    DataPointer+= BLOCK_BYTES;
    DataCount  -= BLOCK_BYTES;
  }

  //program remaining words (after blocks)
  while(DataCount >= 4)
  {
		FLASH->CR2 |= (u8)0x40;
		FLASH->NCR2 &= (u8)~0x40;
		*((PointerAttr u8*)Address) = (u8)*DataPointer  ; 	 /* Write one byte - from lowest address*/
		*((PointerAttr u8*)(Address + 1)) = *(DataPointer + 1); /* Write one byte*/
		*((PointerAttr u8*)(Address + 2)) = *(DataPointer + 2); /* Write one byte*/
		*((PointerAttr u8*)(Address + 3)) = *(DataPointer + 3); /* Write one byte - from higher address*/
    while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
		Address    += 4;
    DataPointer+= 4;
    DataCount  -= 4;
  }

  //program remaining bytes (after words)
  while(DataCount)
  {
    *((PointerAttr u8*) Address) = *DataPointer;
    while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
		Address++;
    DataPointer++;
    DataCount--;
  }

  return 1;
}//WriteBufferFlash

void DeInitBootloader(void){
  if(RoutinesInRAM)
  {
    /* Lock program memory */
    FLASH->IAPSR = ~0x02;
    /* Lock data memory */
    FLASH->IAPSR = ~0x08;
  }

  /* DeInit I2C */
	I2C->CR1 = 0x00;
  I2C->CR2 = 0x00;
  I2C->FREQR = 0x00;
  I2C->OARL = 0x00;
  I2C->OARH = 0x00;
  I2C->ITR = 0x00;
  I2C->CCRL = 0x00;
  I2C->CCRH = 0x00;
  I2C->TRISER = 0x02;

}//DeInitBootloader

void protocol_init (void) {

	#ifdef I2C_protocol
	/* --------------  Initialize the I2C peripheral ------------- */

	I2C->FREQR = 16; 										  // Write new value (16MHz)
  I2C->CR1 = 0x01;											// Enable I2C peripheral
	I2C->CR2 = 0x04;						          // Enable I2C acknowledgement
  I2C->OARL = 0xa2;
  I2C->OARH = 0x40;
  #endif
	#ifdef SPI_Protocol
	/* --------------  Initialize the SPI peripheral ------------- */

	/* Initialize SPI in Slave mode (for IAP-SPI programming) */
  /*FIRST_BIT_MSB*/
	/*PRESCALER=2*/
  /*CLOCKPOLARITY_LOW*/
  /*CLOCKPHASE_1EDGE*/
	/*SLAVE MODE*/

    SPI->CR1 = (u8)0x00;
		/* Data direction configuration: Fullduplex NSS_HARD */
    SPI->CR2 = (u8)0x00;
	  /* CRC polynomial configuration  */
    SPI->CRCPR = (u8)0X07;
		/* Enable the SPI peripheral*/
		SPI->CR1 |= 0x40;
	#endif /*SPI init end*/
	#ifdef UART1_Protocol
	/* --------------  Initialize the UART peripheral ---------------- */

		u32 BaudRate_Mantissa, BaudRate_Mantissa100 = 0;

		/* Set Rx/Tx for UART uses*/

		/* Pull-Up */
    BL_ENABLE_PORT->CR1 |= (u8)0x40;
		GPIOC->CR1 |= (u8)0x02;

		/* UART1 Enable */
		UART1->CR1 &= (u8)(~0x20);

		/* Set 9bit data + Parity Control bit with Even parity */
    UART1->CR1 |= (u8)  0x14;

		/* UART RXTX enable */
		UART1->CR2 |= (u8)  0x0C;

		//Force BR to 9600
    UART1->BRR2 = 0x02;
		UART1->BRR1 = 0x68;

  #endif
	#ifdef UART2_Protocol
	/* --------------  Initialize the UART peripheral ---------------- */

		u32 BaudRate_Mantissa, BaudRate_Mantissa100 = 0;

		/* Set Rx/Tx for UART2 uses*/

		/* Pull-Up */
    BL_ENABLE_PORT->CR1 |= (u8)0x40;
		GPIOC->CR1 |= (u8)0x02;

		/* UART2 Enable */
		UART2->CR1 &= (u8)(~0x20);

		/* Set 9bit data + Parity Control bit with Even parity */
    UART2->CR1 |= (u8)  0x14;

		/* UART RXTX enable */
		UART2->CR2 |= (u8)  0x0C;

		//Force BR to 9600
    UART2->BRR2 = 0x02;
		UART2->BRR1 = 0x68;

  #endif
	#ifdef UART3_Protocol
	/* --------------  Initialize the UART peripheral ---------------- */

		/* Set Rx/Tx for UART3 uses*/

		/* Pull-Up */
    BL_ENABLE_PORT->CR1 |= (u8)0x40;
		GPIOC->CR1 |= (u8)0x02;

		/* UART3 Enable */
		UART3->CR1 &= (u8)(~0x20);

		/* Set 9bit data + Parity Control bit with Even parity */
    UART3->CR1 |= (u8)  0x14;

		/* UART RXTX enable */
		UART3->CR2 |= (u8)  0x0C;

		//Force BR to 9600
    UART3->BRR2 = 0x02;
		UART3->BRR1 = 0x68;
  #endif
}

void Transmit(u8 Data){
	#ifdef SPI_Protocol
		u8 sr;						// working copy of SPI_SR register
	#endif
	#if defined(UART1_Protocol) || defined(UART2_Protocol) || defined(UART3_Protocol)
    u8 sr;
	#endif
	#ifdef I2C_protocol
		u8 sr1;						// working copy of I2C_SR1
		u8 sr3;						// working copy of I2C_SR3

		//Wait for Slave address Match
		sr1 = I2C->SR1;
		while(!(sr1 & 0x02/*ADDR*/)) sr1 = I2C->SR1;
		//Clear Address matched Flag
		sr3 = I2C->SR3;
		sr1 = I2C->SR1;

		//Wait for TX buffer empty
		while(!(sr1 & 0x80/*TxE*/)) sr1 = I2C->SR1;
		//write Data in I2C data register
		I2C->DR = Data ;
	#endif
	#ifdef SPI_Protocol
	  sr = SPI->SR;
	  SPI->DR = Data ; /* Write in the DR register the data to be sent*/
		while(!(sr & 0x01/*RxNE*/)) sr = SPI->SR;
		SPI->DR = 0x00;
	#endif
	#ifdef UART1_Protocol
	//wait for Tx empty
	sr = UART1->SR;
  while(!(sr & 0x80/*TxNE*/)) sr = UART1->SR;
  //send data
   UART1->DR = Data;
  //wait for transmission complete
  sr = UART1->SR;
  while(!(sr & 0x40/*TxNE*/)) sr = UART1->SR;
	#endif
	#ifdef UART2_Protocol
	//wait for Tx empty
	sr = UART2->SR;
  while(!(sr & 0x80/*TxNE*/)) sr = UART2->SR;
  //send data
   UART2->DR = Data;
  //wait for transmission complete
  sr = UART2->SR;
  while(!(sr & 0x40/*TxNE*/)) sr = UART2->SR;
	#endif
	#ifdef UART3_Protocol
	//wait for Tx empty
	sr = UART3->SR;
  while(!(sr & 0x80/*TxNE*/)) sr = UART3->SR;
  //send data
   UART3->DR = Data;
  //wait for transmission complete
  sr = UART3->SR;
  while(!(sr & 0x40/*TxNE*/)) sr = UART3->SR;
	#endif
}//Transmit

u8 Receive(u8* ReceivedData){

	#ifdef SPI_Protocol
		u8 sr;						// working copy of SPI_SR register
	#endif
	#if defined(UART1_Protocol) || defined(UART2_Protocol) || defined(UART3_Protocol)
		u8 sr;						// working copy of SPI_SR register
	#endif
	#ifdef I2C_protocol
		u8 sr1;						// working copy of I2C_SR1
		u8 sr2;						// working copy of I2C_SR2
		u8 sr3;						// working copy of I2C_SR3

		//Wait for Slave address Match
		sr1 = I2C->SR1;
		while(!(sr1 & 0x02/*ADDR*/)) sr1 = I2C->SR1;

		//Clear Address matched Flag
		sr3 = I2C->SR3;
		sr1 = I2C->SR1;

		//Wait for Data received
		while( !(sr1 & 0x40/*RDATA*/)) sr1 = I2C->SR1;

		//check if overrun or parity error
		sr2 = I2C->SR2;
		if((sr2 & 0x08/*OVR*/)||(sr2 & 0x02/*ARLO*/)||(sr2 & 0x01/*BERR*/))
		{
			//receive data to clear error
			* ReceivedData = (u8)I2C->DR;
			//send NACK to host
			Transmit(NACK);
			//and return error
			return 0;
		}
		//store received data
		* ReceivedData = (u8)I2C->DR ;
		sr1 = I2C->SR1;
		while(!(sr1 & 0x10/*STOPF*/)) sr1 = I2C->SR1 ;
		/* Clear STOP flag */
		sr1 = I2C->SR1;
		I2C->SR2 &= ~0x02 ; //Clear Stop
		return 1;
	#endif
	#ifdef SPI_Protocol
		//Wait for data received flag
		sr = SPI->SR;
		while(!(sr & 0x01/*RxNE*/)) sr = SPI->SR;
		//Clear flag
		sr = SPI->SR;
		* ReceivedData = SPI->DR;
		sr = SPI->SR;
	#endif
	#ifdef UART1_Protocol
  //wait for Rx full
	sr = UART1->SR;
  while(!(sr & 0x20 /*RXNE*/)) sr = UART1->SR ;
  //check if overrun or parity error
	if((sr & 0x08/*OR*/)||(sr & 0x01/*PE*/))
  {
    //receive data to clear error
    *ReceivedData = UART1->DR ;
    //send NACK to host
    Transmit(NACK);
    //and return error
    return 0;
  }
  //receive data
  *ReceivedData = UART1->DR;
  //and return no error
  return 1;

	#endif
	#ifdef UART2_Protocol
  //wait for Rx full
	sr = UART2->SR;
  while(!(sr & 0x20 /*RXNE*/)) sr = UART2->SR ;
  //check if overrun or parity error
	if((sr & 0x08/*OR*/)||(sr & 0x01/*PE*/))
  {
    //receive data to clear error
    *ReceivedData = UART2->DR ;
    //send NACK to host
    Transmit(NACK);
    //and return error
    return 0;
  }
  //receive data
  *ReceivedData = UART2->DR;
  //and return no error
  return 1;

	#endif
	#ifdef UART3_Protocol
  //wait for Rx full
	sr = UART3->SR;
  while(!(sr & 0x20 /*RXNE*/)) sr = UART3->SR ;
  //check if overrun or parity error
	if((sr & 0x08/*OR*/)||(sr & 0x01/*PE*/))
  {
    //receive data to clear error
    *ReceivedData = UART3->DR ;
    //send NACK to host
    Transmit(NACK);
    //and return error
    return 0;
  }
  //receive data
  *ReceivedData = UART3->DR;
  //and return no error
  return 1;

	#endif
}//Receive

u8 Master_ident(u8 IDENT_byte){
	u8 master_ident;
	Receive(&master_ident);
  if (master_ident == IDENT_byte)
	{
		return 1;
  }
	return 0;
}//Master_ident

u8 ReceiveAddress(void){
  u8 result = 1;

  //receive address (4 bytes : Byte3: MSB , Byte6: LSB)
  if(!Receive(ReceivedData++))
    result = 0;
  if(!Receive(ReceivedData++))
    result = 0;
  if(!Receive(ReceivedData++))
    result = 0;
  if(!Receive(ReceivedData++))
    result = 0;

  //receive checksum (from 4 bytes : Byte3: MSB - Byte6: LSB)
  if(!Receive(ReceivedData++))
    result = 0;

  //check checksum
  if(*(--ReceivedData) ^ *(--ReceivedData) ^ *(--ReceivedData) ^ *(--ReceivedData) ^ *(--ReceivedData))
    result = 0;
  //set back data pointer
  ReceivedData += 5;

  //check if address is valid
  //if(!CheckAddress(*((u32*) &DataBuffer[N_ADDR_4]) ))
    //result = 0;

  //if some error occured
  if (!result)
    return 0;

  //confirm correct reception
  Transmit(ACK);
  return 1;
}//ReceiveAddress

u8 ReceiveCount(u8 max, u8 enablechecksum){
  bool result = 1;

  //receive count
  if(!Receive(ReceivedData))
    result = 0;

  //check maximum value
  if(!((*ReceivedData++) <= max))
    result = 0;


 //receive checksum if enabled
  if (enablechecksum)
  {
    //receive checksum
    if(!Receive(ReceivedData++))
      result = 0;

    //check checksum
    if((*(--ReceivedData) ^ *(--ReceivedData)) != 0xFF)
      result = 0;
    //set back data pointer
    ReceivedData += 2;
  }

	//confirm correct reception - if required
  if (enablechecksum)
    Transmit(ACK);

  return result;
}//ReceiveCount

void unlock_PROG(void){
  //Unlock PROG memory
  FLASH->PUKR = 0x56;
  FLASH->PUKR = 0xAE;
  }

void unlock_DATA(void) {
 //Unlock DATA memory
	FLASH->DUKR = 0xAE; /* Warning: keys are reversed on data memory !!! */
  FLASH->DUKR = 0x56;
}
#ifdef _COSMIC_
#pragma section (FLASH_CODE)
#endif /* _COSMIC */

#ifdef _IAR_
#pragma location = "FLASH_CODE"
#endif /* _IAR_ */

#ifdef _RAISONANCE_
void Mem_ProgramBlock(u16 BlockNum, FLASH_MemType_TypeDef MemType, u8 *Buffer) inram
#else
void Mem_ProgramBlock(u16 BlockNum, FLASH_MemType_TypeDef MemType, u8 *Buffer)
#endif /*_RAISONANCE_*/
{
    u16 Count = 0;
    u32 StartAddress = 0;
    u16 timeout = (u16)0x6000;

 /* Set Start address wich refers to mem_type */
    if (MemType == FLASH_MEMTYPE_PROG)
    {
        StartAddress = FLASH_START;
    }
    else
    {
        StartAddress = EEPROM_START;
    }

    /* Point to the first block address */
    StartAddress = StartAddress + ((u32)BlockNum * BLOCK_SIZE);

    /* Standard programming mode */
    FLASH->CR2 |= (u8)0x01;
    FLASH->NCR2 &= (u8)~0x01;

    /* Copy data bytes from RAM to FLASH memory */
    for (Count = 0; Count < BLOCK_SIZE; Count++)
    {
        *((PointerAttr u8*)StartAddress + Count) = ((u8)(Buffer[Count]));
    }

 #if defined (STM8S208) || defined(STM8S207) || defined(STM8S105)
    if (MemType == FLASH_MEMTYPE_DATA)
    {
        /* Waiting until High voltage flag is cleared*/
        while ((FLASH->IAPSR & 0x40) != 0x00 || (timeout == 0x00))
        {
            timeout--;
        }
    }
 #endif /* STM8S208, STM8S207, STM8S105 */
}

#ifdef _COSMIC_
#pragma section ()
#endif /* __COSMIC__ */

void FLASH_ProgramOptionByte(u16 Address, u8 Data){
	u8 flash_iapsr;
  /* Enable write access to option bytes */
  FLASH->CR2 |= (u8)0x80;
  FLASH->NCR2 &= (u8)(~0x80);

  /* Program option byte and his complement */
  *((NEAR u8*)Address) = Data;
  *((NEAR u8*)(Address + 1)) = (u8)(~Data);

	#if defined (STM8S208) || defined(STM8S207) || defined(STM8S105)
	  flash_iapsr = FLASH->IAPSR ;
		while (!(flash_iapsr & 0x41)) flash_iapsr = FLASH->IAPSR ;
	#else /*STM8S103, STM8S903*/
	  flash_iapsr = FLASH->IAPSR ;
		while (!(flash_iapsr & 0x05)) flash_iapsr = FLASH->IAPSR ;
	#endif /* STM8S208, STM8S207, STM8S105 */

  /* Disable write access to option bytes */
  FLASH->CR2 &= (u8)(~0x80);
  FLASH->NCR2 |= (u8)0x80;
}


u32 CLK_GetClockFreq(void)
{
	uc8 HSIDivFactor[4] = {1, 2, 4, 8}; /* Holds the different HSI Dividor factors */
	u32 clockfrequency = 0;
	u8 tmp = 0, presc = 0;
	tmp = (u8)(CLK->CKDIVR & 0x18);
	tmp = (u8)(tmp >> 3);
	presc = HSIDivFactor[tmp];
	clockfrequency = 16000000 / presc;
	return((u32)clockfrequency);
}
//**************************************************************************

