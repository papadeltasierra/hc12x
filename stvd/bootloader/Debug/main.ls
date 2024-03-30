   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.1 - 31 Jan 2024
   3                     ; Generator (Limited) V4.6.1 - 31 Jan 2024
  14                     .const:	section	.text
  15  0000               _MainUserApplication:
  16  0000 9000          	dc.w	-28672
  17                     	bsct
  18  0000               _RoutinesInRAM:
  19  0000 00            	dc.b	0
  62                     ; 79 void main(void){
  64                     	switch	.text
  65  0000               _main:
  69                     ; 80   sim();               // disable interrupts 
  72  0000 9b            sim
  74                     ; 81   RoutinesInRAM = 0;
  77  0001 3f00          	clr	_RoutinesInRAM
  78                     ; 84   GPIOD->DDR &= ~0x04; 	  // PD2 as Input 
  80  0003 72155011      	bres	20497,#2
  81                     ; 85 	GPIOD->CR1 |= 0x04; 		// PD2 as Pull Up
  83  0007 72145012      	bset	20498,#2
  84                     ; 86 	GPIOD->CR2 &= ~0x04;	  // no external interrupt
  86  000b 72155013      	bres	20499,#2
  87                     ; 89 	if( (GPIOD->IDR & 0x04) == 0x04 ) 
  89  000f c65010        	ld	a,20496
  90  0012 a404          	and	a,#4
  91  0014 a104          	cp	a,#4
  92  0016 2629          	jrne	L12
  93                     ; 92     if((*((u8 FAR*)MainUserApplication)==0x82) || (*((u8 FAR*)MainUserApplication)==0xAC))
  95  0018 bc009000      	ldf	a,36864
  96  001c a182          	cp	a,#130
  97  001e 2708          	jreq	L52
  99  0020 bc009000      	ldf	a,36864
 100  0024 a1ac          	cp	a,#172
 101  0026 2619          	jrne	L12
 102  0028               L52:
 103                     ; 95 			GPIOD->ODR=0x00;
 105  0028 725f500f      	clr	20495
 106                     ; 96 			GPIOD->DDR=0x00;
 108  002c 725f5011      	clr	20497
 109                     ; 97 			GPIOD->CR1=0x00;
 111  0030 725f5012      	clr	20498
 112                     ; 98 			GPIOD->CR2=0x00;			
 114  0034 725f5013      	clr	20499
 115                     ; 101  _asm("LDW X,  SP ");
 118  0038 96            LDW X,  SP 
 120                     ; 102  _asm("LD  A,  $FF");
 123  0039 b6ff          LD  A,  $FF
 125                     ; 103  _asm("LD  XL, A  ");
 128  003b 97            LD  XL, A  
 130                     ; 104  _asm("LDW SP, X  ");
 133  003c 94            LDW SP, X  
 135                     ; 105  _asm("JPF $9000");
 138  003d ac009000      JPF $9000
 140  0041               L12:
 141                     ; 127 	GPIOD->ODR=0x00;
 143  0041 725f500f      	clr	20495
 144                     ; 128 	GPIOD->DDR=0x00;
 146  0045 725f5011      	clr	20497
 147                     ; 129 	GPIOD->CR1=0x00;
 149  0049 725f5012      	clr	20498
 150                     ; 130 	GPIOD->CR2=0x00;
 152  004d 725f5013      	clr	20499
 153                     ; 133   CLK->CKDIVR = 0x00;
 155  0051 725f50c6      	clr	20678
 156                     ; 136   protocol_init();
 158  0055 cd067f        	call	_protocol_init
 160                     ; 139   if(!Master_ident(IDENT))  
 162  0058 a67f          	ld	a,#127
 163  005a cd0709        	call	_Master_ident
 165  005d 4d            	tnz	a
 166  005e 2611          	jrne	L72
 167                     ; 141 		Transmit(NACK);
 169  0060 a61f          	ld	a,#31
 170  0062 cd06a4        	call	_Transmit
 172                     ; 143     DeInitBootloader();     // then set back all microcontroller changes to reset values
 174  0065 cd064e        	call	_DeInitBootloader
 176                     ; 146  _asm("LDW X,  SP ");
 179  0068 96            LDW X,  SP 
 181                     ; 147  _asm("LD  A,  $FF");
 184  0069 b6ff          LD  A,  $FF
 186                     ; 148  _asm("LD  XL, A  ");
 189  006b 97            LD  XL, A  
 191                     ; 149  _asm("LDW SP, X  ");
 194  006c 94            LDW SP, X  
 196                     ; 150  _asm("JPF $9000");
 199  006d ac009000      JPF $9000
 201  0071               L72:
 202                     ; 169   _fctcpy('F');
 204  0071 a646          	ld	a,#70
 205  0073 cd0000        	call	__fctcpy
 207                     ; 176   RoutinesInRAM = 1;
 209  0076 35010000      	mov	_RoutinesInRAM,#1
 210                     ; 177   unlock_PROG();
 212  007a cd0821        	call	_unlock_PROG
 214                     ; 178 	unlock_DATA();
 216  007d cd082a        	call	_unlock_DATA
 218                     ; 180   Transmit(ACK);
 220  0080 a679          	ld	a,#121
 221  0082 cd06a4        	call	_Transmit
 223  0085               L13:
 224                     ; 184     ProcessCommands();
 226  0085 ad08          	call	_ProcessCommands
 228                     ; 187     DeInitBootloader();
 230  0087 cd064e        	call	_DeInitBootloader
 232                     ; 190     GoAddress();
 234  008a 92cd84        	call	[_GoAddress.w]
 237  008d 20f6          	jra	L13
 297                     ; 195 void ProcessCommands(void){
 298                     	switch	.text
 299  008f               _ProcessCommands:
 301  008f 5203          	subw	sp,#3
 302       00000003      OFST:	set	3
 305  0091               L37:
 306                     ; 201 		wait = 8;
 307  0091 a608          	ld	a,#8
 308  0093 6b02          	ld	(OFST-1,sp),a
 310  0095               L101:
 311                     ; 203 			wait --;
 314  0095 0a02          	dec	(OFST-1,sp)
 316                     ; 202 		while(wait)
 316                     ; 203 			wait --;
 318  0097 0d02          	tnz	(OFST-1,sp)
 319  0099 26fa          	jrne	L101
 320                     ; 205     ReceivedData = DataBuffer;
 322  009b ae0002        	ldw	x,#_DataBuffer
 323  009e bf00          	ldw	_ReceivedData,x
 324                     ; 208     if(!Receive(ReceivedData++))
 326  00a0 be00          	ldw	x,_ReceivedData
 327  00a2 1c0001        	addw	x,#1
 328  00a5 bf00          	ldw	_ReceivedData,x
 329  00a7 1d0001        	subw	x,#1
 330  00aa cd06d1        	call	_Receive
 332  00ad 4d            	tnz	a
 333  00ae 273e          	jreq	L57
 334                     ; 209       continue;
 336                     ; 212     if(!Receive(ReceivedData++))
 338  00b0 be00          	ldw	x,_ReceivedData
 339  00b2 1c0001        	addw	x,#1
 340  00b5 bf00          	ldw	_ReceivedData,x
 341  00b7 1d0001        	subw	x,#1
 342  00ba cd06d1        	call	_Receive
 344  00bd 4d            	tnz	a
 345  00be 272e          	jreq	L57
 346                     ; 213       continue;
 348                     ; 216     if(DataBuffer[N_COMMAND] != (u8)(~DataBuffer[N_NEG_COMMAND]))
 350  00c0 b603          	ld	a,_DataBuffer+1
 351  00c2 43            	cpl	a
 352  00c3 b102          	cp	a,_DataBuffer
 353  00c5 2707          	jreq	L311
 354                     ; 218       Transmit(NACK);
 356  00c7 a61f          	ld	a,#31
 357  00c9 cd06a4        	call	_Transmit
 359                     ; 219       continue;
 361  00cc 2020          	jra	L57
 362  00ce               L311:
 363                     ; 223     Transmit(ACK);
 365  00ce a679          	ld	a,#121
 366  00d0 cd06a4        	call	_Transmit
 368                     ; 224     command = DataBuffer[0];
 370  00d3 b602          	ld	a,_DataBuffer
 371  00d5 6b01          	ld	(OFST-2,sp),a
 373                     ; 225     switch(DataBuffer[0])
 375  00d7 b602          	ld	a,_DataBuffer
 377                     ; 230       case (WM_Command): result = WM_Command_Process(); break;
 378  00d9 4d            	tnz	a
 379  00da 270e          	jreq	L53
 380  00dc a011          	sub	a,#17
 381  00de 271b          	jreq	L73
 382  00e0 a010          	sub	a,#16
 383  00e2 271d          	jreq	L14
 384  00e4 a010          	sub	a,#16
 385  00e6 2720          	jreq	L34
 386  00e8 2004          	jra	L57
 387  00ea               L53:
 388                     ; 227       case (GT_Command): result = GT_Command_Process(); break;
 390  00ea ad25          	call	_GT_Command_Process
 392  00ec 6b03          	ld	(OFST+0,sp),a
 395  00ee               L57:
 396                     ; 232   }while( (!result) || (command != GO_Command) ); //until GO command received
 398  00ee 0d03          	tnz	(OFST+0,sp)
 399  00f0 279f          	jreq	L37
 401  00f2 7b01          	ld	a,(OFST-2,sp)
 402  00f4 a121          	cp	a,#33
 403  00f6 2699          	jrne	L37
 404                     ; 233 }//ProcessCommands
 407  00f8 5b03          	addw	sp,#3
 408  00fa 81            	ret
 409  00fb               L73:
 410                     ; 228       case (RM_Command): result = RM_Command_Process(); break;
 412  00fb ad3e          	call	_RM_Command_Process
 414  00fd 6b03          	ld	(OFST+0,sp),a
 418  00ff 20ed          	jra	L57
 419  0101               L14:
 420                     ; 229       case (GO_Command): result = GO_Command_Process(); break;
 422  0101 cd01a8        	call	_GO_Command_Process
 424  0104 6b03          	ld	(OFST+0,sp),a
 428  0106 20e6          	jra	L57
 429  0108               L34:
 430                     ; 230       case (WM_Command): result = WM_Command_Process(); break;
 432  0108 cd01cd        	call	_WM_Command_Process
 434  010b 6b03          	ld	(OFST+0,sp),a
 438  010d 20df          	jra	L57
 439  010f               L711:
 440  010f 20dd          	jra	L57
 464                     ; 235 u8 GT_Command_Process(void){
 465                     	switch	.text
 466  0111               _GT_Command_Process:
 470                     ; 237   Transmit(Num_GT_Command);
 472  0111 a605          	ld	a,#5
 473  0113 cd06a4        	call	_Transmit
 475                     ; 240   Transmit(Version_Number);
 477  0116 a610          	ld	a,#16
 478  0118 cd06a4        	call	_Transmit
 480                     ; 243   Transmit(GT_Command);
 482  011b 4f            	clr	a
 483  011c cd06a4        	call	_Transmit
 485                     ; 246   Transmit(RM_Command);
 487  011f a611          	ld	a,#17
 488  0121 cd06a4        	call	_Transmit
 490                     ; 249   Transmit(GO_Command);
 492  0124 a621          	ld	a,#33
 493  0126 cd06a4        	call	_Transmit
 495                     ; 252   Transmit(WM_Command);
 497  0129 a631          	ld	a,#49
 498  012b cd06a4        	call	_Transmit
 500                     ; 255   Transmit(EM_Command);
 502  012e a643          	ld	a,#67
 503  0130 cd06a4        	call	_Transmit
 505                     ; 258   Transmit(ACK);
 507  0133 a679          	ld	a,#121
 508  0135 cd06a4        	call	_Transmit
 510                     ; 260   return 1;
 512  0138 a601          	ld	a,#1
 515  013a 81            	ret
 572                     ; 263 u8 RM_Command_Process(void){
 573                     	switch	.text
 574  013b               _RM_Command_Process:
 576  013b 5205          	subw	sp,#5
 577       00000005      OFST:	set	5
 580                     ; 268   if(!ReceiveAddress())
 582  013d cd071e        	call	_ReceiveAddress
 584  0140 4d            	tnz	a
 585  0141 2608          	jrne	L751
 586                     ; 270     Transmit(NACK);// if not valid - NACK
 588  0143 a61f          	ld	a,#31
 589  0145 cd06a4        	call	_Transmit
 591                     ; 271     return 0;
 593  0148 4f            	clr	a
 595  0149 201b          	jra	L41
 596  014b               L751:
 597                     ; 275   DataAddress = *(u8 FAR**)(&DataBuffer[N_ADDR_3]);
 599  014b b605          	ld	a,_DataBuffer+3
 600  014d 6b02          	ld	(OFST-3,sp),a
 601  014f b606          	ld	a,_DataBuffer+4
 602  0151 6b03          	ld	(OFST-2,sp),a
 603  0153 b607          	ld	a,_DataBuffer+5
 604  0155 6b04          	ld	(OFST-1,sp),a
 606                     ; 278   if(!ReceiveCount(0xFF, 1))
 608  0157 aeff01        	ldw	x,#65281
 609  015a cd07bf        	call	_ReceiveCount
 611  015d 4d            	tnz	a
 612  015e 2609          	jrne	L161
 613                     ; 280     Transmit(NACK);// if not valid - NACK
 615  0160 a61f          	ld	a,#31
 616  0162 cd06a4        	call	_Transmit
 618                     ; 281     return 0;
 620  0165 4f            	clr	a
 622  0166               L41:
 624  0166 5b05          	addw	sp,#5
 625  0168 81            	ret
 626  0169               L161:
 627                     ; 285   Checksum = 0;
 629  0169 0f01          	clr	(OFST-4,sp)
 631                     ; 286   for(i=0; i<=DataBuffer[N_DATACOUNT]; i++)
 633  016b 0f05          	clr	(OFST+0,sp)
 636  016d 202f          	jra	L761
 637  016f               L361:
 638                     ; 288     Checksum ^= DataAddress[i];
 640  016f 7b02          	ld	a,(OFST-3,sp)
 641  0171 b700          	ld	c_x,a
 642  0173 1e03          	ldw	x,(OFST-2,sp)
 643  0175 7b05          	ld	a,(OFST+0,sp)
 644  0177 905f          	clrw	y
 645  0179 9097          	ld	yl,a
 646  017b bf01          	ldw	c_x+1,x
 647  017d 93            	ldw	x,y
 648  017e 92af0000      	ldf	a,([c_x.e],x)
 649  0182 1801          	xor	a,(OFST-4,sp)
 650  0184 6b01          	ld	(OFST-4,sp),a
 652                     ; 289     Transmit(DataAddress[i]);
 654  0186 7b02          	ld	a,(OFST-3,sp)
 655  0188 b700          	ld	c_x,a
 656  018a 1e03          	ldw	x,(OFST-2,sp)
 657  018c 7b05          	ld	a,(OFST+0,sp)
 658  018e 905f          	clrw	y
 659  0190 9097          	ld	yl,a
 660  0192 bf01          	ldw	c_x+1,x
 661  0194 93            	ldw	x,y
 662  0195 92af0000      	ldf	a,([c_x.e],x)
 663  0199 cd06a4        	call	_Transmit
 665                     ; 286   for(i=0; i<=DataBuffer[N_DATACOUNT]; i++)
 667  019c 0c05          	inc	(OFST+0,sp)
 669  019e               L761:
 672  019e 7b05          	ld	a,(OFST+0,sp)
 673  01a0 b109          	cp	a,_DataBuffer+7
 674  01a2 23cb          	jrule	L361
 675                     ; 291   return 1;
 677  01a4 a601          	ld	a,#1
 679  01a6 20be          	jra	L41
 726                     ; 294 u8 GO_Command_Process(void){
 727                     	switch	.text
 728  01a8               _GO_Command_Process:
 730  01a8 5206          	subw	sp,#6
 731       00000006      OFST:	set	6
 734                     ; 298   if(!ReceiveAddress())
 736  01aa cd071e        	call	_ReceiveAddress
 738  01ad 4d            	tnz	a
 739  01ae 2608          	jrne	L512
 740                     ; 300     Transmit(NACK);// if not valid - NACK
 742  01b0 a61f          	ld	a,#31
 743  01b2 cd06a4        	call	_Transmit
 745                     ; 301     return 0;
 747  01b5 4f            	clr	a
 749  01b6 2012          	jra	L02
 750  01b8               L512:
 751                     ; 304   Address32 = *(u32*)(&DataBuffer[N_ADDR_3]);
 753  01b8 be07          	ldw	x,_DataBuffer+5
 754  01ba 1f03          	ldw	(OFST-3,sp),x
 755  01bc be05          	ldw	x,_DataBuffer+3
 756  01be 1f01          	ldw	(OFST-5,sp),x
 758                     ; 305 	Address16 = (u16)(Address32 >> 8);
 760  01c0 1e02          	ldw	x,(OFST-4,sp)
 761  01c2 1f05          	ldw	(OFST-1,sp),x
 763                     ; 306   GoAddress = (TFunction)Address16;
 765  01c4 1e05          	ldw	x,(OFST-1,sp)
 766  01c6 bf84          	ldw	_GoAddress,x
 767                     ; 307   return 1;
 769  01c8 a601          	ld	a,#1
 771  01ca               L02:
 773  01ca 5b06          	addw	sp,#6
 774  01cc 81            	ret
 860                     ; 310 u8 WM_Command_Process(void){
 861                     	switch	.text
 862  01cd               _WM_Command_Process:
 864  01cd 5209          	subw	sp,#9
 865       00000009      OFST:	set	9
 868                     ; 316   int ierror = 0;
 870  01cf 5f            	clrw	x
 871  01d0 1f07          	ldw	(OFST-2,sp),x
 873                     ; 319   if(!ReceiveAddress())
 875  01d2 cd071e        	call	_ReceiveAddress
 877  01d5 4d            	tnz	a
 878  01d6 2608          	jrne	L162
 879                     ; 321     Transmit(NACK);// if not valid - NACK
 881  01d8 a61f          	ld	a,#31
 882  01da cd06a4        	call	_Transmit
 884                     ; 322     return 0;
 886  01dd 4f            	clr	a
 888  01de 201b          	jra	L42
 889  01e0               L162:
 890                     ; 326   DataAddress = *(u8 FAR**)(&DataBuffer[N_ADDR_3]);
 892  01e0 b605          	ld	a,_DataBuffer+3
 893  01e2 6b01          	ld	(OFST-8,sp),a
 894  01e4 b606          	ld	a,_DataBuffer+4
 895  01e6 6b02          	ld	(OFST-7,sp),a
 896  01e8 b607          	ld	a,_DataBuffer+5
 897  01ea 6b03          	ld	(OFST-6,sp),a
 899                     ; 329    if(!ReceiveCount(BLOCK_SIZE-1, 0))
 901  01ec ae7f00        	ldw	x,#32512
 902  01ef cd07bf        	call	_ReceiveCount
 904  01f2 4d            	tnz	a
 905  01f3 2609          	jrne	L362
 906                     ; 331     Transmit(NACK);// if not valid - NACK
 908  01f5 a61f          	ld	a,#31
 909  01f7 cd06a4        	call	_Transmit
 911                     ; 332     return 0;
 913  01fa 4f            	clr	a
 915  01fb               L42:
 917  01fb 5b09          	addw	sp,#9
 918  01fd 81            	ret
 919  01fe               L362:
 920                     ; 336   DataCount = DataBuffer[N_DATACOUNT]; // init count
 922  01fe b609          	ld	a,_DataBuffer+7
 923  0200 6b06          	ld	(OFST-3,sp),a
 925                     ; 337   Checksum = DataCount;                //init checksum
 927  0202 7b06          	ld	a,(OFST-3,sp)
 928  0204 6b05          	ld	(OFST-4,sp),a
 930                     ; 338   for(i=0; i<=DataCount; i++)
 932  0206 0f09          	clr	(OFST+0,sp)
 935  0208 201d          	jra	L172
 936  020a               L562:
 937                     ; 340     if(!Receive(&DataBuffer[i]))
 939  020a 7b09          	ld	a,(OFST+0,sp)
 940  020c ab02          	add	a,#_DataBuffer
 941  020e 5f            	clrw	x
 942  020f 97            	ld	xl,a
 943  0210 cd06d1        	call	_Receive
 945  0213 4d            	tnz	a
 946  0214 2605          	jrne	L572
 947                     ; 342       ierror = 1;
 949  0216 ae0001        	ldw	x,#1
 950  0219 1f07          	ldw	(OFST-2,sp),x
 952  021b               L572:
 953                     ; 345     Checksum ^= DataBuffer[i];
 955  021b 7b09          	ld	a,(OFST+0,sp)
 956  021d 5f            	clrw	x
 957  021e 97            	ld	xl,a
 958  021f 7b05          	ld	a,(OFST-4,sp)
 959  0221 e802          	xor	a,(_DataBuffer,x)
 960  0223 6b05          	ld	(OFST-4,sp),a
 962                     ; 338   for(i=0; i<=DataCount; i++)
 964  0225 0c09          	inc	(OFST+0,sp)
 966  0227               L172:
 969  0227 7b09          	ld	a,(OFST+0,sp)
 970  0229 1106          	cp	a,(OFST-3,sp)
 971  022b 23dd          	jrule	L562
 972                     ; 349   if(!Receive(&ChecksumByte))
 974  022d 96            	ldw	x,sp
 975  022e 1c0004        	addw	x,#OFST-5
 976  0231 cd06d1        	call	_Receive
 978  0234 4d            	tnz	a
 979  0235 2605          	jrne	L772
 980                     ; 351 		ierror = 1;
 982  0237 ae0001        	ldw	x,#1
 983  023a 1f07          	ldw	(OFST-2,sp),x
 985  023c               L772:
 986                     ; 354   if(ChecksumByte != Checksum)
 988  023c 7b04          	ld	a,(OFST-5,sp)
 989  023e 1105          	cp	a,(OFST-4,sp)
 990  0240 2705          	jreq	L103
 991                     ; 356     ierror = 1;
 993  0242 ae0001        	ldw	x,#1
 994  0245 1f07          	ldw	(OFST-2,sp),x
 996  0247               L103:
 997                     ; 359   if (ierror == 1)
 999  0247 1e07          	ldw	x,(OFST-2,sp)
1000  0249 a30001        	cpw	x,#1
1001  024c 2608          	jrne	L303
1002                     ; 361     Transmit(NACK); //send error
1004  024e a61f          	ld	a,#31
1005  0250 cd06a4        	call	_Transmit
1007                     ; 362     return 0;    
1009  0253 4f            	clr	a
1011  0254 20a5          	jra	L42
1012  0256               L303:
1013                     ; 366   if (!WriteBuffer(DataAddress, DataCount+1))
1015  0256 7b06          	ld	a,(OFST-3,sp)
1016  0258 4c            	inc	a
1017  0259 88            	push	a
1018  025a 7b02          	ld	a,(OFST-7,sp)
1019  025c b700          	ld	c_x,a
1020  025e 1e03          	ldw	x,(OFST-6,sp)
1021  0260 cd02f0        	call	_WriteBuffer
1023  0263 5b01          	addw	sp,#1
1024  0265 4d            	tnz	a
1025  0266 2608          	jrne	L503
1026                     ; 368     Transmit(NACK); //send error
1028  0268 a61f          	ld	a,#31
1029  026a cd06a4        	call	_Transmit
1031                     ; 369     return 0;    
1033  026d 4f            	clr	a
1035  026e 208b          	jra	L42
1036  0270               L503:
1037                     ; 372   Transmit(ACK);
1039  0270 a679          	ld	a,#121
1040  0272 cd06a4        	call	_Transmit
1042                     ; 373   return 1;
1044  0275 a601          	ld	a,#1
1046  0277 2082          	jra	L42
1080                     	switch	.const
1081  0002               L03:
1082  0002 00008000      	dc.l	32768
1083  0006               L23:
1084  0006 00030000      	dc.l	196608
1085  000a               L43:
1086  000a 00004000      	dc.l	16384
1087  000e               L63:
1088  000e 00004400      	dc.l	17408
1089  0012               L04:
1090  0012 00000800      	dc.l	2048
1091  0016               L24:
1092  0016 00004800      	dc.l	18432
1093  001a               L44:
1094  001a 00004900      	dc.l	18688
1095                     ; 376 u8 CheckAddress(u32 DataAddress){
1096                     	switch	.text
1097  0279               _CheckAddress:
1099       00000000      OFST:	set	0
1102                     ; 378   if ((DataAddress >= FLASH_START) && (DataAddress <= FLASH_END))
1104  0279 96            	ldw	x,sp
1105  027a 1c0003        	addw	x,#OFST+3
1106  027d cd0000        	call	c_ltor
1108  0280 ae0002        	ldw	x,#L03
1109  0283 cd0000        	call	c_lcmp
1111  0286 2512          	jrult	L523
1113  0288 96            	ldw	x,sp
1114  0289 1c0003        	addw	x,#OFST+3
1115  028c cd0000        	call	c_ltor
1117  028f ae0006        	ldw	x,#L23
1118  0292 cd0000        	call	c_lcmp
1120  0295 2403          	jruge	L523
1121                     ; 379     return 1;
1123  0297 a601          	ld	a,#1
1126  0299 81            	ret
1127  029a               L523:
1128                     ; 382     if ((DataAddress >= EEPROM_START) && (DataAddress <= EEPROM_END))
1130  029a 96            	ldw	x,sp
1131  029b 1c0003        	addw	x,#OFST+3
1132  029e cd0000        	call	c_ltor
1134  02a1 ae000a        	ldw	x,#L43
1135  02a4 cd0000        	call	c_lcmp
1137  02a7 2512          	jrult	L133
1139  02a9 96            	ldw	x,sp
1140  02aa 1c0003        	addw	x,#OFST+3
1141  02ad cd0000        	call	c_ltor
1143  02b0 ae000e        	ldw	x,#L63
1144  02b3 cd0000        	call	c_lcmp
1146  02b6 2403          	jruge	L133
1147                     ; 383       return 1;
1149  02b8 a601          	ld	a,#1
1152  02ba 81            	ret
1153  02bb               L133:
1154                     ; 386       if ((DataAddress >= RAM_START) && (DataAddress <= RAM_END))
1157  02bb 96            	ldw	x,sp
1158  02bc 1c0003        	addw	x,#OFST+3
1159  02bf cd0000        	call	c_ltor
1161  02c2 ae0012        	ldw	x,#L04
1162  02c5 cd0000        	call	c_lcmp
1164  02c8 2403          	jruge	L533
1165                     ; 387         return 1;
1167  02ca a601          	ld	a,#1
1170  02cc 81            	ret
1171  02cd               L533:
1172                     ; 390         if ((DataAddress >= OPTION_START) && (DataAddress <= OPTION_END))
1174  02cd 96            	ldw	x,sp
1175  02ce 1c0003        	addw	x,#OFST+3
1176  02d1 cd0000        	call	c_ltor
1178  02d4 ae0016        	ldw	x,#L24
1179  02d7 cd0000        	call	c_lcmp
1181  02da 2512          	jrult	L723
1183  02dc 96            	ldw	x,sp
1184  02dd 1c0003        	addw	x,#OFST+3
1185  02e0 cd0000        	call	c_ltor
1187  02e3 ae001a        	ldw	x,#L44
1188  02e6 cd0000        	call	c_lcmp
1190  02e9 2403          	jruge	L723
1191                     ; 391           return 1;
1193  02eb a601          	ld	a,#1
1196  02ed 81            	ret
1197  02ee               L723:
1198                     ; 392   return 0;
1200  02ee 4f            	clr	a
1203  02ef 81            	ret
1259                     ; 395 u8 WriteBuffer(u8 FAR* DataAddress, u8 DataCount){
1260                     	switch	.text
1261  02f0               _WriteBuffer:
1263  02f0 89            	pushw	x
1264  02f1 3b0000        	push	c_x
1265  02f4 88            	push	a
1266       00000001      OFST:	set	1
1269                     ; 399   if (((u32)DataAddress >= FLASH_START) && (((u32)DataAddress + DataCount - 1) <= FLASH_END))
1271  02f5 3f00          	clr	c_lreg
1272  02f7 450001        	mov	c_lreg+1,c_x
1273  02fa bf02          	ldw	c_lreg+2,x
1274  02fc ae0002        	ldw	x,#L03
1275  02ff cd0000        	call	c_lcmp
1277  0302 2531          	jrult	L173
1279  0304 3f00          	clr	c_lreg
1280  0306 7b02          	ld	a,(OFST+1,sp)
1281  0308 b701          	ld	c_lreg+1,a
1282  030a 7b03          	ld	a,(OFST+2,sp)
1283  030c b702          	ld	c_lreg+2,a
1284  030e 7b04          	ld	a,(OFST+3,sp)
1285  0310 b703          	ld	c_lreg+3,a
1286  0312 7b07          	ld	a,(OFST+6,sp)
1287  0314 cd0000        	call	c_ladc
1289  0317 a601          	ld	a,#1
1290  0319 cd0000        	call	c_lsbc
1292  031c ae0006        	ldw	x,#L23
1293  031f cd0000        	call	c_lcmp
1295  0322 2411          	jruge	L173
1296                     ; 400     return WriteBufferFlash(DataAddress, DataCount, FLASH_MEMTYPE_PROG);
1298  0324 4b00          	push	#0
1299  0326 7b08          	ld	a,(OFST+7,sp)
1300  0328 88            	push	a
1301  0329 7b04          	ld	a,(OFST+3,sp)
1302  032b b700          	ld	c_x,a
1303  032d 1e05          	ldw	x,(OFST+4,sp)
1304  032f cd043b        	call	_WriteBufferFlash
1306  0332 85            	popw	x
1308  0333 2045          	jra	L25
1309  0335               L173:
1310                     ; 403   if (((u32)DataAddress >= EEPROM_START) && (((u32)DataAddress + DataCount - 1) <= EEPROM_END))
1312  0335 3f00          	clr	c_lreg
1313  0337 7b02          	ld	a,(OFST+1,sp)
1314  0339 b701          	ld	c_lreg+1,a
1315  033b 7b03          	ld	a,(OFST+2,sp)
1316  033d b702          	ld	c_lreg+2,a
1317  033f 7b04          	ld	a,(OFST+3,sp)
1318  0341 b703          	ld	c_lreg+3,a
1319  0343 ae000a        	ldw	x,#L43
1320  0346 cd0000        	call	c_lcmp
1322  0349 2532          	jrult	L373
1324  034b 3f00          	clr	c_lreg
1325  034d 7b02          	ld	a,(OFST+1,sp)
1326  034f b701          	ld	c_lreg+1,a
1327  0351 7b03          	ld	a,(OFST+2,sp)
1328  0353 b702          	ld	c_lreg+2,a
1329  0355 7b04          	ld	a,(OFST+3,sp)
1330  0357 b703          	ld	c_lreg+3,a
1331  0359 7b07          	ld	a,(OFST+6,sp)
1332  035b cd0000        	call	c_ladc
1334  035e a601          	ld	a,#1
1335  0360 cd0000        	call	c_lsbc
1337  0363 ae000e        	ldw	x,#L63
1338  0366 cd0000        	call	c_lcmp
1340  0369 2412          	jruge	L373
1341                     ; 404     return WriteBufferFlash(DataAddress, DataCount, FLASH_MEMTYPE_DATA);
1343  036b 4b01          	push	#1
1344  036d 7b08          	ld	a,(OFST+7,sp)
1345  036f 88            	push	a
1346  0370 7b04          	ld	a,(OFST+3,sp)
1347  0372 b700          	ld	c_x,a
1348  0374 1e05          	ldw	x,(OFST+4,sp)
1349  0376 cd043b        	call	_WriteBufferFlash
1351  0379 85            	popw	x
1353  037a               L25:
1355  037a 5b04          	addw	sp,#4
1356  037c 81            	ret
1357  037d               L373:
1358                     ; 407   if (((u32)DataAddress >= RAM_START) && (((u32)DataAddress + DataCount - 1) <= RAM_END))
1361  037d 3f00          	clr	c_lreg
1362  037f 7b02          	ld	a,(OFST+1,sp)
1363  0381 b701          	ld	c_lreg+1,a
1364  0383 7b03          	ld	a,(OFST+2,sp)
1365  0385 b702          	ld	c_lreg+2,a
1366  0387 7b04          	ld	a,(OFST+3,sp)
1367  0389 b703          	ld	c_lreg+3,a
1368  038b 7b07          	ld	a,(OFST+6,sp)
1369  038d cd0000        	call	c_ladc
1371  0390 a601          	ld	a,#1
1372  0392 cd0000        	call	c_lsbc
1374  0395 ae0012        	ldw	x,#L04
1375  0398 cd0000        	call	c_lcmp
1377  039b 2431          	jruge	L573
1378                     ; 409     for(i=0; i<DataCount; i++)
1380  039d 0f01          	clr	(OFST+0,sp)
1383  039f 2023          	jra	L304
1384  03a1               L773:
1385                     ; 410       DataAddress[i] = DataBuffer[i];
1387  03a1 7b01          	ld	a,(OFST+0,sp)
1388  03a3 5f            	clrw	x
1389  03a4 97            	ld	xl,a
1390  03a5 e602          	ld	a,(_DataBuffer,x)
1391  03a7 88            	push	a
1392  03a8 7b03          	ld	a,(OFST+2,sp)
1393  03aa b700          	ld	c_x,a
1394  03ac 1e04          	ldw	x,(OFST+3,sp)
1395  03ae 84            	pop	a
1396  03af 41            	exg	a,xl
1397  03b0 1b01          	add	a,(OFST+0,sp)
1398  03b2 41            	exg	a,xl
1399  03b3 2407          	jrnc	L05
1400  03b5 1c0100        	addw	x,#256
1401  03b8 2402          	jrnc	L05
1402  03ba 3c00          	inc	c_x
1403  03bc               L05:
1404  03bc bf01          	ldw	c_x+1,x
1405  03be 92bd0000      	ldf	[c_x.e],a
1406                     ; 409     for(i=0; i<DataCount; i++)
1408  03c2 0c01          	inc	(OFST+0,sp)
1410  03c4               L304:
1413  03c4 7b01          	ld	a,(OFST+0,sp)
1414  03c6 1107          	cp	a,(OFST+6,sp)
1415  03c8 25d7          	jrult	L773
1416                     ; 411     return 1;
1418  03ca a601          	ld	a,#1
1420  03cc 20ac          	jra	L25
1421  03ce               L573:
1422                     ; 415   if (((u32)DataAddress >= OPTION_START) && (((u32)DataAddress + DataCount - 1) <= OPTION_END))
1424  03ce 3f00          	clr	c_lreg
1425  03d0 7b02          	ld	a,(OFST+1,sp)
1426  03d2 b701          	ld	c_lreg+1,a
1427  03d4 7b03          	ld	a,(OFST+2,sp)
1428  03d6 b702          	ld	c_lreg+2,a
1429  03d8 7b04          	ld	a,(OFST+3,sp)
1430  03da b703          	ld	c_lreg+3,a
1431  03dc ae0016        	ldw	x,#L24
1432  03df cd0000        	call	c_lcmp
1434  03e2 2552          	jrult	L704
1436  03e4 3f00          	clr	c_lreg
1437  03e6 7b02          	ld	a,(OFST+1,sp)
1438  03e8 b701          	ld	c_lreg+1,a
1439  03ea 7b03          	ld	a,(OFST+2,sp)
1440  03ec b702          	ld	c_lreg+2,a
1441  03ee 7b04          	ld	a,(OFST+3,sp)
1442  03f0 b703          	ld	c_lreg+3,a
1443  03f2 7b07          	ld	a,(OFST+6,sp)
1444  03f4 cd0000        	call	c_ladc
1446  03f7 a601          	ld	a,#1
1447  03f9 cd0000        	call	c_lsbc
1449  03fc ae001a        	ldw	x,#L44
1450  03ff cd0000        	call	c_lcmp
1452  0402 2432          	jruge	L704
1453                     ; 417     for(i=0; i<DataCount; i++)
1455  0404 0f01          	clr	(OFST+0,sp)
1458  0406 2022          	jra	L514
1459  0408               L114:
1460                     ; 419        FLASH_ProgramOptionByte((u32)(&DataAddress[i]), DataBuffer[i]);
1462  0408 7b01          	ld	a,(OFST+0,sp)
1463  040a 5f            	clrw	x
1464  040b 97            	ld	xl,a
1465  040c e602          	ld	a,(_DataBuffer,x)
1466  040e 88            	push	a
1467  040f 3f00          	clr	c_lreg
1468  0411 7b03          	ld	a,(OFST+2,sp)
1469  0413 b701          	ld	c_lreg+1,a
1470  0415 7b04          	ld	a,(OFST+3,sp)
1471  0417 b702          	ld	c_lreg+2,a
1472  0419 7b05          	ld	a,(OFST+4,sp)
1473  041b b703          	ld	c_lreg+3,a
1474  041d 7b02          	ld	a,(OFST+1,sp)
1475  041f cd0000        	call	c_ladc
1477  0422 be02          	ldw	x,c_lreg+2
1478  0424 cd0833        	call	_FLASH_ProgramOptionByte
1480  0427 84            	pop	a
1481                     ; 417     for(i=0; i<DataCount; i++)
1483  0428 0c01          	inc	(OFST+0,sp)
1485  042a               L514:
1488  042a 7b01          	ld	a,(OFST+0,sp)
1489  042c 1107          	cp	a,(OFST+6,sp)
1490  042e 25d8          	jrult	L114
1491                     ; 421     return 1;
1493  0430 a601          	ld	a,#1
1495  0432 ac7a037a      	jpf	L25
1496  0436               L704:
1497                     ; 425   return 0;
1499  0436 4f            	clr	a
1501  0437 ac7a037a      	jpf	L25
1605                     ; 428 u8 WriteBufferFlash(u8 FAR* DataAddress, u8 DataCount, FLASH_MemType_TypeDef MemType){
1606                     	switch	.text
1607  043b               _WriteBufferFlash:
1609  043b 89            	pushw	x
1610  043c 3b0000        	push	c_x
1611  043f 520a          	subw	sp,#10
1612       0000000a      OFST:	set	10
1615                     ; 429   u32 Address = (u32) DataAddress;
1617  0441 3f00          	clr	c_lreg
1618  0443 450001        	mov	c_lreg+1,c_x
1619  0446 bf02          	ldw	c_lreg+2,x
1620  0448 96            	ldw	x,sp
1621  0449 1c0007        	addw	x,#OFST-3
1622  044c cd0000        	call	c_rtol
1625                     ; 430   u8 * DataPointer = DataBuffer;
1627  044f ae0002        	ldw	x,#_DataBuffer
1628  0452 1f05          	ldw	(OFST-5,sp),x
1630                     ; 433   if(MemType == FLASH_MEMTYPE_PROG)
1632  0454 0d11          	tnz	(OFST+7,sp)
1633  0456 260c          	jrne	L374
1634                     ; 434     Offset = FLASH_START;
1636  0458 ae8000        	ldw	x,#32768
1637  045b 1f03          	ldw	(OFST-7,sp),x
1638  045d ae0000        	ldw	x,#0
1639  0460 1f01          	ldw	(OFST-9,sp),x
1642  0462 2036          	jra	L105
1643  0464               L374:
1644                     ; 436     Offset = EEPROM_START;
1646  0464 ae4000        	ldw	x,#16384
1647  0467 1f03          	ldw	(OFST-7,sp),x
1648  0469 ae0000        	ldw	x,#0
1649  046c 1f01          	ldw	(OFST-9,sp),x
1651  046e 202a          	jra	L105
1652  0470               L774:
1653                     ; 440     *((PointerAttr u8*) Address) = *DataPointer;
1655  0470 1e05          	ldw	x,(OFST-5,sp)
1656  0472 f6            	ld	a,(x)
1657  0473 88            	push	a
1658  0474 7b09          	ld	a,(OFST-1,sp)
1659  0476 b700          	ld	c_x,a
1660  0478 1e0a          	ldw	x,(OFST+0,sp)
1661  047a 84            	pop	a
1662  047b bf01          	ldw	c_x+1,x
1663  047d 92bd0000      	ldf	[c_x.e],a
1665  0481               L115:
1666                     ; 441 		while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
1668  0481 c6505f        	ld	a,20575
1669  0484 a505          	bcp	a,#5
1670  0486 27f9          	jreq	L115
1671                     ; 442 		Address++;
1673  0488 96            	ldw	x,sp
1674  0489 1c0007        	addw	x,#OFST-3
1675  048c a601          	ld	a,#1
1676  048e cd0000        	call	c_lgadc
1679                     ; 443     DataPointer++;
1681  0491 1e05          	ldw	x,(OFST-5,sp)
1682  0493 1c0001        	addw	x,#1
1683  0496 1f05          	ldw	(OFST-5,sp),x
1685                     ; 444     DataCount--;
1687  0498 0a10          	dec	(OFST+6,sp)
1688  049a               L105:
1689                     ; 438   while((Address % 4) && (DataCount))
1691  049a 7b0a          	ld	a,(OFST+0,sp)
1692  049c a503          	bcp	a,#3
1693  049e 2603          	jrne	L65
1694  04a0 cc0535        	jp	L125
1695  04a3               L65:
1697  04a3 0d10          	tnz	(OFST+6,sp)
1698  04a5 26c9          	jrne	L774
1699  04a7 ac350535      	jpf	L125
1700  04ab               L715:
1701                     ; 449 		FLASH->CR2 |= (u8)0x40;
1703  04ab 721c505b      	bset	20571,#6
1704                     ; 450 		FLASH->NCR2 &= (u8)~0x40;
1706  04af 721d505c      	bres	20572,#6
1707                     ; 451 		*((PointerAttr u8*)Address) = (u8)*DataPointer  ; 	 /* Write one byte - from lowest address*/
1709  04b3 1e05          	ldw	x,(OFST-5,sp)
1710  04b5 f6            	ld	a,(x)
1711  04b6 88            	push	a
1712  04b7 7b09          	ld	a,(OFST-1,sp)
1713  04b9 b700          	ld	c_x,a
1714  04bb 1e0a          	ldw	x,(OFST+0,sp)
1715  04bd 84            	pop	a
1716  04be bf01          	ldw	c_x+1,x
1717  04c0 92bd0000      	ldf	[c_x.e],a
1718                     ; 452 		*((PointerAttr u8*)(Address + 1)) = *(DataPointer + 1); /* Write one byte*/
1720  04c4 96            	ldw	x,sp
1721  04c5 1c0007        	addw	x,#OFST-3
1722  04c8 cd0000        	call	c_ltor
1724  04cb a601          	ld	a,#1
1725  04cd cd0000        	call	c_ladc
1727  04d0 450100        	mov	c_x,c_lreg+1
1728  04d3 be02          	ldw	x,c_lreg+2
1729  04d5 1605          	ldw	y,(OFST-5,sp)
1730  04d7 90e601        	ld	a,(1,y)
1731  04da bf01          	ldw	c_x+1,x
1732  04dc 92bd0000      	ldf	[c_x.e],a
1733                     ; 453 		*((PointerAttr u8*)(Address + 2)) = *(DataPointer + 2); /* Write one byte*/
1735  04e0 96            	ldw	x,sp
1736  04e1 1c0007        	addw	x,#OFST-3
1737  04e4 cd0000        	call	c_ltor
1739  04e7 a602          	ld	a,#2
1740  04e9 cd0000        	call	c_ladc
1742  04ec 450100        	mov	c_x,c_lreg+1
1743  04ef be02          	ldw	x,c_lreg+2
1744  04f1 1605          	ldw	y,(OFST-5,sp)
1745  04f3 90e602        	ld	a,(2,y)
1746  04f6 bf01          	ldw	c_x+1,x
1747  04f8 92bd0000      	ldf	[c_x.e],a
1748                     ; 454 		*((PointerAttr u8*)(Address + 3)) = *(DataPointer + 3); /* Write one byte - from higher address*/
1750  04fc 96            	ldw	x,sp
1751  04fd 1c0007        	addw	x,#OFST-3
1752  0500 cd0000        	call	c_ltor
1754  0503 a603          	ld	a,#3
1755  0505 cd0000        	call	c_ladc
1757  0508 450100        	mov	c_x,c_lreg+1
1758  050b be02          	ldw	x,c_lreg+2
1759  050d 1605          	ldw	y,(OFST-5,sp)
1760  050f 90e603        	ld	a,(3,y)
1761  0512 bf01          	ldw	c_x+1,x
1762  0514 92bd0000      	ldf	[c_x.e],a
1764  0518               L135:
1765                     ; 455     while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
1767  0518 c6505f        	ld	a,20575
1768  051b a505          	bcp	a,#5
1769  051d 27f9          	jreq	L135
1770                     ; 456 		Address    += 4;
1772  051f 96            	ldw	x,sp
1773  0520 1c0007        	addw	x,#OFST-3
1774  0523 a604          	ld	a,#4
1775  0525 cd0000        	call	c_lgadc
1778                     ; 457     DataPointer+= 4;
1780  0528 1e05          	ldw	x,(OFST-5,sp)
1781  052a 1c0004        	addw	x,#4
1782  052d 1f05          	ldw	(OFST-5,sp),x
1784                     ; 458     DataCount  -= 4;
1786  052f 7b10          	ld	a,(OFST+6,sp)
1787  0531 a004          	sub	a,#4
1788  0533 6b10          	ld	(OFST+6,sp),a
1789  0535               L125:
1790                     ; 447 	while((Address % BLOCK_BYTES) && (DataCount >= 4))
1792  0535 7b0a          	ld	a,(OFST+0,sp)
1793  0537 a57f          	bcp	a,#127
1794  0539 2741          	jreq	L145
1796  053b 7b10          	ld	a,(OFST+6,sp)
1797  053d a104          	cp	a,#4
1798  053f 2503          	jrult	L06
1799  0541 cc04ab        	jp	L715
1800  0544               L06:
1801  0544 2036          	jra	L145
1802  0546               L735:
1803                     ; 463     Mem_ProgramBlock((Address - Offset)/BLOCK_BYTES, MemType, DataPointer);
1805  0546 1e05          	ldw	x,(OFST-5,sp)
1806  0548 89            	pushw	x
1807  0549 7b13          	ld	a,(OFST+9,sp)
1808  054b 88            	push	a
1809  054c 96            	ldw	x,sp
1810  054d 1c000a        	addw	x,#OFST+0
1811  0550 cd0000        	call	c_ltor
1813  0553 96            	ldw	x,sp
1814  0554 1c0004        	addw	x,#OFST-6
1815  0557 cd0000        	call	c_lsub
1817  055a a607          	ld	a,#7
1818  055c cd0000        	call	c_lursh
1820  055f be02          	ldw	x,c_lreg+2
1821  0561 cd0000        	call	_Mem_ProgramBlock
1823  0564 5b03          	addw	sp,#3
1824                     ; 464     Address    += BLOCK_BYTES;
1826  0566 96            	ldw	x,sp
1827  0567 1c0007        	addw	x,#OFST-3
1828  056a a680          	ld	a,#128
1829  056c cd0000        	call	c_lgadc
1832                     ; 465     DataPointer+= BLOCK_BYTES;    
1834  056f 1e05          	ldw	x,(OFST-5,sp)
1835  0571 1c0080        	addw	x,#128
1836  0574 1f05          	ldw	(OFST-5,sp),x
1838                     ; 466     DataCount  -= BLOCK_BYTES;
1840  0576 7b10          	ld	a,(OFST+6,sp)
1841  0578 a080          	sub	a,#128
1842  057a 6b10          	ld	(OFST+6,sp),a
1843  057c               L145:
1844                     ; 461   while(DataCount >= BLOCK_BYTES)
1846  057c 7b10          	ld	a,(OFST+6,sp)
1847  057e a180          	cp	a,#128
1848  0580 24c4          	jruge	L735
1850  0582 ac100610      	jpf	L745
1851  0586               L545:
1852                     ; 472 		FLASH->CR2 |= (u8)0x40;
1854  0586 721c505b      	bset	20571,#6
1855                     ; 473 		FLASH->NCR2 &= (u8)~0x40;
1857  058a 721d505c      	bres	20572,#6
1858                     ; 474 		*((PointerAttr u8*)Address) = (u8)*DataPointer  ; 	 /* Write one byte - from lowest address*/
1860  058e 1e05          	ldw	x,(OFST-5,sp)
1861  0590 f6            	ld	a,(x)
1862  0591 88            	push	a
1863  0592 7b09          	ld	a,(OFST-1,sp)
1864  0594 b700          	ld	c_x,a
1865  0596 1e0a          	ldw	x,(OFST+0,sp)
1866  0598 84            	pop	a
1867  0599 bf01          	ldw	c_x+1,x
1868  059b 92bd0000      	ldf	[c_x.e],a
1869                     ; 475 		*((PointerAttr u8*)(Address + 1)) = *(DataPointer + 1); /* Write one byte*/
1871  059f 96            	ldw	x,sp
1872  05a0 1c0007        	addw	x,#OFST-3
1873  05a3 cd0000        	call	c_ltor
1875  05a6 a601          	ld	a,#1
1876  05a8 cd0000        	call	c_ladc
1878  05ab 450100        	mov	c_x,c_lreg+1
1879  05ae be02          	ldw	x,c_lreg+2
1880  05b0 1605          	ldw	y,(OFST-5,sp)
1881  05b2 90e601        	ld	a,(1,y)
1882  05b5 bf01          	ldw	c_x+1,x
1883  05b7 92bd0000      	ldf	[c_x.e],a
1884                     ; 476 		*((PointerAttr u8*)(Address + 2)) = *(DataPointer + 2); /* Write one byte*/
1886  05bb 96            	ldw	x,sp
1887  05bc 1c0007        	addw	x,#OFST-3
1888  05bf cd0000        	call	c_ltor
1890  05c2 a602          	ld	a,#2
1891  05c4 cd0000        	call	c_ladc
1893  05c7 450100        	mov	c_x,c_lreg+1
1894  05ca be02          	ldw	x,c_lreg+2
1895  05cc 1605          	ldw	y,(OFST-5,sp)
1896  05ce 90e602        	ld	a,(2,y)
1897  05d1 bf01          	ldw	c_x+1,x
1898  05d3 92bd0000      	ldf	[c_x.e],a
1899                     ; 477 		*((PointerAttr u8*)(Address + 3)) = *(DataPointer + 3); /* Write one byte - from higher address*/
1901  05d7 96            	ldw	x,sp
1902  05d8 1c0007        	addw	x,#OFST-3
1903  05db cd0000        	call	c_ltor
1905  05de a603          	ld	a,#3
1906  05e0 cd0000        	call	c_ladc
1908  05e3 450100        	mov	c_x,c_lreg+1
1909  05e6 be02          	ldw	x,c_lreg+2
1910  05e8 1605          	ldw	y,(OFST-5,sp)
1911  05ea 90e603        	ld	a,(3,y)
1912  05ed bf01          	ldw	c_x+1,x
1913  05ef 92bd0000      	ldf	[c_x.e],a
1915  05f3               L755:
1916                     ; 478     while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
1918  05f3 c6505f        	ld	a,20575
1919  05f6 a505          	bcp	a,#5
1920  05f8 27f9          	jreq	L755
1921                     ; 479 		Address    += 4;
1923  05fa 96            	ldw	x,sp
1924  05fb 1c0007        	addw	x,#OFST-3
1925  05fe a604          	ld	a,#4
1926  0600 cd0000        	call	c_lgadc
1929                     ; 480     DataPointer+= 4;
1931  0603 1e05          	ldw	x,(OFST-5,sp)
1932  0605 1c0004        	addw	x,#4
1933  0608 1f05          	ldw	(OFST-5,sp),x
1935                     ; 481     DataCount  -= 4;
1937  060a 7b10          	ld	a,(OFST+6,sp)
1938  060c a004          	sub	a,#4
1939  060e 6b10          	ld	(OFST+6,sp),a
1940  0610               L745:
1941                     ; 470   while(DataCount >= 4)
1943  0610 7b10          	ld	a,(OFST+6,sp)
1944  0612 a104          	cp	a,#4
1945  0614 2503          	jrult	L26
1946  0616 cc0586        	jp	L545
1947  0619               L26:
1949  0619 202a          	jra	L565
1950  061b               L365:
1951                     ; 487     *((PointerAttr u8*) Address) = *DataPointer;
1953  061b 1e05          	ldw	x,(OFST-5,sp)
1954  061d f6            	ld	a,(x)
1955  061e 88            	push	a
1956  061f 7b09          	ld	a,(OFST-1,sp)
1957  0621 b700          	ld	c_x,a
1958  0623 1e0a          	ldw	x,(OFST+0,sp)
1959  0625 84            	pop	a
1960  0626 bf01          	ldw	c_x+1,x
1961  0628 92bd0000      	ldf	[c_x.e],a
1963  062c               L575:
1964                     ; 488     while( (FLASH->IAPSR & (FLASH_IAPSR_EOP | FLASH_IAPSR_WR_PG_DIS)) == 0);
1966  062c c6505f        	ld	a,20575
1967  062f a505          	bcp	a,#5
1968  0631 27f9          	jreq	L575
1969                     ; 489 		Address++;
1971  0633 96            	ldw	x,sp
1972  0634 1c0007        	addw	x,#OFST-3
1973  0637 a601          	ld	a,#1
1974  0639 cd0000        	call	c_lgadc
1977                     ; 490     DataPointer++;
1979  063c 1e05          	ldw	x,(OFST-5,sp)
1980  063e 1c0001        	addw	x,#1
1981  0641 1f05          	ldw	(OFST-5,sp),x
1983                     ; 491     DataCount--;
1985  0643 0a10          	dec	(OFST+6,sp)
1986  0645               L565:
1987                     ; 485   while(DataCount)
1989  0645 0d10          	tnz	(OFST+6,sp)
1990  0647 26d2          	jrne	L365
1991                     ; 494   return 1;
1993  0649 a601          	ld	a,#1
1996  064b 5b0d          	addw	sp,#13
1997  064d 81            	ret
2021                     ; 497 void DeInitBootloader(void){
2022                     	switch	.text
2023  064e               _DeInitBootloader:
2027                     ; 498   if(RoutinesInRAM)
2029  064e 3d00          	tnz	_RoutinesInRAM
2030  0650 2708          	jreq	L116
2031                     ; 501     FLASH->IAPSR = ~0x02;
2033  0652 35fd505f      	mov	20575,#253
2034                     ; 503     FLASH->IAPSR = ~0x08;
2036  0656 35f7505f      	mov	20575,#247
2037  065a               L116:
2038                     ; 507 	I2C->CR1 = 0x00;
2040  065a 725f5210      	clr	21008
2041                     ; 508   I2C->CR2 = 0x00;
2043  065e 725f5211      	clr	21009
2044                     ; 509   I2C->FREQR = 0x00;
2046  0662 725f5212      	clr	21010
2047                     ; 510   I2C->OARL = 0x00;
2049  0666 725f5213      	clr	21011
2050                     ; 511   I2C->OARH = 0x00;
2052  066a 725f5214      	clr	21012
2053                     ; 512   I2C->ITR = 0x00;
2055  066e 725f521a      	clr	21018
2056                     ; 513   I2C->CCRL = 0x00;
2058  0672 725f521b      	clr	21019
2059                     ; 514   I2C->CCRH = 0x00;
2061  0676 725f521c      	clr	21020
2062                     ; 515   I2C->TRISER = 0x02;
2064  067a 3502521d      	mov	21021,#2
2065                     ; 517 }//DeInitBootloader
2068  067e 81            	ret
2091                     ; 519 void protocol_init (void) {
2092                     	switch	.text
2093  067f               _protocol_init:
2097                     ; 604     GPIOD->CR1 |= (u8)0x40;
2099  067f 721c5012      	bset	20498,#6
2100                     ; 605 		GPIOC->CR1 |= (u8)0x02;		
2102  0683 7212500d      	bset	20493,#1
2103                     ; 608 		UART3->CR1 &= (u8)(~0x20); 
2105  0687 721b5244      	bres	21060,#5
2106                     ; 611     UART3->CR1 |= (u8)  0x14;
2108  068b c65244        	ld	a,21060
2109  068e aa14          	or	a,#20
2110  0690 c75244        	ld	21060,a
2111                     ; 614 		UART3->CR2 |= (u8)  0x0C;
2113  0693 c65245        	ld	a,21061
2114  0696 aa0c          	or	a,#12
2115  0698 c75245        	ld	21061,a
2116                     ; 617     UART3->BRR2 = 0x02;
2118  069b 35025243      	mov	21059,#2
2119                     ; 618 		UART3->BRR1 = 0x68;
2121  069f 35685242      	mov	21058,#104
2122                     ; 620 }
2125  06a3 81            	ret
2168                     ; 622 void Transmit(u8 Data){
2169                     	switch	.text
2170  06a4               _Transmit:
2172  06a4 88            	push	a
2173  06a5 88            	push	a
2174       00000001      OFST:	set	1
2177                     ; 673 	sr = UART3->SR;
2179  06a6 c65240        	ld	a,21056
2180  06a9 6b01          	ld	(OFST+0,sp),a
2183  06ab 2005          	jra	L156
2184  06ad               L546:
2185                     ; 674   while(!(sr & 0x80/*TxNE*/)) sr = UART3->SR;
2187  06ad c65240        	ld	a,21056
2188  06b0 6b01          	ld	(OFST+0,sp),a
2190  06b2               L156:
2193  06b2 7b01          	ld	a,(OFST+0,sp)
2194  06b4 a580          	bcp	a,#128
2195  06b6 27f5          	jreq	L546
2196                     ; 676    UART3->DR = Data;
2198  06b8 7b02          	ld	a,(OFST+1,sp)
2199  06ba c75241        	ld	21057,a
2200                     ; 678   sr = UART3->SR;
2202  06bd c65240        	ld	a,21056
2203  06c0 6b01          	ld	(OFST+0,sp),a
2206  06c2 2005          	jra	L166
2207  06c4               L556:
2208                     ; 679   while(!(sr & 0x40/*TxNE*/)) sr = UART3->SR;
2210  06c4 c65240        	ld	a,21056
2211  06c7 6b01          	ld	(OFST+0,sp),a
2213  06c9               L166:
2216  06c9 7b01          	ld	a,(OFST+0,sp)
2217  06cb a540          	bcp	a,#64
2218  06cd 27f5          	jreq	L556
2219                     ; 681 }//Transmit
2222  06cf 85            	popw	x
2223  06d0 81            	ret
2268                     ; 683 u8 Receive(u8* ReceivedData){
2269                     	switch	.text
2270  06d1               _Receive:
2272  06d1 89            	pushw	x
2273  06d2 88            	push	a
2274       00000001      OFST:	set	1
2277                     ; 778 	sr = UART3->SR;
2279  06d3 c65240        	ld	a,21056
2280  06d6 6b01          	ld	(OFST+0,sp),a
2283  06d8 2005          	jra	L317
2284  06da               L707:
2285                     ; 779   while(!(sr & 0x20 /*RXNE*/)) sr = UART3->SR ;
2287  06da c65240        	ld	a,21056
2288  06dd 6b01          	ld	(OFST+0,sp),a
2290  06df               L317:
2293  06df 7b01          	ld	a,(OFST+0,sp)
2294  06e1 a520          	bcp	a,#32
2295  06e3 27f5          	jreq	L707
2296                     ; 781 	if((sr & 0x08/*OR*/)||(sr & 0x01/*PE*/))
2298  06e5 7b01          	ld	a,(OFST+0,sp)
2299  06e7 a508          	bcp	a,#8
2300  06e9 2606          	jrne	L127
2302  06eb 7b01          	ld	a,(OFST+0,sp)
2303  06ed a501          	bcp	a,#1
2304  06ef 270d          	jreq	L717
2305  06f1               L127:
2306                     ; 784     *ReceivedData = UART3->DR ;
2308  06f1 1e02          	ldw	x,(OFST+1,sp)
2309  06f3 c65241        	ld	a,21057
2310  06f6 f7            	ld	(x),a
2311                     ; 786     Transmit(NACK);
2313  06f7 a61f          	ld	a,#31
2314  06f9 ada9          	call	_Transmit
2316                     ; 788     return 0;
2318  06fb 4f            	clr	a
2320  06fc 2008          	jra	L47
2321  06fe               L717:
2322                     ; 791   *ReceivedData = UART3->DR;
2324  06fe 1e02          	ldw	x,(OFST+1,sp)
2325  0700 c65241        	ld	a,21057
2326  0703 f7            	ld	(x),a
2327                     ; 793   return 1;
2329  0704 a601          	ld	a,#1
2331  0706               L47:
2333  0706 5b03          	addw	sp,#3
2334  0708 81            	ret
2378                     ; 798 u8 Master_ident(u8 IDENT_byte){
2379                     	switch	.text
2380  0709               _Master_ident:
2382  0709 88            	push	a
2383  070a 88            	push	a
2384       00000001      OFST:	set	1
2387                     ; 800 	Receive(&master_ident);
2389  070b 96            	ldw	x,sp
2390  070c 1c0001        	addw	x,#OFST+0
2391  070f adc0          	call	_Receive
2393                     ; 801   if (master_ident == IDENT_byte) 
2395  0711 7b01          	ld	a,(OFST+0,sp)
2396  0713 1102          	cp	a,(OFST+1,sp)
2397  0715 2604          	jrne	L547
2398                     ; 803 		return 1;	
2400  0717 a601          	ld	a,#1
2402  0719 2001          	jra	L001
2403  071b               L547:
2404                     ; 805 	return 0;
2406  071b 4f            	clr	a
2408  071c               L001:
2410  071c 85            	popw	x
2411  071d 81            	ret
2448                     ; 808 u8 ReceiveAddress(void){
2449                     	switch	.text
2450  071e               _ReceiveAddress:
2452  071e 88            	push	a
2453       00000001      OFST:	set	1
2456                     ; 809   u8 result = 1;
2458  071f a601          	ld	a,#1
2459  0721 6b01          	ld	(OFST+0,sp),a
2461                     ; 812   if(!Receive(ReceivedData++))
2463  0723 be00          	ldw	x,_ReceivedData
2464  0725 1c0001        	addw	x,#1
2465  0728 bf00          	ldw	_ReceivedData,x
2466  072a 1d0001        	subw	x,#1
2467  072d ada2          	call	_Receive
2469  072f 4d            	tnz	a
2470  0730 2602          	jrne	L567
2471                     ; 813     result = 0;
2473  0732 0f01          	clr	(OFST+0,sp)
2475  0734               L567:
2476                     ; 814   if(!Receive(ReceivedData++))
2478  0734 be00          	ldw	x,_ReceivedData
2479  0736 1c0001        	addw	x,#1
2480  0739 bf00          	ldw	_ReceivedData,x
2481  073b 1d0001        	subw	x,#1
2482  073e ad91          	call	_Receive
2484  0740 4d            	tnz	a
2485  0741 2602          	jrne	L767
2486                     ; 815     result = 0;
2488  0743 0f01          	clr	(OFST+0,sp)
2490  0745               L767:
2491                     ; 816   if(!Receive(ReceivedData++))
2493  0745 be00          	ldw	x,_ReceivedData
2494  0747 1c0001        	addw	x,#1
2495  074a bf00          	ldw	_ReceivedData,x
2496  074c 1d0001        	subw	x,#1
2497  074f ad80          	call	_Receive
2499  0751 4d            	tnz	a
2500  0752 2602          	jrne	L177
2501                     ; 817     result = 0;
2503  0754 0f01          	clr	(OFST+0,sp)
2505  0756               L177:
2506                     ; 818   if(!Receive(ReceivedData++))
2508  0756 be00          	ldw	x,_ReceivedData
2509  0758 1c0001        	addw	x,#1
2510  075b bf00          	ldw	_ReceivedData,x
2511  075d 1d0001        	subw	x,#1
2512  0760 cd06d1        	call	_Receive
2514  0763 4d            	tnz	a
2515  0764 2602          	jrne	L377
2516                     ; 819     result = 0;
2518  0766 0f01          	clr	(OFST+0,sp)
2520  0768               L377:
2521                     ; 822   if(!Receive(ReceivedData++))
2523  0768 be00          	ldw	x,_ReceivedData
2524  076a 1c0001        	addw	x,#1
2525  076d bf00          	ldw	_ReceivedData,x
2526  076f 1d0001        	subw	x,#1
2527  0772 cd06d1        	call	_Receive
2529  0775 4d            	tnz	a
2530  0776 2602          	jrne	L577
2531                     ; 823     result = 0;
2533  0778 0f01          	clr	(OFST+0,sp)
2535  077a               L577:
2536                     ; 826   if(*(--ReceivedData) ^ *(--ReceivedData) ^ *(--ReceivedData) ^ *(--ReceivedData) ^ *(--ReceivedData))
2538  077a be00          	ldw	x,_ReceivedData
2539  077c 1d0001        	subw	x,#1
2540  077f bf00          	ldw	_ReceivedData,x
2541  0781 f6            	ld	a,(x)
2542  0782 be00          	ldw	x,_ReceivedData
2543  0784 1d0001        	subw	x,#1
2544  0787 bf00          	ldw	_ReceivedData,x
2545  0789 f8            	xor	a,(x)
2546  078a be00          	ldw	x,_ReceivedData
2547  078c 1d0001        	subw	x,#1
2548  078f bf00          	ldw	_ReceivedData,x
2549  0791 f8            	xor	a,(x)
2550  0792 be00          	ldw	x,_ReceivedData
2551  0794 1d0001        	subw	x,#1
2552  0797 bf00          	ldw	_ReceivedData,x
2553  0799 f8            	xor	a,(x)
2554  079a be00          	ldw	x,_ReceivedData
2555  079c 1d0001        	subw	x,#1
2556  079f bf00          	ldw	_ReceivedData,x
2557  07a1 f8            	xor	a,(x)
2558  07a2 2702          	jreq	L777
2559                     ; 827     result = 0;
2561  07a4 0f01          	clr	(OFST+0,sp)
2563  07a6               L777:
2564                     ; 829   ReceivedData += 5;
2566  07a6 be00          	ldw	x,_ReceivedData
2567  07a8 1c0005        	addw	x,#5
2568  07ab bf00          	ldw	_ReceivedData,x
2569                     ; 836   if (!result)
2571  07ad 0d01          	tnz	(OFST+0,sp)
2572  07af 2604          	jrne	L1001
2573                     ; 837     return 0;
2575  07b1 4f            	clr	a
2578  07b2 5b01          	addw	sp,#1
2579  07b4 81            	ret
2580  07b5               L1001:
2581                     ; 840   Transmit(ACK);
2583  07b5 a679          	ld	a,#121
2584  07b7 cd06a4        	call	_Transmit
2586                     ; 841   return 1;
2588  07ba a601          	ld	a,#1
2591  07bc 5b01          	addw	sp,#1
2592  07be 81            	ret
2668                     ; 844 u8 ReceiveCount(u8 max, u8 enablechecksum){
2669                     	switch	.text
2670  07bf               _ReceiveCount:
2672  07bf 89            	pushw	x
2673  07c0 88            	push	a
2674       00000001      OFST:	set	1
2677                     ; 845   bool result = 1;
2679  07c1 a601          	ld	a,#1
2680  07c3 6b01          	ld	(OFST+0,sp),a
2682                     ; 848   if(!Receive(ReceivedData))
2684  07c5 be00          	ldw	x,_ReceivedData
2685  07c7 cd06d1        	call	_Receive
2687  07ca 4d            	tnz	a
2688  07cb 2602          	jrne	L1401
2689                     ; 849     result = 0;
2691  07cd 0f01          	clr	(OFST+0,sp)
2693  07cf               L1401:
2694                     ; 852   if(!((*ReceivedData++) <= max))
2696  07cf be00          	ldw	x,_ReceivedData
2697  07d1 1c0001        	addw	x,#1
2698  07d4 bf00          	ldw	_ReceivedData,x
2699  07d6 1d0001        	subw	x,#1
2700  07d9 f6            	ld	a,(x)
2701  07da 1102          	cp	a,(OFST+1,sp)
2702  07dc 2302          	jrule	L3401
2703                     ; 853     result = 0;
2705  07de 0f01          	clr	(OFST+0,sp)
2707  07e0               L3401:
2708                     ; 857   if (enablechecksum)
2710  07e0 0d03          	tnz	(OFST+2,sp)
2711  07e2 272f          	jreq	L5401
2712                     ; 860     if(!Receive(ReceivedData++))
2714  07e4 be00          	ldw	x,_ReceivedData
2715  07e6 1c0001        	addw	x,#1
2716  07e9 bf00          	ldw	_ReceivedData,x
2717  07eb 1d0001        	subw	x,#1
2718  07ee cd06d1        	call	_Receive
2720  07f1 4d            	tnz	a
2721  07f2 2602          	jrne	L7401
2722                     ; 861       result = 0;
2724  07f4 0f01          	clr	(OFST+0,sp)
2726  07f6               L7401:
2727                     ; 864     if((*(--ReceivedData) ^ *(--ReceivedData)) != 0xFF)
2729  07f6 be00          	ldw	x,_ReceivedData
2730  07f8 1d0001        	subw	x,#1
2731  07fb bf00          	ldw	_ReceivedData,x
2732  07fd f6            	ld	a,(x)
2733  07fe be00          	ldw	x,_ReceivedData
2734  0800 1d0001        	subw	x,#1
2735  0803 bf00          	ldw	_ReceivedData,x
2736  0805 f8            	xor	a,(x)
2737  0806 a1ff          	cp	a,#255
2738  0808 2702          	jreq	L1501
2739                     ; 865       result = 0;
2741  080a 0f01          	clr	(OFST+0,sp)
2743  080c               L1501:
2744                     ; 867     ReceivedData += 2;
2746  080c be00          	ldw	x,_ReceivedData
2747  080e 1c0002        	addw	x,#2
2748  0811 bf00          	ldw	_ReceivedData,x
2749  0813               L5401:
2750                     ; 871   if (enablechecksum)
2752  0813 0d03          	tnz	(OFST+2,sp)
2753  0815 2705          	jreq	L3501
2754                     ; 872     Transmit(ACK);
2756  0817 a679          	ld	a,#121
2757  0819 cd06a4        	call	_Transmit
2759  081c               L3501:
2760                     ; 874   return result;
2762  081c 7b01          	ld	a,(OFST+0,sp)
2765  081e 5b03          	addw	sp,#3
2766  0820 81            	ret
2789                     ; 877 void unlock_PROG(void){
2790                     	switch	.text
2791  0821               _unlock_PROG:
2795                     ; 879   FLASH->PUKR = 0x56;
2797  0821 35565062      	mov	20578,#86
2798                     ; 880   FLASH->PUKR = 0xAE;
2800  0825 35ae5062      	mov	20578,#174
2801                     ; 881   }
2804  0829 81            	ret
2827                     ; 883 void unlock_DATA(void) {
2828                     	switch	.text
2829  082a               _unlock_DATA:
2833                     ; 885 	FLASH->DUKR = 0xAE; /* Warning: keys are reversed on data memory !!! */
2835  082a 35ae5064      	mov	20580,#174
2836                     ; 886   FLASH->DUKR = 0x56;
2838  082e 35565064      	mov	20580,#86
2839                     ; 887 }
2842  0832 81            	ret
2923                     ; 899 void Mem_ProgramBlock(u16 BlockNum, FLASH_MemType_TypeDef MemType, u8 *Buffer)
2923                     ; 900 #endif /*_RAISONANCE_*/
2923                     ; 901 {
2924                     .FLASH_CODE:	section	.text
2925  0000               _Mem_ProgramBlock:
2927  0000 89            	pushw	x
2928  0001 5208          	subw	sp,#8
2929       00000008      OFST:	set	8
2932                     ; 902     u16 Count = 0;
2934                     ; 903     u32 StartAddress = 0;
2936                     ; 904     u16 timeout = (u16)0x6000;
2938  0003 ae6000        	ldw	x,#24576
2939  0006 1f01          	ldw	(OFST-7,sp),x
2941                     ; 907     if (MemType == FLASH_MEMTYPE_PROG)
2943  0008 0d0d          	tnz	(OFST+5,sp)
2944  000a 260c          	jrne	L7311
2945                     ; 909         StartAddress = FLASH_START;
2947  000c ae8000        	ldw	x,#32768
2948  000f 1f05          	ldw	(OFST-3,sp),x
2949  0011 ae0000        	ldw	x,#0
2950  0014 1f03          	ldw	(OFST-5,sp),x
2953  0016 200a          	jra	L1411
2954  0018               L7311:
2955                     ; 913         StartAddress = EEPROM_START;
2957  0018 ae4000        	ldw	x,#16384
2958  001b 1f05          	ldw	(OFST-3,sp),x
2959  001d ae0000        	ldw	x,#0
2960  0020 1f03          	ldw	(OFST-5,sp),x
2962  0022               L1411:
2963                     ; 917     StartAddress = StartAddress + ((u32)BlockNum * BLOCK_SIZE);
2965  0022 1e09          	ldw	x,(OFST+1,sp)
2966  0024 a680          	ld	a,#128
2967  0026 cd0000        	call	c_cmulx
2969  0029 96            	ldw	x,sp
2970  002a 1c0003        	addw	x,#OFST-5
2971  002d cd0000        	call	c_lgadd
2974                     ; 920     FLASH->CR2 |= (u8)0x01;
2976  0030 7210505b      	bset	20571,#0
2977                     ; 921     FLASH->NCR2 &= (u8)~0x01;
2979  0034 7211505c      	bres	20572,#0
2980                     ; 924     for (Count = 0; Count < BLOCK_SIZE; Count++)
2982  0038 5f            	clrw	x
2983  0039 1f07          	ldw	(OFST-1,sp),x
2985  003b               L3411:
2986                     ; 926         *((PointerAttr u8*)StartAddress + Count) = ((u8)(Buffer[Count]));
2988  003b 1e0e          	ldw	x,(OFST+6,sp)
2989  003d 72fb07        	addw	x,(OFST-1,sp)
2990  0040 f6            	ld	a,(x)
2991  0041 88            	push	a
2992  0042 7b05          	ld	a,(OFST-3,sp)
2993  0044 b700          	ld	c_x,a
2994  0046 1e06          	ldw	x,(OFST-2,sp)
2995  0048 84            	pop	a
2996  0049 1607          	ldw	y,(OFST-1,sp)
2997  004b bf01          	ldw	c_x+1,x
2998  004d 93            	ldw	x,y
2999  004e 92a70000      	ldf	([c_x.e],x),a
3000                     ; 924     for (Count = 0; Count < BLOCK_SIZE; Count++)
3002  0052 1e07          	ldw	x,(OFST-1,sp)
3003  0054 1c0001        	addw	x,#1
3004  0057 1f07          	ldw	(OFST-1,sp),x
3008  0059 1e07          	ldw	x,(OFST-1,sp)
3009  005b a30080        	cpw	x,#128
3010  005e 25db          	jrult	L3411
3011                     ; 930     if (MemType == FLASH_MEMTYPE_DATA)
3013  0060 7b0d          	ld	a,(OFST+5,sp)
3014  0062 a101          	cp	a,#1
3015  0064 2614          	jrne	L1511
3017  0066 2007          	jra	L5511
3018  0068               L3511:
3019                     ; 935             timeout--;
3021  0068 1e01          	ldw	x,(OFST-7,sp)
3022  006a 1d0001        	subw	x,#1
3023  006d 1f01          	ldw	(OFST-7,sp),x
3025  006f               L5511:
3026                     ; 933         while ((FLASH->IAPSR & 0x40) != 0x00 || (timeout == 0x00))
3028  006f c6505f        	ld	a,20575
3029  0072 a540          	bcp	a,#64
3030  0074 26f2          	jrne	L3511
3032  0076 1e01          	ldw	x,(OFST-7,sp)
3033  0078 27ee          	jreq	L3511
3034  007a               L1511:
3035                     ; 939 }
3038  007a 5b0a          	addw	sp,#10
3039  007c 81            	ret
3092                     ; 945 void FLASH_ProgramOptionByte(u16 Address, u8 Data){
3093                     	switch	.text
3094  0833               _FLASH_ProgramOptionByte:
3096  0833 89            	pushw	x
3097  0834 88            	push	a
3098       00000001      OFST:	set	1
3101                     ; 948   FLASH->CR2 |= (u8)0x80;
3103  0835 721e505b      	bset	20571,#7
3104                     ; 949   FLASH->NCR2 &= (u8)(~0x80);
3106  0839 721f505c      	bres	20572,#7
3107                     ; 952   *((NEAR u8*)Address) = Data;
3109  083d 7b06          	ld	a,(OFST+5,sp)
3110  083f 1e02          	ldw	x,(OFST+1,sp)
3111  0841 f7            	ld	(x),a
3112                     ; 953   *((NEAR u8*)(Address + 1)) = (u8)(~Data);
3114  0842 7b06          	ld	a,(OFST+5,sp)
3115  0844 43            	cpl	a
3116  0845 1e02          	ldw	x,(OFST+1,sp)
3117  0847 e701          	ld	(1,x),a
3118                     ; 956 	  flash_iapsr = FLASH->IAPSR ;
3120  0849 c6505f        	ld	a,20575
3121  084c 6b01          	ld	(OFST+0,sp),a
3124  084e 2005          	jra	L3121
3125  0850               L7021:
3126                     ; 957 		while (!(flash_iapsr & 0x41)) flash_iapsr = FLASH->IAPSR ;
3128  0850 c6505f        	ld	a,20575
3129  0853 6b01          	ld	(OFST+0,sp),a
3131  0855               L3121:
3134  0855 7b01          	ld	a,(OFST+0,sp)
3135  0857 a541          	bcp	a,#65
3136  0859 27f5          	jreq	L7021
3137                     ; 964   FLASH->CR2 &= (u8)(~0x80);
3139  085b 721f505b      	bres	20571,#7
3140                     ; 965   FLASH->NCR2 |= (u8)0x80;
3142  085f 721e505c      	bset	20572,#7
3143                     ; 966 }
3146  0863 5b03          	addw	sp,#3
3147  0865 81            	ret
3150                     	switch	.const
3151  001e               L7121_HSIDivFactor:
3152  001e 01            	dc.b	1
3153  001f 02            	dc.b	2
3154  0020 04            	dc.b	4
3155  0021 08            	dc.b	8
3215                     ; 969 u32 CLK_GetClockFreq(void)
3215                     ; 970 {
3216                     	switch	.text
3217  0866               _CLK_GetClockFreq:
3219  0866 520d          	subw	sp,#13
3220       0000000d      OFST:	set	13
3223                     ; 971 	uc8 HSIDivFactor[4] = {1, 2, 4, 8}; /* Holds the different HSI Dividor factors */
3225  0868 96            	ldw	x,sp
3226  0869 1c0005        	addw	x,#OFST-8
3227  086c 90ae001e      	ldw	y,#L7121_HSIDivFactor
3228  0870 a604          	ld	a,#4
3229  0872 cd0000        	call	c_xymov
3231                     ; 972 	u32 clockfrequency = 0;
3233                     ; 973 	u8 tmp = 0, presc = 0;
3237                     ; 974 	tmp = (u8)(CLK->CKDIVR & 0x18);
3239  0875 c650c6        	ld	a,20678
3240  0878 a418          	and	a,#24
3241  087a 6b0d          	ld	(OFST+0,sp),a
3243                     ; 975 	tmp = (u8)(tmp >> 3);
3245  087c 040d          	srl	(OFST+0,sp)
3246  087e 040d          	srl	(OFST+0,sp)
3247  0880 040d          	srl	(OFST+0,sp)
3249                     ; 976 	presc = HSIDivFactor[tmp];
3251  0882 96            	ldw	x,sp
3252  0883 1c0005        	addw	x,#OFST-8
3253  0886 9f            	ld	a,xl
3254  0887 5e            	swapw	x
3255  0888 1b0d          	add	a,(OFST+0,sp)
3256  088a 2401          	jrnc	L021
3257  088c 5c            	incw	x
3258  088d               L021:
3259  088d 02            	rlwa	x,a
3260  088e f6            	ld	a,(x)
3261  088f 6b0d          	ld	(OFST+0,sp),a
3263                     ; 977 	clockfrequency = 16000000 / presc;
3265  0891 7b0d          	ld	a,(OFST+0,sp)
3266  0893 b703          	ld	c_lreg+3,a
3267  0895 3f02          	clr	c_lreg+2
3268  0897 3f01          	clr	c_lreg+1
3269  0899 3f00          	clr	c_lreg
3270  089b 96            	ldw	x,sp
3271  089c 1c0001        	addw	x,#OFST-12
3272  089f cd0000        	call	c_rtol
3275  08a2 ae2400        	ldw	x,#9216
3276  08a5 bf02          	ldw	c_lreg+2,x
3277  08a7 ae00f4        	ldw	x,#244
3278  08aa bf00          	ldw	c_lreg,x
3279  08ac 96            	ldw	x,sp
3280  08ad 1c0001        	addw	x,#OFST-12
3281  08b0 cd0000        	call	c_ldiv
3283  08b3 96            	ldw	x,sp
3284  08b4 1c0009        	addw	x,#OFST-4
3285  08b7 cd0000        	call	c_rtol
3288                     ; 978 	return((u32)clockfrequency);
3290  08ba 96            	ldw	x,sp
3291  08bb 1c0009        	addw	x,#OFST-4
3292  08be cd0000        	call	c_ltor
3296  08c1 5b0d          	addw	sp,#13
3297  08c3 81            	ret
3364                     	xdef	_CheckAddress
3365                     	xdef	_CLK_GetClockFreq
3366                     	xdef	_Mem_ProgramBlock
3367                     	xdef	_FLASH_ProgramOptionByte
3368                     	xdef	_unlock_DATA
3369                     	xdef	_unlock_PROG
3370                     	xdef	_ReceiveCount
3371                     	xdef	_ReceiveAddress
3372                     	xdef	_Receive
3373                     	xdef	_Transmit
3374                     	xdef	_Master_ident
3375                     	xdef	_protocol_init
3376                     	xdef	_DeInitBootloader
3377                     	xdef	_WriteBufferFlash
3378                     	xdef	_WriteBuffer
3379                     	xdef	_GO_Command_Process
3380                     	xdef	_WM_Command_Process
3381                     	xdef	_RM_Command_Process
3382                     	xdef	_GT_Command_Process
3383                     	xdef	_ProcessCommands
3384                     	xdef	_main
3385                     	xref	__fctcpy
3386                     	xdef	_RoutinesInRAM
3387                     	switch	.ubsct
3388  0000               _ReceivedData:
3389  0000 0000          	ds.b	2
3390                     	xdef	_ReceivedData
3391  0002               _DataBuffer:
3392  0002 000000000000  	ds.b	130
3393                     	xdef	_DataBuffer
3394  0084               _GoAddress:
3395  0084 0000          	ds.b	2
3396                     	xdef	_GoAddress
3397                     	xdef	_MainUserApplication
3398                     	xref.b	c_lreg
3399                     	xref.b	c_x
3419                     	xref	c_ldiv
3420                     	xref	c_xymov
3421                     	xref	c_lgadd
3422                     	xref	c_cmulx
3423                     	xref	c_lursh
3424                     	xref	c_lsub
3425                     	xref	c_lgadc
3426                     	xref	c_rtol
3427                     	xref	c_lsbc
3428                     	xref	c_ladc
3429                     	xref	c_lcmp
3430                     	xref	c_ltor
3431                     	end
