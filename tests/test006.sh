#!/usr/bin/env bash
#
# Copyright (c) STMicroelectronics 2016
#
# This file is part of pworkdir.
#
# pworkdir is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License v2.0
# as published by the Free Software Foundation
#
# pworkdir is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# v2.0 along with pworkdir. If not, see <http://www.gnu.org/licenses/>.
#

source `dirname $0`/common.sh

TEST_CASE="pworkdir: basic options checks"

version_str=$("$PWORKDIR" --version)
name=$(echo "$version_str" | cut -f1 -d' ')
version=$(echo "$version_str" | cut -f2 -d' ')
vers=$(echo "$version_str" | cut -f3 -d' ')
maj=$(echo "$vers" | cut -f1 -d.)
min=$(echo "$vers" | cut -f2 -d.)
patch=$(echo "$vers" | cut -f3 -d.)
wc=$(echo "$version_str" | wc -w)
[ "$wc" -ge 3 ]
[ "$name" = pworkdir ]
[ "$version" = version ]
[ "$vers" = "$maj"."$min"."$patch" ]

help=$("$PWORKDIR" --help | head -1)
echo "$help" | grep -i "usage:"
