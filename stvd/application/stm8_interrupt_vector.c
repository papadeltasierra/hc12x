/*	BASIC INTERRUPT VECTOR TABLE FOR STM8 devices
 *	Copyright (c) 2007 STMicroelectronics
 */
#include "stm8s_it.h"

typedef void @far (*interrupt_handler_t)(void);

struct interrupt_vector {
	unsigned char interrupt_instruction;
	interrupt_handler_t interrupt_handler;
};

extern void _stext();     /* startup routine */

struct interrupt_vector const _vectab[] = {
	{0x82, (interrupt_handler_t)_stext}, /* reset */
	{0x82, NonHandledInterrupt}, /* trap  */
	{0x82, NonHandledInterrupt}, /* tli  */
	{0x82, NonHandledInterrupt}, /* awu  */
	{0x82, NonHandledInterrupt}, /* clk  */
	{0x82, NonHandledInterrupt}, /* ext0/gpioa */
	{0x82, NonHandledInterrupt}, /* ext1/gpiob  */
	{0x82, EXTI_PORTC_IRQHandler}, /* ext2/gpioc  */
	{0x82, NonHandledInterrupt}, /* ext3/gpiod  */
	{0x82, NonHandledInterrupt}, /* ext4/gpioe  */
	{0x82, NonHandledInterrupt}, /* irq8, reserved  */
	{0x82, NonHandledInterrupt}, /* irq9, reserved  */
	{0x82, NonHandledInterrupt}, /* spi */
	{0x82, NonHandledInterrupt}, /* tim1 */
	{0x82, NonHandledInterrupt}, /* tim1 */
	{0x82, NonHandledInterrupt}, /* tim2 */
	{0x82, NonHandledInterrupt}, /* tim2 */
	{0x82, NonHandledInterrupt}, /* irq15, reserved */
	{0x82, NonHandledInterrupt}, /* irq16, reserved */
	{0x82, NonHandledInterrupt}, /* uart1, TX */
	{0x82, UART1_RX_IRQHandler}, /* uart1, RX */
	{0x82, NonHandledInterrupt}, /* i2c */
	{0x82, NonHandledInterrupt}, /* irq20, reserved */
	{0x82, NonHandledInterrupt}, /* irq21, reserved */
	{0x82, NonHandledInterrupt}, /* adc1 */
	{0x82, NonHandledInterrupt}, /* tim4 */
	{0x82, NonHandledInterrupt}, /* flash */
	{0x82, NonHandledInterrupt}, /* irq25, reserved */
	{0x82, NonHandledInterrupt}, /* irq26, reserved */
	{0x82, NonHandledInterrupt}, /* irq27, reserved */
	{0x82, NonHandledInterrupt}, /* irq28, reserved */
	{0x82, NonHandledInterrupt}, /* irq29, reserved */
};
