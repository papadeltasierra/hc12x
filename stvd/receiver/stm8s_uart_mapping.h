/* UART mapping since the STM8S003 and STM8S105 use different UART ports. */
#if defined(STM8S003)
#define UART(X) UART1_ ## X
#elif defined(STM8S105)
#define UART(X) UART2_ ## X
#else
#error "No UART mapping defined"
#endif