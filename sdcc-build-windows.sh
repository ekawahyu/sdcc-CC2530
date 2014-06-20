#!/bin/bash
#
# Copyright (c) 2014 Ekawahyu Susilo
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

#
# Distribution archive name (without the chunk suffix)
#
distribution_ver=3.4.0
distribution_patch=sdcc-model-stack-auto.patch

#
# Establish the location of the distribution archives and make a working
# directory.  Set up some more directory names
#
base_dir=`pwd -P`

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
tar xzU -f sdcc-src-$distribution_ver.tar.bz2

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
# Building SDCC for Windows
#
echo "Building SDCC for Windows..."
mkdir $base_dir/win

export LDFLAGS="-L/opt/local/lib"
export CPPFLAGS="-I/opt/local/include"

./configure \
CC="i386-mingw32-gcc" \
CXX="i386-mingw32-g++" \
RANLIB="i386-mingw32-ranlib" \
STRIP="i386-mingw32-strip" \
--prefix="$base_dir/win" \
--datarootdir="$base_dir/win" \
docdir="\${datarootdir}/doc" \
include_dir_suffix="include" \
non_free_include_dir_suffix="non-free/include" \
lib_dir_suffix="share/sdcc/lib" \
non_free_lib_dir_suffix="non-free/lib" \
sdccconf_h_dir_separator="\\\\" \
--disable-device-lib \
--host=i386-mingw32 \
--build=unknown-unknown-linux-gnu \
--disable-z80-port --disable-z180-port --disable-r2k-port --disable-r3ka-port \
--disable-gbz80-port --disable-ds390-port --disable-ds400-port --disable-pic14-port \
--disable-pic16-port --disable-hc08-port --disable-s08-port

make
make install
make distclean

#
# Building SDCC for Mac OSX
#
echo "Building SDCC for Mac OSX..."
mkdir $base_dir/osx

./configure \
--prefix="$base_dir/osx" \
--disable-z80-port --disable-z180-port --disable-r2k-port --disable-r3ka-port \
--disable-gbz80-port --disable-ds390-port --disable-ds400-port --disable-pic14-port \
--disable-pic16-port --disable-hc08-port --disable-s08-port

make
make install
make distclean

#
# Copying SDCC libraries from OSX built to Windows built
#
echo "Copying SDCC libraries from OSX built to Windows built..."

cd $base_dir
cp -R $base_dir/osx/share $base_dir/win

#
# Done!
#
echo "Done!"
