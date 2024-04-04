/*	BASIC INTERRUPT VECTOR TABLE FOR STM8 devices
 *	Copyright (c) 2007 STMicroelectronics
 */
#include "main.h"

typedef void @far (*interrupt_handler_t)(void);

struct interrupt_vector {
	unsigned char interrupt_instruction;
	interrupt_handler_t interrupt_handler;
};

@far @interrupt void NonHandledInterrupt (void)
{
	/* in order to detect unexpected events during development,
	   it is recommended to set a breakpoint on the following instruction
	*/
	return;
}

extern void _stext();     /* startup routine */

struct interrupt_vector const _vectab[] = {
	{0x82, (interrupt_handler_t)_stext}, /* reset */
	{0x82, NonHandledInterrupt}, /* trap  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+8)}, /* irq0  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+12)}, /* irq1  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+16)}, /* irq2, CLK  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+20)}, /* irq3, EXTI0  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+24)}, /* irq4, EXTI1  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+28)}, /* irq5, EXTI2  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+32)}, /* irq6, EXTI3  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+36)}, /* irq7, EXTI4  */
	{0x82, NonHandledInterrupt}, /* irq8, reserved  */
	{0x82, NonHandledInterrupt}, /* irq9, reserved  */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+48)}, /* irq10, SPI, end of transfer */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+52)}, /* irq11, TIM1 */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+56)}, /* irq12, TIM1 */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+60)}, /* irq13, TIM2 */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+64)}, /* irq14, TIM2 */
	{0x82, NonHandledInterrupt}, /* irq15, reserved */
	{0x82, NonHandledInterrupt}, /* irq16, reserved */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+76)}, /* irq17, UART1, Tx complete */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+80)}, /* irq18, UART1, Receive register DATA FULL */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+84)}, /* irq19, I2C */
	{0x82, NonHandledInterrupt}, /* irq20, reserved */
	{0x82, NonHandledInterrupt}, /* irq21, reserved */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+96)}, /* irq22, ADC1 */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+100)}, /* irq23, TIM4 */
	{0x82, (interrupt_handler_t)(MAIN_USER_RESET_ADDR+104)}, /* irq24, flash */
	{0x82, NonHandledInterrupt}, /* irq25, reserved */
	{0x82, NonHandledInterrupt}, /* irq26, reserved */
	{0x82, NonHandledInterrupt}, /* irq27, reserved */
	{0x82, NonHandledInterrupt}, /* irq28, reserved */
	{0x82, NonHandledInterrupt}, /* irq29, reserved */
};
