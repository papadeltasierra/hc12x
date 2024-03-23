   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.1 - 31 Jan 2024
   3                     ; Generator (Limited) V4.6.1 - 31 Jan 2024
  56                     ; 7 char putchar (char c)
  56                     ; 8 {
  58                     	switch	.text
  59  0000               _putchar:
  61  0000 88            	push	a
  62       00000000      OFST:	set	0
  65                     ; 10   UART1_SendData8(c);
  67  0001 cd0000        	call	_UART1_SendData8
  70  0004               L13:
  71                     ; 12   while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
  73  0004 ae0080        	ldw	x,#128
  74  0007 cd0000        	call	_UART1_GetFlagStatus
  76  000a 4d            	tnz	a
  77  000b 27f7          	jreq	L13
  78                     ; 14   return (c);
  80  000d 7b01          	ld	a,(OFST+1,sp)
  83  000f 5b01          	addw	sp,#1
  84  0011 81            	ret
 120                     ; 22 char getchar (void)
 120                     ; 23 {
 121                     	switch	.text
 122  0012               _getchar:
 124  0012 88            	push	a
 125       00000001      OFST:	set	1
 128                     ; 24   char c = 0;
 131  0013               L55:
 132                     ; 26   while (UART1_GetFlagStatus(UART1_FLAG_RXNE) == RESET);
 134  0013 ae0020        	ldw	x,#32
 135  0016 cd0000        	call	_UART1_GetFlagStatus
 137  0019 4d            	tnz	a
 138  001a 27f7          	jreq	L55
 139                     ; 27     c = UART1_ReceiveData8();
 141  001c cd0000        	call	_UART1_ReceiveData8
 143  001f 6b01          	ld	(OFST+0,sp),a
 145                     ; 28   return (c);
 147  0021 7b01          	ld	a,(OFST+0,sp)
 150  0023 5b01          	addw	sp,#1
 151  0025 81            	ret
 187                     ; 32 void printf(char *string)
 187                     ; 33 {
 188                     	switch	.text
 189  0026               _printf:
 191  0026 89            	pushw	x
 192       00000000      OFST:	set	0
 195  0027 200c          	jra	L101
 196  0029               L77:
 197                     ; 36         putchar(*string);
 199  0029 1e01          	ldw	x,(OFST+1,sp)
 200  002b f6            	ld	a,(x)
 201  002c add2          	call	_putchar
 203                     ; 37         string++;
 205  002e 1e01          	ldw	x,(OFST+1,sp)
 206  0030 1c0001        	addw	x,#1
 207  0033 1f01          	ldw	(OFST+1,sp),x
 208  0035               L101:
 209                     ; 34     while (*string)
 211  0035 1e01          	ldw	x,(OFST+1,sp)
 212  0037 7d            	tnz	(x)
 213  0038 26ef          	jrne	L77
 214                     ; 39 }
 217  003a 85            	popw	x
 218  003b 81            	ret
 231                     	xdef	_printf
 232                     	xdef	_getchar
 233                     	xdef	_putchar
 234                     	xref	_UART1_GetFlagStatus
 235                     	xref	_UART1_SendData8
 236                     	xref	_UART1_ReceiveData8
 255                     	end
