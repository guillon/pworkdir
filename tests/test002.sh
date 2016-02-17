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

TEST_CASE="pworkdir: parallel creation of workdirs"

rm -rf workdir-*
(set +x
    env SHELL="$(which bash)" PWORKDIR="$PWORKDIR" parallel -j 60 -u 'echo {}: allocated: $("$PWORKDIR" --pid '$$' -t 5 -n 6 -s 0 --message-interval 1 alloc || echo failed)' ::: $(seq 1 60)
    ) 2>&1 | tee -a log

count=$(grep -c ": allocated:" log || true)
[ "$count" = 60 ]
count=$(grep -c ": allocated: failed" log || true)
[ "$count" = 54 ]
count=$(grep -c "waiting for a free" log || true)
[ "$count" -ge 1 ]

