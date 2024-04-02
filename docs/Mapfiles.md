# Reading a COSMIC Map File
> Work in progress!
>
> There is an issue with identifying named segments and where they are located!
> Do we have to guess based on address range?

## References
- [ST Community; .bsct and .ubsct segments][ST490093]
- [COSMIC Software; C Cross Compiler User’s Guide for ST Microelectronics STM8][COSMIC]

## Example Map File
```
Map of Release\bootloader.sm8 from link file Release\bootloader.lkf - Sat Mar 30 10:54:56 2024


                               --------
                               Segments
                               --------

start 00008080 end 000080a2 length    34 segment .const
start 00008118 end 00008966 length  2126 segment .text
start 00004000 end 00004000 length     0 segment .eeprom
start 00000000 end 00000001 length     1 segment .bsct, initialized
start 000080af end 000080b0 length     1 segment .bsct, from
start 00000001 end 00000091 length   144 segment .ubsct
start 00000091 end 00000091 length     0 segment .bit
start 00000091 end 00000091 length     0 segment .share
start 00000100 end 00000100 length     0 segment .data
start 00000100 end 00000100 length     0 segment .bss
start 00000100 end 00000168 length   104 segment .FLASH_CODE, initialized
start 000080b0 end 00008118 length   104 segment .FLASH_CODE, from
start 00000000 end 000004ff length  1279 segment .info.
start 00008000 end 00008080 length   128 segment .const
start 000080a2 end 000080af length    13 segment .init


                               -------
                               Modules
                               -------

C:\Program Files (x86)\COSMIC\FSE_Compilers\CXSTM8\Lib\crtsi0.sm8:
start 00008118 end 00008168 length    80 section .text
start 00000100 end 00000100 length     0 section .bss
start 00000001 end 00000001 length     0 section .ubsct
start 00000000 end 00000033 length    51 section .info.
...
```
### Segment Totals
|Segment|Resource|Purpose|
|-|-|-|
|.text|ROM|Machine code (or program) section in flash ROM|
|.const|ROM|Constant and literal data in flash ROM|
|.eeprom|EEPROM|Data stored in EEPROM|
|.bsct, initialized|RAM|(`@tiny`)Initialized data from page0 aka _short range memory_|
|.bsct, from|ROM|...and where the data comes from in flash ROM|
|.ubsct|ROM & RAM|(`@tiny`) Uninitialized data in page0|
|.bit|ROM & RAM|Bitwise variables (?? but stored where??)
|.data|ROM & RAM|(`@near`) Initialized data out of page0 aka _long range memory_ (will be copied to RAM)|
|.fdata|ROM & RAM|`@far` large variables|
|.bss|ROM & RAM|(`@near`) Uninitialized data out of page0 aka _long range memory_ (will be copied to RAM)|
|.FLASH_CODE, initialized<br/>aka `-ic` code|RAM|Machine code specifically copied from flash ROM to RAM by setting the `-ic` linker option|
|.FLASH_CODE, from|ROM|...and where the machine code comes from in flash|
|.info|Host|Contains component version and options use to compile and link the program|
|.init|Host|
|.debug|Host|Function information etc for use by debuggers|
|.share|ROM & RAM|Do not know!|

#### So What Does This Mean?
Using the example from above...
|Resource|segments that use it|
|-|-|
|Flash ROM|.text, .const, .bsct from, .ubsct, .bit, .data, .bss, `-ic`|
|RAM|.bsct initialized, .ubsct, .bit, .data, .bss, `-ic`|
|EEPROM|.eeprom|
|Debugging|.info, .debugging|

Which for the program above means:
|||
|-|-|
|RAM Usage:| 1234|
|RAM Usage:|1234|


> Debugging resources are not used on your target hardware (`stm8s`) but are used by the external machine (PC typically) that you connect to the `stm8s` via ST Link.


## Placing Data
```
@tiny char aa;          // will go to .ubsct
@tiny char aa = 10;     // will go to .bsct
@near char aa;          // will go to .bss
@near char aa = 10;     // will go to .data
```
See [Memory Models for code smaller than 64K][COSMIC] which says:
- **Stack Short** (`mods0`) defaults global variables to _short range_ (maximum of 256 bytes); variables can be accessed explicity _long range_ using the `@near` modifier
- **Stack Long** (`modsl0`) defaults global variables to _long range_; variables in short range can be explcitly accessed using the `@tiny` modifier.

> [COSMIC] libraries used with <64kB memorty models are named `<something>0.sm8`; note the `0`!
>
> `@far` pointers are also possible but these are not required when the memory avialable is less than 64kB.

All function pointers are defaulted to `@near` i.e. 2bytes.




[ST490093]: https://community.st.com/t5/stm8-mcus/bsct-and-ubsct-segments/td-p/490093
[COSMIC]: https://www.cosmicsoftware.com/download_stm8_free.php