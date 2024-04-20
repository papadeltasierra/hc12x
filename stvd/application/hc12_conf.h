/* HC-12 specific configuration. */
// UART configuration.
#define UART1_BAUDRATE      115200
#define UART1_WORDLENGTH    UART1_WORDLENGTH_8D
#define UART1_STOPBITS      UART1_STOPBITS_1
#define UART1_PARITY        UART1_PARITY_EVEN
#define UART1_SYNCMODE      UART1_SYNCMODE_CLOCK_DISABLE
#define UART1_MODE          UART1_MODE_RX_ENABLE

// 4463 interface configuration
#define NSEL_GPIOX          (GPIOA)
#define NSEL_GPIO_PIN       (GPIO_PIN_3)
#define SDN_GPIOX           (GPIOD)
#define SDN_GPIO_PIN        (GPIO_PIN_4)
#define NIRQ_GPIOX          (GPIOC)
#define NIRQ_GPIO_PIN       (GPIO_PIN_4)
#define CTS_GPIOX           (GPIOC)
#define CTS_GPIO_PIN        (GPIO_PIN_3)
#define TX_STATE_GPIOX      (GPIOB)
#define TX_STATE_GPIO_PIN   (GPIO_PIN_4)
