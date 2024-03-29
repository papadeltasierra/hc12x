   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.1 - 31 Jan 2024
   3                     ; Generator (Limited) V4.6.1 - 31 Jan 2024
  57                     ; 7 char putchar (char c)
  57                     ; 8 {
  59                     .text:	section	.text,new
  60  0000               _putchar:
  62  0000 88            	push	a
  63       00000000      OFST:	set	0
  66                     ; 10   UART1_SendData8(c);
  68  0001 cd0000        	call	_UART1_SendData8
  71  0004               L13:
  72                     ; 12   while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
  74  0004 ae0080        	ldw	x,#128
  75  0007 cd0000        	call	_UART1_GetFlagStatus
  77  000a 4d            	tnz	a
  78  000b 27f7          	jreq	L13
  79                     ; 14   return (c);
  81  000d 7b01          	ld	a,(OFST+1,sp)
  84  000f 5b01          	addw	sp,#1
  85  0011 81            	ret
 121                     ; 22 char getchar (void)
 121                     ; 23 {
 122                     .text:	section	.text,new
 123  0000               _getchar:
 125  0000 88            	push	a
 126       00000001      OFST:	set	1
 129                     ; 24   char c = 0;
 132  0001               L55:
 133                     ; 26   while (UART1_GetFlagStatus(UART1_FLAG_RXNE) == RESET);
 135  0001 ae0020        	ldw	x,#32
 136  0004 cd0000        	call	_UART1_GetFlagStatus
 138  0007 4d            	tnz	a
 139  0008 27f7          	jreq	L55
 140                     ; 27     c = UART1_ReceiveData8();
 142  000a cd0000        	call	_UART1_ReceiveData8
 144  000d 6b01          	ld	(OFST+0,sp),a
 146                     ; 28   return (c);
 148  000f 7b01          	ld	a,(OFST+0,sp)
 151  0011 5b01          	addw	sp,#1
 152  0013 81            	ret
 188                     ; 32 void printf(char *string)
 188                     ; 33 {
 189                     .text:	section	.text,new
 190  0000               _printf:
 192  0000 89            	pushw	x
 193       00000000      OFST:	set	0
 196  0001 200d          	jra	L101
 197  0003               L77:
 198                     ; 36         putchar(*string);
 200  0003 1e01          	ldw	x,(OFST+1,sp)
 201  0005 f6            	ld	a,(x)
 202  0006 cd0000        	call	_putchar
 204                     ; 37         string++;
 206  0009 1e01          	ldw	x,(OFST+1,sp)
 207  000b 1c0001        	addw	x,#1
 208  000e 1f01          	ldw	(OFST+1,sp),x
 209  0010               L101:
 210                     ; 34     while (*string)
 212  0010 1e01          	ldw	x,(OFST+1,sp)
 213  0012 7d            	tnz	(x)
 214  0013 26ee          	jrne	L77
 215                     ; 39 }
 218  0015 85            	popw	x
 219  0016 81            	ret
 232                     	xdef	_printf
 233                     	xdef	_getchar
 234                     	xdef	_putchar
 235                     	xref	_UART1_GetFlagStatus
 236                     	xref	_UART1_SendData8
 237                     	xref	_UART1_ReceiveData8
 256                     	end
