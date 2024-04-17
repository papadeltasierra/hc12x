extern void main(void);
#pragma section (bob)
void dumpme(void)
{
	int a = 1;
	a++;
#pragma asm
/* 
A6 68                   # BRR1 = 0x68, BRR2 = 0x03, baud=9600
C7 52 42
A6 03
C7 52 43
A6 14                   # CR1, 8-bit, event parity
C7 52 44                #   M=1, PCEN=1, PS=0, PIEN=0
A6 00                   # CR3, 1 stop bit
C7 52 46
AE 80 00                # LDW X, 8000
                        # UART_CR2 = TEN       5240 + 05 => UART1/CR2
A6 08                   # LD A, 08      08 == TEN, transmit enable
C7 52 45                # LD 5245, A    08 into UART1_CR2
                        # tickle watchdog
90 5F                   # CLRW Y
90 BF F4                # LDW, $F4, Y
                        # while(!(UART_SR & TXE)) ; SR = 5240 TXE = 80
72 0F 5240 FB           # BTJF, FB (negative?), register/address 5240,
                        # UART_DR = X
F6                      # LD A, X
C7 5241                 # LD 5341, A
5C                      # INC X
26EF                    # JNZ, loop
81                      # RET
*/
			LD A,0x50C6
			AND A,#0xE7
			LD 0x50C6, A
			LD A,#0x68
			LD 0x5242,A				; BRR1, 9600 baud
			LD A,#0x03
			LD 0x5243,A				; BRR2, 9600 baud
			LD A,#0x00
			LD 0x5244,A				; CR1, 0x00, 8,N
			LD A,#0x00
			LD 0x5246,A				; CR3, 0x00, 1 stop
			LDW X,#0x8000
			LD A,#0x08
			LD 0x5245,A				; CR2, 0x08, Transmit
REPEAT:			
			CLRW Y
			LDW 0xF4,Y
WAIT:
			BTJF 0x5240,#0x07,WAIT				; Bit 7, status, TMIT ready
			LD A,(X)												
			LD 0x5241,A				; Transmit value in A (read via X)
			INCW X
			JRNE REPEAT				; Not wrapped/zero.
			RET

#pragma endasm
	main();
}
#pragma section()