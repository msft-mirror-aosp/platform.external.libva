# Copyright (c) 2007 Intel Corporation. All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sub license, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice (including the
# next paragraph) shall be included in all copies or substantial portions
# of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
# IN NO EVENT SHALL PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR
# ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#!/bin/sh

libva_topdir="$1"
version_h_in="$2"

parse_configure_ac() {
    sed -n "/^m4_define.*${1}.*\[\([0-9]*\)\].*/s//\1/p" ${2}
}

parse_configure() {
    sed -n "/^${1}=\([0-9]*\)/s//\1/p" ${libva_topdir}/configure
}

if [ "$1" = "--configure_ac" ]; then
    # $2 specifies the path to configure.ac, $3 the path to version.h.in
    libva_topdir="///"
    version_h_in="$3"
    va_api_major_version=`parse_configure_ac va_api_major_version $2`
    va_api_minor_version=`parse_configure_ac va_api_minor_version $2`
    va_api_micro_version=`parse_configure_ac va_api_micro_version $2`
elif test -f "${libva_topdir}/configure.ac"; then
    CONFIGURE_AC_PATH=${libva_topdir}/configure.ac
    va_api_major_version=`parse_configure_ac va_api_major_version $CONFIGURE_AC_PATH`
    va_api_minor_version=`parse_configure_ac va_api_minor_version $CONFIGURE_AC_PATH`
    va_api_micro_version=`parse_configure_ac va_api_micro_version $CONFIGURE_AC_PATH`
elif test -f "${libva_topdir}/configure"; then
    va_api_major_version=`parse_configure VA_API_MAJOR_VERSION`
    va_api_minor_version=`parse_configure VA_API_MINOR_VERSION`
    va_api_micro_version=`parse_configure VA_API_MICRO_VERSION`
else
    echo "ERROR: configure or configure.ac file not found in $libva_topdir/"
    exit 1
fi
va_api_version="$va_api_major_version.$va_api_minor_version.$va_api_micro_version"

sed -e "s/@VA_API_MAJOR_VERSION@/${va_api_major_version}/" \
    -e "s/@VA_API_MINOR_VERSION@/${va_api_minor_version}/" \
    -e "s/@VA_API_MICRO_VERSION@/${va_api_micro_version}/" \
    -e "s/@VA_API_VERSION@/${va_api_version}/" \
    $version_h_in
