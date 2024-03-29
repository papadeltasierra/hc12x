   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.1 - 31 Jan 2024
   3                     ; Generator (Limited) V4.6.1 - 31 Jan 2024
  45                     ; 41 void error(void)
  45                     ; 42 {
  47                     .text:	section	.text,new
  48  0000               _error:
  52                     ; 43     printf("ERROR\n");
  54  0000 ae006d        	ldw	x,#L12
  55  0003 cd0000        	call	_printf
  57                     ; 44 }
  60  0006 81            	ret
  84                     ; 46 void ok(void)
  84                     ; 47 {
  85                     .text:	section	.text,new
  86  0000               _ok:
  90                     ; 48     printf("ERROR\n");
  92  0000 ae006d        	ldw	x,#L12
  93  0003 cd0000        	call	_printf
  95                     ; 49 }
  98  0006 81            	ret
 142                     ; 51 int crlf(void)
 142                     ; 52 {
 143                     .text:	section	.text,new
 144  0000               _crlf:
 146  0000 5203          	subw	sp,#3
 147       00000003      OFST:	set	3
 150                     ; 53     int rc = 0;
 152  0002 5f            	clrw	x
 153  0003 1f01          	ldw	(OFST-2,sp),x
 155  0005               L55:
 156                     ; 58         c = getchar();
 158  0005 cd0000        	call	_getchar
 160  0008 6b03          	ld	(OFST+0,sp),a
 162                     ; 59         if (c == '\n')
 164  000a 7b03          	ld	a,(OFST+0,sp)
 165  000c a10a          	cp	a,#10
 166  000e 2605          	jrne	L16
 167                     ; 61             break;
 168                     ; 68     return rc;
 170  0010 1e01          	ldw	x,(OFST-2,sp)
 173  0012 5b03          	addw	sp,#3
 174  0014 81            	ret
 175  0015               L16:
 176                     ; 63         else if (c != '\r')
 178  0015 7b03          	ld	a,(OFST+0,sp)
 179  0017 a10d          	cp	a,#13
 180  0019 27ea          	jreq	L55
 181                     ; 65             rc = 1;
 183  001b ae0001        	ldw	x,#1
 184  001e 1f01          	ldw	(OFST-2,sp),x
 186  0020 20e3          	jra	L55
 272                     ; 80 void update(void)
 272                     ; 81 {
 273                     .text:	section	.text,new
 274  0000               _update:
 276  0000 522e          	subw	sp,#46
 277       0000002e      OFST:	set	46
 280                     ; 83     char crc = 0;
 282  0002 0f2a          	clr	(OFST-4,sp)
 284                     ; 84     char *dptr = &data[0];
 286  0004 96            	ldw	x,sp
 287  0005 1c0005        	addw	x,#OFST-41
 288  0008 1f2b          	ldw	(OFST-3,sp),x
 290                     ; 89     printf("Update...\n");
 292  000a ae0062        	ldw	x,#L131
 293  000d cd0000        	call	_printf
 295                     ; 90     crlf();
 297  0010 cd0000        	call	_crlf
 299                     ; 93     data[0] = getchar();
 301  0013 cd0000        	call	_getchar
 303  0016 6b05          	ld	(OFST-41,sp),a
 305                     ; 94     if (data[0] > 0x25)
 307  0018 7b05          	ld	a,(OFST-41,sp)
 308  001a a126          	cp	a,#38
 309  001c 250e          	jrult	L331
 310                     ; 97         error();
 312  001e cd0000        	call	_error
 314                     ; 98         printf("Too long\n");
 316  0021 ae0058        	ldw	x,#L531
 317  0024 cd0000        	call	_printf
 319                     ; 99         crlf();
 321  0027 cd0000        	call	_crlf
 323                     ; 100         return;
 325  002a 205d          	jra	L41
 326  002c               L331:
 327                     ; 105     len = (int)data[0];
 329  002c 7b05          	ld	a,(OFST-41,sp)
 330  002e 5f            	clrw	x
 331  002f 97            	ld	xl,a
 332  0030 1f03          	ldw	(OFST-43,sp),x
 334                     ; 106     len2 = len;
 336  0032 1e03          	ldw	x,(OFST-43,sp)
 337  0034 1f2d          	ldw	(OFST-1,sp),x
 340  0036 200e          	jra	L341
 341  0038               L731:
 342                     ; 111         *dptr++ = getchar();
 344  0038 cd0000        	call	_getchar
 346  003b 1e2b          	ldw	x,(OFST-3,sp)
 347  003d 1c0001        	addw	x,#1
 348  0040 1f2b          	ldw	(OFST-3,sp),x
 349  0042 1d0001        	subw	x,#1
 351  0045 f7            	ld	(x),a
 352  0046               L341:
 353                     ; 109     while (--len2)
 355  0046 1e2d          	ldw	x,(OFST-1,sp)
 356  0048 1d0001        	subw	x,#1
 357  004b 1f2d          	ldw	(OFST-1,sp),x
 359  004d 26e9          	jrne	L731
 360                     ; 116     len2 = len;
 362  004f 1e03          	ldw	x,(OFST-43,sp)
 363  0051 1f2d          	ldw	(OFST-1,sp),x
 365                     ; 117     dptr = &data[0];
 367  0053 96            	ldw	x,sp
 368  0054 1c0005        	addw	x,#OFST-41
 369  0057 1f2b          	ldw	(OFST-3,sp),x
 372  0059 200f          	jra	L351
 373  005b               L741:
 374                     ; 121         crc += *dptr++;
 376  005b 1e2b          	ldw	x,(OFST-3,sp)
 377  005d 1c0001        	addw	x,#1
 378  0060 1f2b          	ldw	(OFST-3,sp),x
 379  0062 1d0001        	subw	x,#1
 381  0065 7b2a          	ld	a,(OFST-4,sp)
 382  0067 fb            	add	a,(x)
 383  0068 6b2a          	ld	(OFST-4,sp),a
 385  006a               L351:
 386                     ; 119     while(len2--)
 388  006a 1e2d          	ldw	x,(OFST-1,sp)
 389  006c 1d0001        	subw	x,#1
 390  006f 1f2d          	ldw	(OFST-1,sp),x
 391  0071 1c0001        	addw	x,#1
 393  0074 a30000        	cpw	x,#0
 394  0077 26e2          	jrne	L741
 395                     ; 123     if (crc != 0)
 397  0079 0d2a          	tnz	(OFST-4,sp)
 398  007b 270f          	jreq	L751
 399                     ; 126         error();
 401  007d cd0000        	call	_error
 403                     ; 127         printf("CRC mismatch\n");
 405  0080 ae004a        	ldw	x,#L161
 406  0083 cd0000        	call	_printf
 408                     ; 128         crlf();
 410  0086 cd0000        	call	_crlf
 412                     ; 129         return;
 413  0089               L41:
 416  0089 5b2e          	addw	sp,#46
 417  008b 81            	ret
 418  008c               L751:
 419                     ; 131     addr = (((unsigned short)dptr[2]) << 8) + (unsigned short)dptr[3];
 421  008c 1e2b          	ldw	x,(OFST-3,sp)
 422  008e e603          	ld	a,(3,x)
 423  0090 5f            	clrw	x
 424  0091 97            	ld	xl,a
 425  0092 1f01          	ldw	(OFST-45,sp),x
 427  0094 1e2b          	ldw	x,(OFST-3,sp)
 428  0096 e602          	ld	a,(2,x)
 429  0098 5f            	clrw	x
 430  0099 97            	ld	xl,a
 431  009a 4f            	clr	a
 432  009b 02            	rlwa	x,a
 433  009c 72fb01        	addw	x,(OFST-45,sp)
 434  009f 1f2d          	ldw	(OFST-1,sp),x
 436                     ; 132     if ((addr < 0x8000) || (addr > 0x9A00) || (addr && 0x000F))
 438  00a1 1e2d          	ldw	x,(OFST-1,sp)
 439  00a3 a38000        	cpw	x,#32768
 440  00a6 250b          	jrult	L561
 442  00a8 1e2d          	ldw	x,(OFST-1,sp)
 443  00aa a39a01        	cpw	x,#39425
 444  00ad 2404          	jruge	L561
 446  00af 1e2d          	ldw	x,(OFST-1,sp)
 447  00b1 270e          	jreq	L361
 448  00b3               L561:
 449                     ; 134         error();
 451  00b3 cd0000        	call	_error
 453                     ; 135         printf("Bad address/not 32-byte boundary");
 455  00b6 ae0029        	ldw	x,#L171
 456  00b9 cd0000        	call	_printf
 458                     ; 136         crlf();
 460  00bc cd0000        	call	_crlf
 462                     ; 137         return;
 464  00bf 20c8          	jra	L41
 465  00c1               L361:
 466                     ; 139     len -= 3;
 468  00c1 1e03          	ldw	x,(OFST-43,sp)
 469  00c3 1d0003        	subw	x,#3
 470  00c6 1f03          	ldw	(OFST-43,sp),x
 472                     ; 141     ok();
 474  00c8 cd0000        	call	_ok
 476                     ; 142     crlf();
 478  00cb cd0000        	call	_crlf
 480                     ; 143 }
 482  00ce 20b9          	jra	L41
 507                     ; 145 void showVersion(void)
 507                     ; 146 {
 508                     .text:	section	.text,new
 509  0000               _showVersion:
 513                     ; 147     printf("HC-12-X v0.1\n");
 515  0000 ae001b        	ldw	x,#L302
 516  0003 cd0000        	call	_printf
 518                     ; 148     crlf();
 520  0006 cd0000        	call	_crlf
 522                     ; 149 }
 525  0009 81            	ret
 528                     	bsct
 529  0000               _commands:
 530  0000 0016          	dc.w	L502
 532  0002 0000          	dc.w	_showVersion
 533  0004 000c          	dc.w	L702
 535  0006 0000          	dc.w	_update
 536  0008 0000          	dc.w	0
 537  000a 0000          	dc.w	0
 538                     .const:	section	.text
 539  0000               L112_command:
 540  0000 00            	dc.b	0
 541  0001 000000000000  	ds.b	11
 629                     ; 159 void parser(void)
 629                     ; 160 {
 630                     .text:	section	.text,new
 631  0000               _parser:
 633  0000 5212          	subw	sp,#18
 634       00000012      OFST:	set	18
 637                     ; 161     int charCount = 0;
 639  0002 5f            	clrw	x
 640  0003 1f0f          	ldw	(OFST-3,sp),x
 642                     ; 162     char command[12] = {0};
 644  0005 96            	ldw	x,sp
 645  0006 1c0003        	addw	x,#OFST-15
 646  0009 90ae0000      	ldw	y,#L112_command
 647  000d a60c          	ld	a,#12
 648  000f cd0000        	call	c_xymov
 650                     ; 163     COMMAND *cmd = &commands[0];
 652  0012               L752:
 653                     ; 167         command[charCount] = getchar();
 655  0012 cd0000        	call	_getchar
 657  0015 96            	ldw	x,sp
 658  0016 1c0003        	addw	x,#OFST-15
 659  0019 1f01          	ldw	(OFST-17,sp),x
 661  001b 1e0f          	ldw	x,(OFST-3,sp)
 662  001d 72fb01        	addw	x,(OFST-17,sp)
 663  0020 f7            	ld	(x),a
 664                     ; 168         charCount++;
 666  0021 1e0f          	ldw	x,(OFST-3,sp)
 667  0023 1c0001        	addw	x,#1
 668  0026 1f0f          	ldw	(OFST-3,sp),x
 670                     ; 170         cmd = &commands[0];
 672  0028 ae0000        	ldw	x,#_commands
 673  002b 1f11          	ldw	(OFST-1,sp),x
 676  002d 2056          	jra	L762
 677  002f               L362:
 678                     ; 174             if (strcmp(command, cmd->string) == 0)
 680  002f 1e11          	ldw	x,(OFST-1,sp)
 681  0031 fe            	ldw	x,(x)
 682  0032 89            	pushw	x
 683  0033 96            	ldw	x,sp
 684  0034 1c0005        	addw	x,#OFST-13
 685  0037 cd0000        	call	_strcmp
 687  003a 5b02          	addw	sp,#2
 688  003c a30000        	cpw	x,#0
 689  003f 261a          	jrne	L372
 690                     ; 176                 cmd->cmd();
 692  0041 1e11          	ldw	x,(OFST-1,sp)
 693  0043 ee02          	ldw	x,(2,x)
 694  0045 fd            	call	(x)
 696                     ; 177                 memset(command, 0, 12);
 698  0046 96            	ldw	x,sp
 699  0047 1c0003        	addw	x,#OFST-15
 700  004a bf00          	ldw	c_x,x
 701  004c ae000c        	ldw	x,#12
 702  004f               L22:
 703  004f 5a            	decw	x
 704  0050 926f00        	clr	([c_x.w],x)
 705  0053 5d            	tnzw	x
 706  0054 26f9          	jrne	L22
 707                     ; 178                 charCount = 0;
 709  0056 5f            	clrw	x
 710  0057 1f0f          	ldw	(OFST-3,sp),x
 712                     ; 179                 break;
 714  0059 20b7          	jra	L752
 715  005b               L372:
 716                     ; 181             else if (charCount >= 12)
 718  005b 9c            	rvf
 719  005c 1e0f          	ldw	x,(OFST-3,sp)
 720  005e a3000c        	cpw	x,#12
 721  0061 2f1b          	jrslt	L572
 722                     ; 183                 memset(command, 0, 12);
 724  0063 96            	ldw	x,sp
 725  0064 1c0003        	addw	x,#OFST-15
 726  0067 bf00          	ldw	c_x,x
 727  0069 ae000c        	ldw	x,#12
 728  006c               L42:
 729  006c 5a            	decw	x
 730  006d 926f00        	clr	([c_x.w],x)
 731  0070 5d            	tnzw	x
 732  0071 26f9          	jrne	L42
 733                     ; 184                 charCount = 0;
 735  0073 5f            	clrw	x
 736  0074 1f0f          	ldw	(OFST-3,sp),x
 738                     ; 185                 error();
 740  0076 cd0000        	call	_error
 742                     ; 186                 crlf();
 744  0079 cd0000        	call	_crlf
 746                     ; 187                 break;
 748  007c 2094          	jra	L752
 749  007e               L572:
 750                     ; 189             cmd++;
 752  007e 1e11          	ldw	x,(OFST-1,sp)
 753  0080 1c0004        	addw	x,#4
 754  0083 1f11          	ldw	(OFST-1,sp),x
 756  0085               L762:
 757                     ; 171         while (cmd->string != NULL)
 757                     ; 172         {
 757                     ; 173             // printf("%s\n", cmd->string);
 757                     ; 174             if (strcmp(command, cmd->string) == 0)
 757                     ; 175             {
 757                     ; 176                 cmd->cmd();
 757                     ; 177                 memset(command, 0, 12);
 757                     ; 178                 charCount = 0;
 757                     ; 179                 break;
 757                     ; 180             }
 757                     ; 181             else if (charCount >= 12)
 757                     ; 182             {
 757                     ; 183                 memset(command, 0, 12);
 757                     ; 184                 charCount = 0;
 757                     ; 185                 error();
 757                     ; 186                 crlf();
 757                     ; 187                 break;
 757                     ; 188             }
 757                     ; 189             cmd++;
 759  0085 1e11          	ldw	x,(OFST-1,sp)
 760  0087 e601          	ld	a,(1,x)
 761  0089 fa            	or	a,(x)
 762  008a 26a3          	jrne	L362
 763  008c 2084          	jra	L752
 798                     ; 194 int main(int argc, char *argv[])
 798                     ; 195 {
 799                     .text:	section	.text,new
 800  0000               _main:
 804                     ; 196     parser();
 806  0000 cd0000        	call	_parser
 808                     ; 197     return 0;
 810  0003 5f            	clrw	x
 813  0004 81            	ret
 840                     	xdef	_main
 841                     	xdef	_parser
 842                     	xdef	_commands
 843                     	xdef	_showVersion
 844                     	xdef	_update
 845                     	xdef	_crlf
 846                     	xdef	_ok
 847                     	xdef	_error
 848                     	xref	_printf
 849                     	xref	_getchar
 850                     	xref	_strcmp
 851                     	switch	.const
 852  000c               L702:
 853  000c 41542b555044  	dc.b	"AT+UPDATE",0
 854  0016               L502:
 855  0016 41542b5600    	dc.b	"AT+V",0
 856  001b               L302:
 857  001b 48432d31322d  	dc.b	"HC-12-X v0.1",10,0
 858  0029               L171:
 859  0029 426164206164  	dc.b	"Bad address/not 32"
 860  003b 2d6279746520  	dc.b	"-byte boundary",0
 861  004a               L161:
 862  004a 435243206d69  	dc.b	"CRC mismatch",10,0
 863  0058               L531:
 864  0058 546f6f206c6f  	dc.b	"Too long",10,0
 865  0062               L131:
 866  0062 557064617465  	dc.b	"Update...",10,0
 867  006d               L12:
 868  006d 4552524f520a  	dc.b	"ERROR",10,0
 869                     	xref.b	c_x
 889                     	xref	c_xymov
 890                     	end
