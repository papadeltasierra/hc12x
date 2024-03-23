   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.1 - 31 Jan 2024
   3                     ; Generator (Limited) V4.6.1 - 31 Jan 2024
  44                     ; 41 void error(void)
  44                     ; 42 {
  46                     	switch	.text
  47  0000               _error:
  51                     ; 43     printf("ERROR\n");
  53  0000 ae006d        	ldw	x,#L12
  54  0003 cd0000        	call	_printf
  56                     ; 44 }
  59  0006 81            	ret
  83                     ; 46 void ok(void)
  83                     ; 47 {
  84                     	switch	.text
  85  0007               _ok:
  89                     ; 48     printf("ERROR\n");
  91  0007 ae006d        	ldw	x,#L12
  92  000a cd0000        	call	_printf
  94                     ; 49 }
  97  000d 81            	ret
 141                     ; 51 int crlf(void)
 141                     ; 52 {
 142                     	switch	.text
 143  000e               _crlf:
 145  000e 5203          	subw	sp,#3
 146       00000003      OFST:	set	3
 149                     ; 53     int rc = 0;
 151  0010 5f            	clrw	x
 152  0011 1f01          	ldw	(OFST-2,sp),x
 154  0013               L55:
 155                     ; 58         c = getchar();
 157  0013 cd0000        	call	_getchar
 159  0016 6b03          	ld	(OFST+0,sp),a
 161                     ; 59         if (c == '\n')
 163  0018 7b03          	ld	a,(OFST+0,sp)
 164  001a a10a          	cp	a,#10
 165  001c 2605          	jrne	L16
 166                     ; 61             break;
 167                     ; 68     return rc;
 169  001e 1e01          	ldw	x,(OFST-2,sp)
 172  0020 5b03          	addw	sp,#3
 173  0022 81            	ret
 174  0023               L16:
 175                     ; 63         else if (c != '\r')
 177  0023 7b03          	ld	a,(OFST+0,sp)
 178  0025 a10d          	cp	a,#13
 179  0027 27ea          	jreq	L55
 180                     ; 65             rc = 1;
 182  0029 ae0001        	ldw	x,#1
 183  002c 1f01          	ldw	(OFST-2,sp),x
 185  002e 20e3          	jra	L55
 271                     ; 80 void update(void)
 271                     ; 81 {
 272                     	switch	.text
 273  0030               _update:
 275  0030 522e          	subw	sp,#46
 276       0000002e      OFST:	set	46
 279                     ; 83     char crc = 0;
 281  0032 0f2a          	clr	(OFST-4,sp)
 283                     ; 84     char *dptr = &data[0];
 285  0034 96            	ldw	x,sp
 286  0035 1c0005        	addw	x,#OFST-41
 287  0038 1f2b          	ldw	(OFST-3,sp),x
 289                     ; 89     printf("Update...\n");
 291  003a ae0062        	ldw	x,#L131
 292  003d cd0000        	call	_printf
 294                     ; 90     crlf();
 296  0040 adcc          	call	_crlf
 298                     ; 93     data[0] = getchar();
 300  0042 cd0000        	call	_getchar
 302  0045 6b05          	ld	(OFST-41,sp),a
 304                     ; 94     if (data[0] > 0x25)
 306  0047 7b05          	ld	a,(OFST-41,sp)
 307  0049 a126          	cp	a,#38
 308  004b 250c          	jrult	L331
 309                     ; 97         error();
 311  004d adb1          	call	_error
 313                     ; 98         printf("Too long\n");
 315  004f ae0058        	ldw	x,#L531
 316  0052 cd0000        	call	_printf
 318                     ; 99         crlf();
 320  0055 adb7          	call	_crlf
 322                     ; 100         return;
 324  0057 205d          	jra	L41
 325  0059               L331:
 326                     ; 105     len = (int)data[0];
 328  0059 7b05          	ld	a,(OFST-41,sp)
 329  005b 5f            	clrw	x
 330  005c 97            	ld	xl,a
 331  005d 1f03          	ldw	(OFST-43,sp),x
 333                     ; 106     len2 = len;
 335  005f 1e03          	ldw	x,(OFST-43,sp)
 336  0061 1f2d          	ldw	(OFST-1,sp),x
 339  0063 200e          	jra	L341
 340  0065               L731:
 341                     ; 111         *dptr++ = getchar();
 343  0065 cd0000        	call	_getchar
 345  0068 1e2b          	ldw	x,(OFST-3,sp)
 346  006a 1c0001        	addw	x,#1
 347  006d 1f2b          	ldw	(OFST-3,sp),x
 348  006f 1d0001        	subw	x,#1
 350  0072 f7            	ld	(x),a
 351  0073               L341:
 352                     ; 109     while (--len2)
 354  0073 1e2d          	ldw	x,(OFST-1,sp)
 355  0075 1d0001        	subw	x,#1
 356  0078 1f2d          	ldw	(OFST-1,sp),x
 358  007a 26e9          	jrne	L731
 359                     ; 116     len2 = len;
 361  007c 1e03          	ldw	x,(OFST-43,sp)
 362  007e 1f2d          	ldw	(OFST-1,sp),x
 364                     ; 117     dptr = &data[0];
 366  0080 96            	ldw	x,sp
 367  0081 1c0005        	addw	x,#OFST-41
 368  0084 1f2b          	ldw	(OFST-3,sp),x
 371  0086 200f          	jra	L351
 372  0088               L741:
 373                     ; 121         crc += *dptr++;
 375  0088 1e2b          	ldw	x,(OFST-3,sp)
 376  008a 1c0001        	addw	x,#1
 377  008d 1f2b          	ldw	(OFST-3,sp),x
 378  008f 1d0001        	subw	x,#1
 380  0092 7b2a          	ld	a,(OFST-4,sp)
 381  0094 fb            	add	a,(x)
 382  0095 6b2a          	ld	(OFST-4,sp),a
 384  0097               L351:
 385                     ; 119     while(len2--)
 387  0097 1e2d          	ldw	x,(OFST-1,sp)
 388  0099 1d0001        	subw	x,#1
 389  009c 1f2d          	ldw	(OFST-1,sp),x
 390  009e 1c0001        	addw	x,#1
 392  00a1 a30000        	cpw	x,#0
 393  00a4 26e2          	jrne	L741
 394                     ; 123     if (crc != 0)
 396  00a6 0d2a          	tnz	(OFST-4,sp)
 397  00a8 270f          	jreq	L751
 398                     ; 126         error();
 400  00aa cd0000        	call	_error
 402                     ; 127         printf("CRC mismatch\n");
 404  00ad ae004a        	ldw	x,#L161
 405  00b0 cd0000        	call	_printf
 407                     ; 128         crlf();
 409  00b3 cd000e        	call	_crlf
 411                     ; 129         return;
 412  00b6               L41:
 415  00b6 5b2e          	addw	sp,#46
 416  00b8 81            	ret
 417  00b9               L751:
 418                     ; 131     addr = (((unsigned short)dptr[2]) << 8) + (unsigned short)dptr[3];
 420  00b9 1e2b          	ldw	x,(OFST-3,sp)
 421  00bb e603          	ld	a,(3,x)
 422  00bd 5f            	clrw	x
 423  00be 97            	ld	xl,a
 424  00bf 1f01          	ldw	(OFST-45,sp),x
 426  00c1 1e2b          	ldw	x,(OFST-3,sp)
 427  00c3 e602          	ld	a,(2,x)
 428  00c5 5f            	clrw	x
 429  00c6 97            	ld	xl,a
 430  00c7 4f            	clr	a
 431  00c8 02            	rlwa	x,a
 432  00c9 72fb01        	addw	x,(OFST-45,sp)
 433  00cc 1f2d          	ldw	(OFST-1,sp),x
 435                     ; 132     if ((addr < 0x8000) || (addr > 0x9A00) || (addr && 0x000F))
 437  00ce 1e2d          	ldw	x,(OFST-1,sp)
 438  00d0 a38000        	cpw	x,#32768
 439  00d3 250b          	jrult	L561
 441  00d5 1e2d          	ldw	x,(OFST-1,sp)
 442  00d7 a39a01        	cpw	x,#39425
 443  00da 2404          	jruge	L561
 445  00dc 1e2d          	ldw	x,(OFST-1,sp)
 446  00de 270e          	jreq	L361
 447  00e0               L561:
 448                     ; 134         error();
 450  00e0 cd0000        	call	_error
 452                     ; 135         printf("Bad address/not 32-byte boundary");
 454  00e3 ae0029        	ldw	x,#L171
 455  00e6 cd0000        	call	_printf
 457                     ; 136         crlf();
 459  00e9 cd000e        	call	_crlf
 461                     ; 137         return;
 463  00ec 20c8          	jra	L41
 464  00ee               L361:
 465                     ; 139     len -= 3;
 467  00ee 1e03          	ldw	x,(OFST-43,sp)
 468  00f0 1d0003        	subw	x,#3
 469  00f3 1f03          	ldw	(OFST-43,sp),x
 471                     ; 141     ok();
 473  00f5 cd0007        	call	_ok
 475                     ; 142     crlf();
 477  00f8 cd000e        	call	_crlf
 479                     ; 143 }
 481  00fb 20b9          	jra	L41
 506                     ; 145 void showVersion(void)
 506                     ; 146 {
 507                     	switch	.text
 508  00fd               _showVersion:
 512                     ; 147     printf("HC-12-X v0.1\n");
 514  00fd ae001b        	ldw	x,#L302
 515  0100 cd0000        	call	_printf
 517                     ; 148     crlf();
 519  0103 cd000e        	call	_crlf
 521                     ; 149 }
 524  0106 81            	ret
 527                     	bsct
 528  0000               _commands:
 529  0000 0016          	dc.w	L502
 531  0002 00fd          	dc.w	_showVersion
 532  0004 000c          	dc.w	L702
 534  0006 0030          	dc.w	_update
 535  0008 0000          	dc.w	0
 536  000a 0000          	dc.w	0
 537                     .const:	section	.text
 538  0000               L112_command:
 539  0000 00            	dc.b	0
 540  0001 000000000000  	ds.b	11
 628                     ; 159 void parser(void)
 628                     ; 160 {
 629                     	switch	.text
 630  0107               _parser:
 632  0107 5212          	subw	sp,#18
 633       00000012      OFST:	set	18
 636                     ; 161     int charCount = 0;
 638  0109 5f            	clrw	x
 639  010a 1f0f          	ldw	(OFST-3,sp),x
 641                     ; 162     char command[12] = {0};
 643  010c 96            	ldw	x,sp
 644  010d 1c0003        	addw	x,#OFST-15
 645  0110 90ae0000      	ldw	y,#L112_command
 646  0114 a60c          	ld	a,#12
 647  0116 cd0000        	call	c_xymov
 649                     ; 163     COMMAND *cmd = &commands[0];
 651  0119               L752:
 652                     ; 167         command[charCount] = getchar();
 654  0119 cd0000        	call	_getchar
 656  011c 96            	ldw	x,sp
 657  011d 1c0003        	addw	x,#OFST-15
 658  0120 1f01          	ldw	(OFST-17,sp),x
 660  0122 1e0f          	ldw	x,(OFST-3,sp)
 661  0124 72fb01        	addw	x,(OFST-17,sp)
 662  0127 f7            	ld	(x),a
 663                     ; 168         charCount++;
 665  0128 1e0f          	ldw	x,(OFST-3,sp)
 666  012a 1c0001        	addw	x,#1
 667  012d 1f0f          	ldw	(OFST-3,sp),x
 669                     ; 170         cmd = &commands[0];
 671  012f ae0000        	ldw	x,#_commands
 672  0132 1f11          	ldw	(OFST-1,sp),x
 675  0134 2056          	jra	L762
 676  0136               L362:
 677                     ; 174             if (strcmp(command, cmd->string) == 0)
 679  0136 1e11          	ldw	x,(OFST-1,sp)
 680  0138 fe            	ldw	x,(x)
 681  0139 89            	pushw	x
 682  013a 96            	ldw	x,sp
 683  013b 1c0005        	addw	x,#OFST-13
 684  013e cd0000        	call	_strcmp
 686  0141 5b02          	addw	sp,#2
 687  0143 a30000        	cpw	x,#0
 688  0146 261a          	jrne	L372
 689                     ; 176                 cmd->cmd();
 691  0148 1e11          	ldw	x,(OFST-1,sp)
 692  014a ee02          	ldw	x,(2,x)
 693  014c fd            	call	(x)
 695                     ; 177                 memset(command, 0, 12);
 697  014d 96            	ldw	x,sp
 698  014e 1c0003        	addw	x,#OFST-15
 699  0151 bf00          	ldw	c_x,x
 700  0153 ae000c        	ldw	x,#12
 701  0156               L22:
 702  0156 5a            	decw	x
 703  0157 926f00        	clr	([c_x.w],x)
 704  015a 5d            	tnzw	x
 705  015b 26f9          	jrne	L22
 706                     ; 178                 charCount = 0;
 708  015d 5f            	clrw	x
 709  015e 1f0f          	ldw	(OFST-3,sp),x
 711                     ; 179                 break;
 713  0160 20b7          	jra	L752
 714  0162               L372:
 715                     ; 181             else if (charCount >= 12)
 717  0162 9c            	rvf
 718  0163 1e0f          	ldw	x,(OFST-3,sp)
 719  0165 a3000c        	cpw	x,#12
 720  0168 2f1b          	jrslt	L572
 721                     ; 183                 memset(command, 0, 12);
 723  016a 96            	ldw	x,sp
 724  016b 1c0003        	addw	x,#OFST-15
 725  016e bf00          	ldw	c_x,x
 726  0170 ae000c        	ldw	x,#12
 727  0173               L42:
 728  0173 5a            	decw	x
 729  0174 926f00        	clr	([c_x.w],x)
 730  0177 5d            	tnzw	x
 731  0178 26f9          	jrne	L42
 732                     ; 184                 charCount = 0;
 734  017a 5f            	clrw	x
 735  017b 1f0f          	ldw	(OFST-3,sp),x
 737                     ; 185                 error();
 739  017d cd0000        	call	_error
 741                     ; 186                 crlf();
 743  0180 cd000e        	call	_crlf
 745                     ; 187                 break;
 747  0183 2094          	jra	L752
 748  0185               L572:
 749                     ; 189             cmd++;
 751  0185 1e11          	ldw	x,(OFST-1,sp)
 752  0187 1c0004        	addw	x,#4
 753  018a 1f11          	ldw	(OFST-1,sp),x
 755  018c               L762:
 756                     ; 171         while (cmd->string != NULL)
 756                     ; 172         {
 756                     ; 173             // printf("%s\n", cmd->string);
 756                     ; 174             if (strcmp(command, cmd->string) == 0)
 756                     ; 175             {
 756                     ; 176                 cmd->cmd();
 756                     ; 177                 memset(command, 0, 12);
 756                     ; 178                 charCount = 0;
 756                     ; 179                 break;
 756                     ; 180             }
 756                     ; 181             else if (charCount >= 12)
 756                     ; 182             {
 756                     ; 183                 memset(command, 0, 12);
 756                     ; 184                 charCount = 0;
 756                     ; 185                 error();
 756                     ; 186                 crlf();
 756                     ; 187                 break;
 756                     ; 188             }
 756                     ; 189             cmd++;
 758  018c 1e11          	ldw	x,(OFST-1,sp)
 759  018e e601          	ld	a,(1,x)
 760  0190 fa            	or	a,(x)
 761  0191 26a3          	jrne	L362
 762  0193 2084          	jra	L752
 797                     ; 194 int main(int argc, char *argv[])
 797                     ; 195 {
 798                     	switch	.text
 799  0195               _main:
 803                     ; 196     parser();
 805  0195 cd0107        	call	_parser
 807                     ; 197     return 0;
 809  0198 5f            	clrw	x
 812  0199 81            	ret
 839                     	xdef	_main
 840                     	xdef	_parser
 841                     	xdef	_commands
 842                     	xdef	_showVersion
 843                     	xdef	_update
 844                     	xdef	_crlf
 845                     	xdef	_ok
 846                     	xdef	_error
 847                     	xref	_printf
 848                     	xref	_getchar
 849                     	xref	_strcmp
 850                     	switch	.const
 851  000c               L702:
 852  000c 41542b555044  	dc.b	"AT+UPDATE",0
 853  0016               L502:
 854  0016 41542b5600    	dc.b	"AT+V",0
 855  001b               L302:
 856  001b 48432d31322d  	dc.b	"HC-12-X v0.1",10,0
 857  0029               L171:
 858  0029 426164206164  	dc.b	"Bad address/not 32"
 859  003b 2d6279746520  	dc.b	"-byte boundary",0
 860  004a               L161:
 861  004a 435243206d69  	dc.b	"CRC mismatch",10,0
 862  0058               L531:
 863  0058 546f6f206c6f  	dc.b	"Too long",10,0
 864  0062               L131:
 865  0062 557064617465  	dc.b	"Update...",10,0
 866  006d               L12:
 867  006d 4552524f520a  	dc.b	"ERROR",10,0
 868                     	xref.b	c_x
 888                     	xref	c_xymov
 889                     	end
