6502 experiments
================

Inspired by [Ben Eater's 6502 project][be6502] I've decided to try
out my own experiments with it.

This repository contains several simple projects written for 6502
microprocessor. All code is meant to be compiled using [VASM][vasm]
assembler.


Compile and run
---------------

Unfortunately I do not have a real 6502 computer right now, using
[Py65][py65] emulator instead. While it is not a real thing, I'm trying
to keep everything as close to Ben's design as possible. The main
differences are with data output, as it can be seen by comparing
the _hello-world_ and _hello-emulated_ projects.

For convenience, I've added simple makefiles for each project so that
there is no need to enter long commands each time. Then one can use short
commands to compile, run in an emulator or write to the EEPROM.

    make
    make run
    make program



Contents
========

There are several subdirectories, each containing a self-contained
project.

* hello-world - Ben Eater's finished "Hello, World!" program
* hello-emulated - "Hello, World!" adjusted for emulator
* bin2dec - Ben Eater's binary to decimal decoder (transcribed from [video][beb2d])
* double-dabble - Decode binary to decimal using [Double dabble][dd] algorithm


[be6502]: https://eater.net/6502
[vasm]: http://sun.hasenbraten.de/vasm/index.php
[py65]: https://github.com/mnaberez/py65
[beb2d]: https://www.youtube.com/watch?v=v3-a-zqKfgA
[dd]: https://en.wikipedia.org/wiki/Double_dabble
