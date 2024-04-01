/* HC-12 specific configuration. */
// UART configuration.
#define UART_BAUDRATE       115200
#define UART_WORDLENGTH     UART(WORDLENGTH_8D)
#define UART_STOPBITS       UART(STOP_BITS_1)
#define UART_PARITY         UART(PARITY_EVEN)
#define UART_SYNC_MODE      UART(SYNCMODE_CLOCK_DISABLE)
#define UART_MODE           UART(MODE_RX_ENABLE)

// 4463 interface configuration
#define NSEL_GPIOX          GPIOA
#define NSEL_GPIO_PIN       GPIO_PIN_3
#define NIRQ_GPIOX          GPIOC
#define NIRQ_GPIO_PIN       GPIO_PIN4