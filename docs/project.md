# HC-12-Expanded Project Guide

## Notes
- Everything below has been attempted usnig an [HC-12] v2.3
- The common [Putty] serial cnosole does not seem to work.  This might be a settings issue on my part but every command I send it responses `ERROR`.
    - The [Arduino IDE] `monitor` program seems to work fine.

## What is an [HC-12]?
An [HC-12] is a cheap little board that can perform quite complex wireless communications at frequencies from about 200MHz to 900MHz.  It achieves this through the use of two chips:

- An [STMicroelectronics] [STM8] 8-bit processor that is the interface that configures and transmits and receives via a...
- [Silicon Labs] [4463] High-Performance, Low Current Tranceiver.

Using the standard firmware, data cna be transmitted between pairs of [HC-12]s using the default custom protocol and settings.

## Aims of this Project
The [4463] can do so much more than the [HC-12] standard firmware exposes, and that is the purpose of this project, to free the [4463] and allow the [HC-12] to do more.  So this project will:

- Document the reprogramming of an [HC-12]
- Reprogram an [HC-12] to receive [WMBUS] messages from a water meter
- Reprogram an [HC-12] to receive [4GSK] messages from car park signage.
- Attempt to create a standard framework that can be used to extend the [HC-12] for other functions using whatever functions of the [4463] your project requires.

## Hardware Requirements
- An [HC-12]
- A suitable USB-TTL serial port device
- ??? aka _Blue Pill_

## Software Requirements
- [HC-12] firmware extractor i.e. [rumpeltux/hc12]
- [ST Visual Programmer STM8]
- An alternative is the older [STM8 IDE]
- [STM8] software library
- Silicon Micro WMBUS package ?????
- [Ghidra] _A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission_ if yuo wish to reverse engineer the firmware
    - [esaulenka/ghidra_STM8] is required to allow [Ghidra] to understand the STM8 byte code

### Installling the older [STM8 IDE]
> It appears that the [ST Visual Programmer STM8] is the correct IDE to use and it installs on Windows 10 without issues.  These instructions are retained purely for information.

The [STM8 IDE] has two issues:

1. The installer is a 16-bit program and modern 64-bit Windows does not run 16-bit programs _out of the box_
1. The [STM8 IDE] itself expects to run on older 32-bit Windows systems and does not recognise Windows 7/8/10/11.  The [STM8 IDE] is a standard 32-bit executable and will run on these platforms!

So we solve this by installing via the [otya128/winevdm] program running in Windows-XP compatibility mode.

- Download the [STM8 IDE] and unzip it
- Download [otya128/winevdm] and unzip it
- Open Windows File Explorer and navigate to the folder containing [otya128/winevdm]
- Right-click on the `otvdm` application and open `Properties`
- From the `Compatibility` tab, select `Run this program in compatibility mode for` and select `Windows XP (Service Pack 3)`
- Return to a command-line and navigate to the [STM8 IDE] folder
- Run [otya128/winevdm] for example...

```
c:\stmc8ide> c:\winevdm\otvdm setup.exe
```

You should see this:
- Windows might complain because it doesn't recognise `otvdm` as a _safe_ program; you can ignore this providing you got `otvdm` from the proper location and believe it to be safe
- The [STM8 IDE] installer will run
- The [STM8 IDE] installer will complain about some debugging drivers (you can't use these on Windows 7/8/10/11)
- The [STM8 IDE] should install and should happily launch and build projects.

### Associating the STM8 standard Peripherals Library
?????????????????????

## Standard HC-12 (STM8) Firmware
See the [rumpeltux/hc12] tools for instructions on downloading the standard [HC-12] firmware.

> It is very much recommended that you download your firmware first so that you can restore your [HC-12] if required.

Some projects patch teh standard [HC-12] firmware but this project will not do thta.  Instead a totally new set of firmware will be written that emulates some features of the standard firmware but allows the functionality to be changed by building in custom parts.

### Emulated Features
- The use of `AT` commands via the `set` line to configure the [HC-12] will be replicated
- The `AT+UPDATE` command to install different firware will be emulated.

[HC-12]: https://statics3.seeedstudio.com/assets/file/bazaar/product/HC-12_english_datasheets.pdf
[Putty]: https://www.putty.org/
[Arduino IDE]: https://www.arduino.cc/en/software
[rumpeltux/hc12]: https://github.com/rumpeltux/hc12
[Ghidra]: https://ghidra-sre.org/
[esaulenka/ghidra_STM8]: https://github.com/esaulenka/ghidra_STM8
[STMicroelectronics]: https://www.st.com
[stm8]: https://www.st.com/en/microcontrollers-microprocessors/stm8-8-bit-mcus.html
[Silicon Labs]: https://silabs.com
[4463]: https://www.silabs.com/documents/public/data-sheets/Si4463-61-60-C.pdf
[WMBUS]: https://en.wikipedia.org/wiki/Meter-Bus
[4GSK]: https://en.wikipedia.org/wiki/Frequency-shift_keying
[STM8 IDE]: https://www.st.com/en/development-tools/stm8-ides/products.html
[otya128/winevdm]: https://github.com/otya128/winevdm?tab=readme-ov-file
[ST Visual Programmer STM8]: https://www.st.com/en/development-tools/stvp-stm8.html