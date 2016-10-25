SDCC-CC2530
===========

A script to build SDCC for Windows on OSX/Linux with small, large and huge C libraries. This script only builds compiler for 8051-based microcontroller, such as TI CC2530. If you want to build other compiler, remove some of the compiler options. For more information, read SDCC manual from http://sdcc.sourceforge.net

Cross compile SDCC on OS X
==========================

1. Download SDCC source code from http://sdcc.sourceforge.net
2. Modify distribution_ver to the version you want to build.
3. Execute sdcc-build-windows.sh from terminal application.

Tested SDCC version to build
============================
SDCC-3.1.0, SDCC-3.3.0, SDCC-3.4.0, SDCC-3.5.0, SDCC-3.6.0

Added script to build on OS X local directory
=============================================
This script is easy to modify for /usr/local or other prefixes as necessary. It is still a work-in-progress
