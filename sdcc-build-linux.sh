#!/bin/bash
#
# Copyright (c) 2016 Ekawahyu Susilo
# All Rights Reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set -e

#
# Distribution archive name (without the chunk suffix)
#
distribution_ver=3.9.0
distribution_patch=sdcc-3.9.0-model-stack-auto.patch

#
# Establish the location of the distribution archives and make a working
# directory.  Set up some more directory names
#
base_dir=`pwd -P`

#
# Removing all build directories
#
rm -Rf sdcc
rm -Rf linux

#
# Check for the source files
#
if [ ! -r $base_dir/sdcc-src-$distribution_ver.tar.bz2 ]; then
	echo ""
	echo "  Can't find the distribution files for sdcc-src-$distribution_ver"
	echo "  (looked in the current directory only)"
	echo "  They can be downloaded from http://sdcc.sourceforge.net"
	echo ""
	exit 1
fi

#
# Unpack the distribution
#
echo "Unpacking distribution archive..."
tar xjf sdcc-src-$distribution_ver.tar.bz2

#
# Removing version numbering from SDCC directory
#
echo "Renaming distribution directory..."
mv sdcc-$distribution_ver sdcc

#
# Patching SDCC to build large and huge libraries
#
echo "Patching distribution..."
cp $distribution_patch sdcc
cd sdcc
patch -p 1 < $distribution_patch

#
# Building SDCC for Linux
#
echo "Building SDCC for Linux..."
mkdir $base_dir/linux

./configure \
--prefix="$base_dir/linux" \
--disable-z80-port --disable-z180-port --disable-r2k-port --disable-r3ka-port \
--disable-gbz80-port --disable-ds390-port --disable-ds400-port --disable-pic14-port \
--disable-pic16-port --disable-hc08-port --disable-s08-port

make
make install
make distclean

#
# Done!
#
echo "Done!"
