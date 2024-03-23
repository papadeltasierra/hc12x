   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.1 - 31 Jan 2024
   3                     ; Generator (Limited) V4.6.1 - 31 Jan 2024
  43                     ; 53 void UART1_DeInit(void)
  43                     ; 54 {
  45                     	switch	.text
  46  0000               _UART1_DeInit:
  50                     ; 57   (void)UART1->SR;
  52  0000 c65230        	ld	a,21040
  53                     ; 58   (void)UART1->DR;
  55  0003 c65231        	ld	a,21041
  56                     ; 60   UART1->BRR2 = UART1_BRR2_RESET_VALUE;  /* Set UART1_BRR2 to reset value 0x00 */
  58  0006 725f5233      	clr	21043
  59                     ; 61   UART1->BRR1 = UART1_BRR1_RESET_VALUE;  /* Set UART1_BRR1 to reset value 0x00 */
  61  000a 725f5232      	clr	21042
  62                     ; 63   UART1->CR1 = UART1_CR1_RESET_VALUE;  /* Set UART1_CR1 to reset value 0x00 */
  64  000e 725f5234      	clr	21044
  65                     ; 64   UART1->CR2 = UART1_CR2_RESET_VALUE;  /* Set UART1_CR2 to reset value 0x00 */
  67  0012 725f5235      	clr	21045
  68                     ; 65   UART1->CR3 = UART1_CR3_RESET_VALUE;  /* Set UART1_CR3 to reset value 0x00 */
  70  0016 725f5236      	clr	21046
  71                     ; 66   UART1->CR4 = UART1_CR4_RESET_VALUE;  /* Set UART1_CR4 to reset value 0x00 */
  73  001a 725f5237      	clr	21047
  74                     ; 67   UART1->CR5 = UART1_CR5_RESET_VALUE;  /* Set UART1_CR5 to reset value 0x00 */
  76  001e 725f5238      	clr	21048
  77                     ; 69   UART1->GTR = UART1_GTR_RESET_VALUE;
  79  0022 725f5239      	clr	21049
  80                     ; 70   UART1->PSCR = UART1_PSCR_RESET_VALUE;
  82  0026 725f523a      	clr	21050
  83                     ; 71 }
  86  002a 81            	ret
 389                     .const:	section	.text
 390  0000               L01:
 391  0000 00000064      	dc.l	100
 392                     ; 90 void UART1_Init(uint32_t BaudRate, UART1_WordLength_TypeDef WordLength, 
 392                     ; 91                 UART1_StopBits_TypeDef StopBits, UART1_Parity_TypeDef Parity, 
 392                     ; 92                 UART1_SyncMode_TypeDef SyncMode, UART1_Mode_TypeDef Mode)
 392                     ; 93 {
 393                     	switch	.text
 394  002b               _UART1_Init:
 396  002b 520c          	subw	sp,#12
 397       0000000c      OFST:	set	12
 400                     ; 94   uint32_t BaudRate_Mantissa = 0, BaudRate_Mantissa100 = 0;
 404                     ; 97   assert_param(IS_UART1_BAUDRATE_OK(BaudRate));
 406                     ; 98   assert_param(IS_UART1_WORDLENGTH_OK(WordLength));
 408                     ; 99   assert_param(IS_UART1_STOPBITS_OK(StopBits));
 410                     ; 100   assert_param(IS_UART1_PARITY_OK(Parity));
 412                     ; 101   assert_param(IS_UART1_MODE_OK((uint8_t)Mode));
 414                     ; 102   assert_param(IS_UART1_SYNCMODE_OK((uint8_t)SyncMode));
 416                     ; 105   UART1->CR1 &= (uint8_t)(~UART1_CR1_M);  
 418  002d 72195234      	bres	21044,#4
 419                     ; 108   UART1->CR1 |= (uint8_t)WordLength;
 421  0031 c65234        	ld	a,21044
 422  0034 1a13          	or	a,(OFST+7,sp)
 423  0036 c75234        	ld	21044,a
 424                     ; 111   UART1->CR3 &= (uint8_t)(~UART1_CR3_STOP);  
 426  0039 c65236        	ld	a,21046
 427  003c a4cf          	and	a,#207
 428  003e c75236        	ld	21046,a
 429                     ; 113   UART1->CR3 |= (uint8_t)StopBits;  
 431  0041 c65236        	ld	a,21046
 432  0044 1a14          	or	a,(OFST+8,sp)
 433  0046 c75236        	ld	21046,a
 434                     ; 116   UART1->CR1 &= (uint8_t)(~(UART1_CR1_PCEN | UART1_CR1_PS  ));  
 436  0049 c65234        	ld	a,21044
 437  004c a4f9          	and	a,#249
 438  004e c75234        	ld	21044,a
 439                     ; 118   UART1->CR1 |= (uint8_t)Parity;  
 441  0051 c65234        	ld	a,21044
 442  0054 1a15          	or	a,(OFST+9,sp)
 443  0056 c75234        	ld	21044,a
 444                     ; 121   UART1->BRR1 &= (uint8_t)(~UART1_BRR1_DIVM);  
 446  0059 725f5232      	clr	21042
 447                     ; 123   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVM);  
 449  005d c65233        	ld	a,21043
 450  0060 a40f          	and	a,#15
 451  0062 c75233        	ld	21043,a
 452                     ; 125   UART1->BRR2 &= (uint8_t)(~UART1_BRR2_DIVF);  
 454  0065 c65233        	ld	a,21043
 455  0068 a4f0          	and	a,#240
 456  006a c75233        	ld	21043,a
 457                     ; 128   BaudRate_Mantissa    = ((uint32_t)CLK_GetClockFreq() / (BaudRate << 4));
 459  006d 96            	ldw	x,sp
 460  006e 1c000f        	addw	x,#OFST+3
 461  0071 cd0000        	call	c_ltor
 463  0074 a604          	ld	a,#4
 464  0076 cd0000        	call	c_llsh
 466  0079 96            	ldw	x,sp
 467  007a 1c0001        	addw	x,#OFST-11
 468  007d cd0000        	call	c_rtol
 471  0080 cd0000        	call	_CLK_GetClockFreq
 473  0083 96            	ldw	x,sp
 474  0084 1c0001        	addw	x,#OFST-11
 475  0087 cd0000        	call	c_ludv
 477  008a 96            	ldw	x,sp
 478  008b 1c0009        	addw	x,#OFST-3
 479  008e cd0000        	call	c_rtol
 482                     ; 129   BaudRate_Mantissa100 = (((uint32_t)CLK_GetClockFreq() * 100) / (BaudRate << 4));
 484  0091 96            	ldw	x,sp
 485  0092 1c000f        	addw	x,#OFST+3
 486  0095 cd0000        	call	c_ltor
 488  0098 a604          	ld	a,#4
 489  009a cd0000        	call	c_llsh
 491  009d 96            	ldw	x,sp
 492  009e 1c0001        	addw	x,#OFST-11
 493  00a1 cd0000        	call	c_rtol
 496  00a4 cd0000        	call	_CLK_GetClockFreq
 498  00a7 a664          	ld	a,#100
 499  00a9 cd0000        	call	c_smul
 501  00ac 96            	ldw	x,sp
 502  00ad 1c0001        	addw	x,#OFST-11
 503  00b0 cd0000        	call	c_ludv
 505  00b3 96            	ldw	x,sp
 506  00b4 1c0005        	addw	x,#OFST-7
 507  00b7 cd0000        	call	c_rtol
 510                     ; 131   UART1->BRR2 |= (uint8_t)((uint8_t)(((BaudRate_Mantissa100 - (BaudRate_Mantissa * 100)) << 4) / 100) & (uint8_t)0x0F); 
 512  00ba 96            	ldw	x,sp
 513  00bb 1c0009        	addw	x,#OFST-3
 514  00be cd0000        	call	c_ltor
 516  00c1 a664          	ld	a,#100
 517  00c3 cd0000        	call	c_smul
 519  00c6 96            	ldw	x,sp
 520  00c7 1c0001        	addw	x,#OFST-11
 521  00ca cd0000        	call	c_rtol
 524  00cd 96            	ldw	x,sp
 525  00ce 1c0005        	addw	x,#OFST-7
 526  00d1 cd0000        	call	c_ltor
 528  00d4 96            	ldw	x,sp
 529  00d5 1c0001        	addw	x,#OFST-11
 530  00d8 cd0000        	call	c_lsub
 532  00db a604          	ld	a,#4
 533  00dd cd0000        	call	c_llsh
 535  00e0 ae0000        	ldw	x,#L01
 536  00e3 cd0000        	call	c_ludv
 538  00e6 b603          	ld	a,c_lreg+3
 539  00e8 a40f          	and	a,#15
 540  00ea ca5233        	or	a,21043
 541  00ed c75233        	ld	21043,a
 542                     ; 133   UART1->BRR2 |= (uint8_t)((BaudRate_Mantissa >> 4) & (uint8_t)0xF0); 
 544  00f0 1e0b          	ldw	x,(OFST-1,sp)
 545  00f2 54            	srlw	x
 546  00f3 54            	srlw	x
 547  00f4 54            	srlw	x
 548  00f5 54            	srlw	x
 549  00f6 01            	rrwa	x,a
 550  00f7 a4f0          	and	a,#240
 551  00f9 5f            	clrw	x
 552  00fa ca5233        	or	a,21043
 553  00fd c75233        	ld	21043,a
 554                     ; 135   UART1->BRR1 |= (uint8_t)BaudRate_Mantissa;           
 556  0100 c65232        	ld	a,21042
 557  0103 1a0c          	or	a,(OFST+0,sp)
 558  0105 c75232        	ld	21042,a
 559                     ; 138   UART1->CR2 &= (uint8_t)~(UART1_CR2_TEN | UART1_CR2_REN); 
 561  0108 c65235        	ld	a,21045
 562  010b a4f3          	and	a,#243
 563  010d c75235        	ld	21045,a
 564                     ; 140   UART1->CR3 &= (uint8_t)~(UART1_CR3_CPOL | UART1_CR3_CPHA | UART1_CR3_LBCL); 
 566  0110 c65236        	ld	a,21046
 567  0113 a4f8          	and	a,#248
 568  0115 c75236        	ld	21046,a
 569                     ; 142   UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & (uint8_t)(UART1_CR3_CPOL | 
 569                     ; 143                                                         UART1_CR3_CPHA | UART1_CR3_LBCL));  
 571  0118 7b16          	ld	a,(OFST+10,sp)
 572  011a a407          	and	a,#7
 573  011c ca5236        	or	a,21046
 574  011f c75236        	ld	21046,a
 575                     ; 145   if ((uint8_t)(Mode & UART1_MODE_TX_ENABLE))
 577  0122 7b17          	ld	a,(OFST+11,sp)
 578  0124 a504          	bcp	a,#4
 579  0126 2706          	jreq	L371
 580                     ; 148     UART1->CR2 |= (uint8_t)UART1_CR2_TEN;  
 582  0128 72165235      	bset	21045,#3
 584  012c 2004          	jra	L571
 585  012e               L371:
 586                     ; 153     UART1->CR2 &= (uint8_t)(~UART1_CR2_TEN);  
 588  012e 72175235      	bres	21045,#3
 589  0132               L571:
 590                     ; 155   if ((uint8_t)(Mode & UART1_MODE_RX_ENABLE))
 592  0132 7b17          	ld	a,(OFST+11,sp)
 593  0134 a508          	bcp	a,#8
 594  0136 2706          	jreq	L771
 595                     ; 158     UART1->CR2 |= (uint8_t)UART1_CR2_REN;  
 597  0138 72145235      	bset	21045,#2
 599  013c 2004          	jra	L102
 600  013e               L771:
 601                     ; 163     UART1->CR2 &= (uint8_t)(~UART1_CR2_REN);  
 603  013e 72155235      	bres	21045,#2
 604  0142               L102:
 605                     ; 167   if ((uint8_t)(SyncMode & UART1_SYNCMODE_CLOCK_DISABLE))
 607  0142 7b16          	ld	a,(OFST+10,sp)
 608  0144 a580          	bcp	a,#128
 609  0146 2706          	jreq	L302
 610                     ; 170     UART1->CR3 &= (uint8_t)(~UART1_CR3_CKEN); 
 612  0148 72175236      	bres	21046,#3
 614  014c 200a          	jra	L502
 615  014e               L302:
 616                     ; 174     UART1->CR3 |= (uint8_t)((uint8_t)SyncMode & UART1_CR3_CKEN);
 618  014e 7b16          	ld	a,(OFST+10,sp)
 619  0150 a408          	and	a,#8
 620  0152 ca5236        	or	a,21046
 621  0155 c75236        	ld	21046,a
 622  0158               L502:
 623                     ; 176 }
 626  0158 5b0c          	addw	sp,#12
 627  015a 81            	ret
 682                     ; 184 void UART1_Cmd(FunctionalState NewState)
 682                     ; 185 {
 683                     	switch	.text
 684  015b               _UART1_Cmd:
 688                     ; 186   if (NewState != DISABLE)
 690  015b 4d            	tnz	a
 691  015c 2706          	jreq	L532
 692                     ; 189     UART1->CR1 &= (uint8_t)(~UART1_CR1_UARTD); 
 694  015e 721b5234      	bres	21044,#5
 696  0162 2004          	jra	L732
 697  0164               L532:
 698                     ; 194     UART1->CR1 |= UART1_CR1_UARTD;  
 700  0164 721a5234      	bset	21044,#5
 701  0168               L732:
 702                     ; 196 }
 705  0168 81            	ret
 830                     ; 211 void UART1_ITConfig(UART1_IT_TypeDef UART1_IT, FunctionalState NewState)
 830                     ; 212 {
 831                     	switch	.text
 832  0169               _UART1_ITConfig:
 834  0169 89            	pushw	x
 835  016a 89            	pushw	x
 836       00000002      OFST:	set	2
 839                     ; 213   uint8_t uartreg = 0, itpos = 0x00;
 843                     ; 216   assert_param(IS_UART1_CONFIG_IT_OK(UART1_IT));
 845                     ; 217   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 847                     ; 220   uartreg = (uint8_t)((uint16_t)UART1_IT >> 0x08);
 849  016b 9e            	ld	a,xh
 850  016c 6b01          	ld	(OFST-1,sp),a
 852                     ; 222   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
 854  016e 9f            	ld	a,xl
 855  016f a40f          	and	a,#15
 856  0171 5f            	clrw	x
 857  0172 97            	ld	xl,a
 858  0173 a601          	ld	a,#1
 859  0175 5d            	tnzw	x
 860  0176 2704          	jreq	L61
 861  0178               L02:
 862  0178 48            	sll	a
 863  0179 5a            	decw	x
 864  017a 26fc          	jrne	L02
 865  017c               L61:
 866  017c 6b02          	ld	(OFST+0,sp),a
 868                     ; 224   if (NewState != DISABLE)
 870  017e 0d07          	tnz	(OFST+5,sp)
 871  0180 272a          	jreq	L713
 872                     ; 227     if (uartreg == 0x01)
 874  0182 7b01          	ld	a,(OFST-1,sp)
 875  0184 a101          	cp	a,#1
 876  0186 260a          	jrne	L123
 877                     ; 229       UART1->CR1 |= itpos;
 879  0188 c65234        	ld	a,21044
 880  018b 1a02          	or	a,(OFST+0,sp)
 881  018d c75234        	ld	21044,a
 883  0190 2045          	jra	L133
 884  0192               L123:
 885                     ; 231     else if (uartreg == 0x02)
 887  0192 7b01          	ld	a,(OFST-1,sp)
 888  0194 a102          	cp	a,#2
 889  0196 260a          	jrne	L523
 890                     ; 233       UART1->CR2 |= itpos;
 892  0198 c65235        	ld	a,21045
 893  019b 1a02          	or	a,(OFST+0,sp)
 894  019d c75235        	ld	21045,a
 896  01a0 2035          	jra	L133
 897  01a2               L523:
 898                     ; 237       UART1->CR4 |= itpos;
 900  01a2 c65237        	ld	a,21047
 901  01a5 1a02          	or	a,(OFST+0,sp)
 902  01a7 c75237        	ld	21047,a
 903  01aa 202b          	jra	L133
 904  01ac               L713:
 905                     ; 243     if (uartreg == 0x01)
 907  01ac 7b01          	ld	a,(OFST-1,sp)
 908  01ae a101          	cp	a,#1
 909  01b0 260b          	jrne	L333
 910                     ; 245       UART1->CR1 &= (uint8_t)(~itpos);
 912  01b2 7b02          	ld	a,(OFST+0,sp)
 913  01b4 43            	cpl	a
 914  01b5 c45234        	and	a,21044
 915  01b8 c75234        	ld	21044,a
 917  01bb 201a          	jra	L133
 918  01bd               L333:
 919                     ; 247     else if (uartreg == 0x02)
 921  01bd 7b01          	ld	a,(OFST-1,sp)
 922  01bf a102          	cp	a,#2
 923  01c1 260b          	jrne	L733
 924                     ; 249       UART1->CR2 &= (uint8_t)(~itpos);
 926  01c3 7b02          	ld	a,(OFST+0,sp)
 927  01c5 43            	cpl	a
 928  01c6 c45235        	and	a,21045
 929  01c9 c75235        	ld	21045,a
 931  01cc 2009          	jra	L133
 932  01ce               L733:
 933                     ; 253       UART1->CR4 &= (uint8_t)(~itpos);
 935  01ce 7b02          	ld	a,(OFST+0,sp)
 936  01d0 43            	cpl	a
 937  01d1 c45237        	and	a,21047
 938  01d4 c75237        	ld	21047,a
 939  01d7               L133:
 940                     ; 257 }
 943  01d7 5b04          	addw	sp,#4
 944  01d9 81            	ret
 980                     ; 265 void UART1_HalfDuplexCmd(FunctionalState NewState)
 980                     ; 266 {
 981                     	switch	.text
 982  01da               _UART1_HalfDuplexCmd:
 986                     ; 267   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 988                     ; 269   if (NewState != DISABLE)
 990  01da 4d            	tnz	a
 991  01db 2706          	jreq	L163
 992                     ; 271     UART1->CR5 |= UART1_CR5_HDSEL;  /**< UART1 Half Duplex Enable  */
 994  01dd 72165238      	bset	21048,#3
 996  01e1 2004          	jra	L363
 997  01e3               L163:
 998                     ; 275     UART1->CR5 &= (uint8_t)~UART1_CR5_HDSEL; /**< UART1 Half Duplex Disable */
1000  01e3 72175238      	bres	21048,#3
1001  01e7               L363:
1002                     ; 277 }
1005  01e7 81            	ret
1062                     ; 285 void UART1_IrDAConfig(UART1_IrDAMode_TypeDef UART1_IrDAMode)
1062                     ; 286 {
1063                     	switch	.text
1064  01e8               _UART1_IrDAConfig:
1068                     ; 287   assert_param(IS_UART1_IRDAMODE_OK(UART1_IrDAMode));
1070                     ; 289   if (UART1_IrDAMode != UART1_IRDAMODE_NORMAL)
1072  01e8 4d            	tnz	a
1073  01e9 2706          	jreq	L314
1074                     ; 291     UART1->CR5 |= UART1_CR5_IRLP;
1076  01eb 72145238      	bset	21048,#2
1078  01ef 2004          	jra	L514
1079  01f1               L314:
1080                     ; 295     UART1->CR5 &= ((uint8_t)~UART1_CR5_IRLP);
1082  01f1 72155238      	bres	21048,#2
1083  01f5               L514:
1084                     ; 297 }
1087  01f5 81            	ret
1122                     ; 305 void UART1_IrDACmd(FunctionalState NewState)
1122                     ; 306 {
1123                     	switch	.text
1124  01f6               _UART1_IrDACmd:
1128                     ; 308   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1130                     ; 310   if (NewState != DISABLE)
1132  01f6 4d            	tnz	a
1133  01f7 2706          	jreq	L534
1134                     ; 313     UART1->CR5 |= UART1_CR5_IREN;
1136  01f9 72125238      	bset	21048,#1
1138  01fd 2004          	jra	L734
1139  01ff               L534:
1140                     ; 318     UART1->CR5 &= ((uint8_t)~UART1_CR5_IREN);
1142  01ff 72135238      	bres	21048,#1
1143  0203               L734:
1144                     ; 320 }
1147  0203 81            	ret
1206                     ; 329 void UART1_LINBreakDetectionConfig(UART1_LINBreakDetectionLength_TypeDef UART1_LINBreakDetectionLength)
1206                     ; 330 {
1207                     	switch	.text
1208  0204               _UART1_LINBreakDetectionConfig:
1212                     ; 331   assert_param(IS_UART1_LINBREAKDETECTIONLENGTH_OK(UART1_LINBreakDetectionLength));
1214                     ; 333   if (UART1_LINBreakDetectionLength != UART1_LINBREAKDETECTIONLENGTH_10BITS)
1216  0204 4d            	tnz	a
1217  0205 2706          	jreq	L764
1218                     ; 335     UART1->CR4 |= UART1_CR4_LBDL;
1220  0207 721a5237      	bset	21047,#5
1222  020b 2004          	jra	L174
1223  020d               L764:
1224                     ; 339     UART1->CR4 &= ((uint8_t)~UART1_CR4_LBDL);
1226  020d 721b5237      	bres	21047,#5
1227  0211               L174:
1228                     ; 341 }
1231  0211 81            	ret
1266                     ; 349 void UART1_LINCmd(FunctionalState NewState)
1266                     ; 350 {
1267                     	switch	.text
1268  0212               _UART1_LINCmd:
1272                     ; 351   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1274                     ; 353   if (NewState != DISABLE)
1276  0212 4d            	tnz	a
1277  0213 2706          	jreq	L115
1278                     ; 356     UART1->CR3 |= UART1_CR3_LINEN;
1280  0215 721c5236      	bset	21046,#6
1282  0219 2004          	jra	L315
1283  021b               L115:
1284                     ; 361     UART1->CR3 &= ((uint8_t)~UART1_CR3_LINEN);
1286  021b 721d5236      	bres	21046,#6
1287  021f               L315:
1288                     ; 363 }
1291  021f 81            	ret
1326                     ; 371 void UART1_SmartCardCmd(FunctionalState NewState)
1326                     ; 372 {
1327                     	switch	.text
1328  0220               _UART1_SmartCardCmd:
1332                     ; 373   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1334                     ; 375   if (NewState != DISABLE)
1336  0220 4d            	tnz	a
1337  0221 2706          	jreq	L335
1338                     ; 378     UART1->CR5 |= UART1_CR5_SCEN;
1340  0223 721a5238      	bset	21048,#5
1342  0227 2004          	jra	L535
1343  0229               L335:
1344                     ; 383     UART1->CR5 &= ((uint8_t)(~UART1_CR5_SCEN));
1346  0229 721b5238      	bres	21048,#5
1347  022d               L535:
1348                     ; 385 }
1351  022d 81            	ret
1387                     ; 394 void UART1_SmartCardNACKCmd(FunctionalState NewState)
1387                     ; 395 {
1388                     	switch	.text
1389  022e               _UART1_SmartCardNACKCmd:
1393                     ; 396   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1395                     ; 398   if (NewState != DISABLE)
1397  022e 4d            	tnz	a
1398  022f 2706          	jreq	L555
1399                     ; 401     UART1->CR5 |= UART1_CR5_NACK;
1401  0231 72185238      	bset	21048,#4
1403  0235 2004          	jra	L755
1404  0237               L555:
1405                     ; 406     UART1->CR5 &= ((uint8_t)~(UART1_CR5_NACK));
1407  0237 72195238      	bres	21048,#4
1408  023b               L755:
1409                     ; 408 }
1412  023b 81            	ret
1469                     ; 416 void UART1_WakeUpConfig(UART1_WakeUp_TypeDef UART1_WakeUp)
1469                     ; 417 {
1470                     	switch	.text
1471  023c               _UART1_WakeUpConfig:
1475                     ; 418   assert_param(IS_UART1_WAKEUP_OK(UART1_WakeUp));
1477                     ; 420   UART1->CR1 &= ((uint8_t)~UART1_CR1_WAKE);
1479  023c 72175234      	bres	21044,#3
1480                     ; 421   UART1->CR1 |= (uint8_t)UART1_WakeUp;
1482  0240 ca5234        	or	a,21044
1483  0243 c75234        	ld	21044,a
1484                     ; 422 }
1487  0246 81            	ret
1523                     ; 430 void UART1_ReceiverWakeUpCmd(FunctionalState NewState)
1523                     ; 431 {
1524                     	switch	.text
1525  0247               _UART1_ReceiverWakeUpCmd:
1529                     ; 432   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1531                     ; 434   if (NewState != DISABLE)
1533  0247 4d            	tnz	a
1534  0248 2706          	jreq	L526
1535                     ; 437     UART1->CR2 |= UART1_CR2_RWU;
1537  024a 72125235      	bset	21045,#1
1539  024e 2004          	jra	L726
1540  0250               L526:
1541                     ; 442     UART1->CR2 &= ((uint8_t)~UART1_CR2_RWU);
1543  0250 72135235      	bres	21045,#1
1544  0254               L726:
1545                     ; 444 }
1548  0254 81            	ret
1571                     ; 451 uint8_t UART1_ReceiveData8(void)
1571                     ; 452 {
1572                     	switch	.text
1573  0255               _UART1_ReceiveData8:
1577                     ; 453   return ((uint8_t)UART1->DR);
1579  0255 c65231        	ld	a,21041
1582  0258 81            	ret
1616                     ; 461 uint16_t UART1_ReceiveData9(void)
1616                     ; 462 {
1617                     	switch	.text
1618  0259               _UART1_ReceiveData9:
1620  0259 89            	pushw	x
1621       00000002      OFST:	set	2
1624                     ; 463   uint16_t temp = 0;
1626                     ; 465   temp = (uint16_t)(((uint16_t)( (uint16_t)UART1->CR1 & (uint16_t)UART1_CR1_R8)) << 1);
1628  025a c65234        	ld	a,21044
1629  025d 5f            	clrw	x
1630  025e a480          	and	a,#128
1631  0260 5f            	clrw	x
1632  0261 02            	rlwa	x,a
1633  0262 58            	sllw	x
1634  0263 1f01          	ldw	(OFST-1,sp),x
1636                     ; 466   return (uint16_t)( (((uint16_t) UART1->DR) | temp ) & ((uint16_t)0x01FF));
1638  0265 c65231        	ld	a,21041
1639  0268 5f            	clrw	x
1640  0269 97            	ld	xl,a
1641  026a 01            	rrwa	x,a
1642  026b 1a02          	or	a,(OFST+0,sp)
1643  026d 01            	rrwa	x,a
1644  026e 1a01          	or	a,(OFST-1,sp)
1645  0270 01            	rrwa	x,a
1646  0271 01            	rrwa	x,a
1647  0272 a4ff          	and	a,#255
1648  0274 01            	rrwa	x,a
1649  0275 a401          	and	a,#1
1650  0277 01            	rrwa	x,a
1653  0278 5b02          	addw	sp,#2
1654  027a 81            	ret
1688                     ; 474 void UART1_SendData8(uint8_t Data)
1688                     ; 475 {
1689                     	switch	.text
1690  027b               _UART1_SendData8:
1694                     ; 477   UART1->DR = Data;
1696  027b c75231        	ld	21041,a
1697                     ; 478 }
1700  027e 81            	ret
1734                     ; 486 void UART1_SendData9(uint16_t Data)
1734                     ; 487 {
1735                     	switch	.text
1736  027f               _UART1_SendData9:
1738  027f 89            	pushw	x
1739       00000000      OFST:	set	0
1742                     ; 489   UART1->CR1 &= ((uint8_t)~UART1_CR1_T8);
1744  0280 721d5234      	bres	21044,#6
1745                     ; 491   UART1->CR1 |= (uint8_t)(((uint8_t)(Data >> 2)) & UART1_CR1_T8);
1747  0284 54            	srlw	x
1748  0285 54            	srlw	x
1749  0286 9f            	ld	a,xl
1750  0287 a440          	and	a,#64
1751  0289 ca5234        	or	a,21044
1752  028c c75234        	ld	21044,a
1753                     ; 493   UART1->DR   = (uint8_t)(Data);
1755  028f 7b02          	ld	a,(OFST+2,sp)
1756  0291 c75231        	ld	21041,a
1757                     ; 494 }
1760  0294 85            	popw	x
1761  0295 81            	ret
1784                     ; 501 void UART1_SendBreak(void)
1784                     ; 502 {
1785                     	switch	.text
1786  0296               _UART1_SendBreak:
1790                     ; 503   UART1->CR2 |= UART1_CR2_SBK;
1792  0296 72105235      	bset	21045,#0
1793                     ; 504 }
1796  029a 81            	ret
1830                     ; 511 void UART1_SetAddress(uint8_t UART1_Address)
1830                     ; 512 {
1831                     	switch	.text
1832  029b               _UART1_SetAddress:
1834  029b 88            	push	a
1835       00000000      OFST:	set	0
1838                     ; 514   assert_param(IS_UART1_ADDRESS_OK(UART1_Address));
1840                     ; 517   UART1->CR4 &= ((uint8_t)~UART1_CR4_ADD);
1842  029c c65237        	ld	a,21047
1843  029f a4f0          	and	a,#240
1844  02a1 c75237        	ld	21047,a
1845                     ; 519   UART1->CR4 |= UART1_Address;
1847  02a4 c65237        	ld	a,21047
1848  02a7 1a01          	or	a,(OFST+1,sp)
1849  02a9 c75237        	ld	21047,a
1850                     ; 520 }
1853  02ac 84            	pop	a
1854  02ad 81            	ret
1888                     ; 528 void UART1_SetGuardTime(uint8_t UART1_GuardTime)
1888                     ; 529 {
1889                     	switch	.text
1890  02ae               _UART1_SetGuardTime:
1894                     ; 531   UART1->GTR = UART1_GuardTime;
1896  02ae c75239        	ld	21049,a
1897                     ; 532 }
1900  02b1 81            	ret
1934                     ; 556 void UART1_SetPrescaler(uint8_t UART1_Prescaler)
1934                     ; 557 {
1935                     	switch	.text
1936  02b2               _UART1_SetPrescaler:
1940                     ; 559   UART1->PSCR = UART1_Prescaler;
1942  02b2 c7523a        	ld	21050,a
1943                     ; 560 }
1946  02b5 81            	ret
2089                     ; 568 FlagStatus UART1_GetFlagStatus(UART1_Flag_TypeDef UART1_FLAG)
2089                     ; 569 {
2090                     	switch	.text
2091  02b6               _UART1_GetFlagStatus:
2093  02b6 89            	pushw	x
2094  02b7 88            	push	a
2095       00000001      OFST:	set	1
2098                     ; 570   FlagStatus status = RESET;
2100                     ; 573   assert_param(IS_UART1_FLAG_OK(UART1_FLAG));
2102                     ; 577   if (UART1_FLAG == UART1_FLAG_LBDF)
2104  02b8 a30210        	cpw	x,#528
2105  02bb 2610          	jrne	L7501
2106                     ; 579     if ((UART1->CR4 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
2108  02bd 9f            	ld	a,xl
2109  02be c45237        	and	a,21047
2110  02c1 2706          	jreq	L1601
2111                     ; 582       status = SET;
2113  02c3 a601          	ld	a,#1
2114  02c5 6b01          	ld	(OFST+0,sp),a
2117  02c7 202b          	jra	L5601
2118  02c9               L1601:
2119                     ; 587       status = RESET;
2121  02c9 0f01          	clr	(OFST+0,sp)
2123  02cb 2027          	jra	L5601
2124  02cd               L7501:
2125                     ; 590   else if (UART1_FLAG == UART1_FLAG_SBK)
2127  02cd 1e02          	ldw	x,(OFST+1,sp)
2128  02cf a30101        	cpw	x,#257
2129  02d2 2611          	jrne	L7601
2130                     ; 592     if ((UART1->CR2 & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
2132  02d4 c65235        	ld	a,21045
2133  02d7 1503          	bcp	a,(OFST+2,sp)
2134  02d9 2706          	jreq	L1701
2135                     ; 595       status = SET;
2137  02db a601          	ld	a,#1
2138  02dd 6b01          	ld	(OFST+0,sp),a
2141  02df 2013          	jra	L5601
2142  02e1               L1701:
2143                     ; 600       status = RESET;
2145  02e1 0f01          	clr	(OFST+0,sp)
2147  02e3 200f          	jra	L5601
2148  02e5               L7601:
2149                     ; 605     if ((UART1->SR & (uint8_t)UART1_FLAG) != (uint8_t)0x00)
2151  02e5 c65230        	ld	a,21040
2152  02e8 1503          	bcp	a,(OFST+2,sp)
2153  02ea 2706          	jreq	L7701
2154                     ; 608       status = SET;
2156  02ec a601          	ld	a,#1
2157  02ee 6b01          	ld	(OFST+0,sp),a
2160  02f0 2002          	jra	L5601
2161  02f2               L7701:
2162                     ; 613       status = RESET;
2164  02f2 0f01          	clr	(OFST+0,sp)
2166  02f4               L5601:
2167                     ; 617   return status;
2169  02f4 7b01          	ld	a,(OFST+0,sp)
2172  02f6 5b03          	addw	sp,#3
2173  02f8 81            	ret
2208                     ; 646 void UART1_ClearFlag(UART1_Flag_TypeDef UART1_FLAG)
2208                     ; 647 {
2209                     	switch	.text
2210  02f9               _UART1_ClearFlag:
2214                     ; 648   assert_param(IS_UART1_CLEAR_FLAG_OK(UART1_FLAG));
2216                     ; 651   if (UART1_FLAG == UART1_FLAG_RXNE)
2218  02f9 a30020        	cpw	x,#32
2219  02fc 2606          	jrne	L1211
2220                     ; 653     UART1->SR = (uint8_t)~(UART1_SR_RXNE);
2222  02fe 35df5230      	mov	21040,#223
2224  0302 2004          	jra	L3211
2225  0304               L1211:
2226                     ; 658     UART1->CR4 &= (uint8_t)~(UART1_CR4_LBDF);
2228  0304 72195237      	bres	21047,#4
2229  0308               L3211:
2230                     ; 660 }
2233  0308 81            	ret
2315                     ; 675 ITStatus UART1_GetITStatus(UART1_IT_TypeDef UART1_IT)
2315                     ; 676 {
2316                     	switch	.text
2317  0309               _UART1_GetITStatus:
2319  0309 89            	pushw	x
2320  030a 89            	pushw	x
2321       00000002      OFST:	set	2
2324                     ; 677   ITStatus pendingbitstatus = RESET;
2326                     ; 678   uint8_t itpos = 0;
2328                     ; 679   uint8_t itmask1 = 0;
2330                     ; 680   uint8_t itmask2 = 0;
2332                     ; 681   uint8_t enablestatus = 0;
2334                     ; 684   assert_param(IS_UART1_GET_IT_OK(UART1_IT));
2336                     ; 687   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART1_IT & (uint8_t)0x0F));
2338  030b 9f            	ld	a,xl
2339  030c a40f          	and	a,#15
2340  030e 5f            	clrw	x
2341  030f 97            	ld	xl,a
2342  0310 a601          	ld	a,#1
2343  0312 5d            	tnzw	x
2344  0313 2704          	jreq	L27
2345  0315               L47:
2346  0315 48            	sll	a
2347  0316 5a            	decw	x
2348  0317 26fc          	jrne	L47
2349  0319               L27:
2350  0319 6b01          	ld	(OFST-1,sp),a
2352                     ; 689   itmask1 = (uint8_t)((uint8_t)UART1_IT >> (uint8_t)4);
2354  031b 7b04          	ld	a,(OFST+2,sp)
2355  031d 4e            	swap	a
2356  031e a40f          	and	a,#15
2357  0320 6b02          	ld	(OFST+0,sp),a
2359                     ; 691   itmask2 = (uint8_t)((uint8_t)1 << itmask1);
2361  0322 7b02          	ld	a,(OFST+0,sp)
2362  0324 5f            	clrw	x
2363  0325 97            	ld	xl,a
2364  0326 a601          	ld	a,#1
2365  0328 5d            	tnzw	x
2366  0329 2704          	jreq	L67
2367  032b               L001:
2368  032b 48            	sll	a
2369  032c 5a            	decw	x
2370  032d 26fc          	jrne	L001
2371  032f               L67:
2372  032f 6b02          	ld	(OFST+0,sp),a
2374                     ; 695   if (UART1_IT == UART1_IT_PE)
2376  0331 1e03          	ldw	x,(OFST+1,sp)
2377  0333 a30100        	cpw	x,#256
2378  0336 261c          	jrne	L7611
2379                     ; 698     enablestatus = (uint8_t)((uint8_t)UART1->CR1 & itmask2);
2381  0338 c65234        	ld	a,21044
2382  033b 1402          	and	a,(OFST+0,sp)
2383  033d 6b02          	ld	(OFST+0,sp),a
2385                     ; 701     if (((UART1->SR & itpos) != (uint8_t)0x00) && enablestatus)
2387  033f c65230        	ld	a,21040
2388  0342 1501          	bcp	a,(OFST-1,sp)
2389  0344 270a          	jreq	L1711
2391  0346 0d02          	tnz	(OFST+0,sp)
2392  0348 2706          	jreq	L1711
2393                     ; 704       pendingbitstatus = SET;
2395  034a a601          	ld	a,#1
2396  034c 6b02          	ld	(OFST+0,sp),a
2399  034e 2041          	jra	L5711
2400  0350               L1711:
2401                     ; 709       pendingbitstatus = RESET;
2403  0350 0f02          	clr	(OFST+0,sp)
2405  0352 203d          	jra	L5711
2406  0354               L7611:
2407                     ; 713   else if (UART1_IT == UART1_IT_LBDF)
2409  0354 1e03          	ldw	x,(OFST+1,sp)
2410  0356 a30346        	cpw	x,#838
2411  0359 261c          	jrne	L7711
2412                     ; 716     enablestatus = (uint8_t)((uint8_t)UART1->CR4 & itmask2);
2414  035b c65237        	ld	a,21047
2415  035e 1402          	and	a,(OFST+0,sp)
2416  0360 6b02          	ld	(OFST+0,sp),a
2418                     ; 718     if (((UART1->CR4 & itpos) != (uint8_t)0x00) && enablestatus)
2420  0362 c65237        	ld	a,21047
2421  0365 1501          	bcp	a,(OFST-1,sp)
2422  0367 270a          	jreq	L1021
2424  0369 0d02          	tnz	(OFST+0,sp)
2425  036b 2706          	jreq	L1021
2426                     ; 721       pendingbitstatus = SET;
2428  036d a601          	ld	a,#1
2429  036f 6b02          	ld	(OFST+0,sp),a
2432  0371 201e          	jra	L5711
2433  0373               L1021:
2434                     ; 726       pendingbitstatus = RESET;
2436  0373 0f02          	clr	(OFST+0,sp)
2438  0375 201a          	jra	L5711
2439  0377               L7711:
2440                     ; 732     enablestatus = (uint8_t)((uint8_t)UART1->CR2 & itmask2);
2442  0377 c65235        	ld	a,21045
2443  037a 1402          	and	a,(OFST+0,sp)
2444  037c 6b02          	ld	(OFST+0,sp),a
2446                     ; 734     if (((UART1->SR & itpos) != (uint8_t)0x00) && enablestatus)
2448  037e c65230        	ld	a,21040
2449  0381 1501          	bcp	a,(OFST-1,sp)
2450  0383 270a          	jreq	L7021
2452  0385 0d02          	tnz	(OFST+0,sp)
2453  0387 2706          	jreq	L7021
2454                     ; 737       pendingbitstatus = SET;
2456  0389 a601          	ld	a,#1
2457  038b 6b02          	ld	(OFST+0,sp),a
2460  038d 2002          	jra	L5711
2461  038f               L7021:
2462                     ; 742       pendingbitstatus = RESET;
2464  038f 0f02          	clr	(OFST+0,sp)
2466  0391               L5711:
2467                     ; 747   return  pendingbitstatus;
2469  0391 7b02          	ld	a,(OFST+0,sp)
2472  0393 5b04          	addw	sp,#4
2473  0395 81            	ret
2509                     ; 775 void UART1_ClearITPendingBit(UART1_IT_TypeDef UART1_IT)
2509                     ; 776 {
2510                     	switch	.text
2511  0396               _UART1_ClearITPendingBit:
2515                     ; 777   assert_param(IS_UART1_CLEAR_IT_OK(UART1_IT));
2517                     ; 780   if (UART1_IT == UART1_IT_RXNE)
2519  0396 a30255        	cpw	x,#597
2520  0399 2606          	jrne	L1321
2521                     ; 782     UART1->SR = (uint8_t)~(UART1_SR_RXNE);
2523  039b 35df5230      	mov	21040,#223
2525  039f 2004          	jra	L3321
2526  03a1               L1321:
2527                     ; 787     UART1->CR4 &= (uint8_t)~(UART1_CR4_LBDF);
2529  03a1 72195237      	bres	21047,#4
2530  03a5               L3321:
2531                     ; 789 }
2534  03a5 81            	ret
2547                     	xdef	_UART1_ClearITPendingBit
2548                     	xdef	_UART1_GetITStatus
2549                     	xdef	_UART1_ClearFlag
2550                     	xdef	_UART1_GetFlagStatus
2551                     	xdef	_UART1_SetPrescaler
2552                     	xdef	_UART1_SetGuardTime
2553                     	xdef	_UART1_SetAddress
2554                     	xdef	_UART1_SendBreak
2555                     	xdef	_UART1_SendData9
2556                     	xdef	_UART1_SendData8
2557                     	xdef	_UART1_ReceiveData9
2558                     	xdef	_UART1_ReceiveData8
2559                     	xdef	_UART1_ReceiverWakeUpCmd
2560                     	xdef	_UART1_WakeUpConfig
2561                     	xdef	_UART1_SmartCardNACKCmd
2562                     	xdef	_UART1_SmartCardCmd
2563                     	xdef	_UART1_LINCmd
2564                     	xdef	_UART1_LINBreakDetectionConfig
2565                     	xdef	_UART1_IrDACmd
2566                     	xdef	_UART1_IrDAConfig
2567                     	xdef	_UART1_HalfDuplexCmd
2568                     	xdef	_UART1_ITConfig
2569                     	xdef	_UART1_Cmd
2570                     	xdef	_UART1_Init
2571                     	xdef	_UART1_DeInit
2572                     	xref	_CLK_GetClockFreq
2573                     	xref.b	c_lreg
2574                     	xref.b	c_x
2593                     	xref	c_lsub
2594                     	xref	c_smul
2595                     	xref	c_ludv
2596                     	xref	c_rtol
2597                     	xref	c_llsh
2598                     	xref	c_ltor
2599                     	end
