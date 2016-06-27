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

TEST_CASE="pworkdir: parallel creation of workdirs with absolute space constraint"

# Force global dir to be local
PWORKDIR="$PWORKDIR --workdirs-basedir $PWD"

env SHELL="$(which bash)" PWORKDIR="$PWORKDIR" parallel -j 20 -u 'echo {}: allocated: $($PWORKDIR --pid '$$' -t 5 --workdirs-limit 20 --workdirs-space-limit 1G --space 200M --message-interval 1 alloc || echo failed)' ::: $(seq 1 20) 2>&1 | tee -a log

count=$(grep ": allocated:" log | grep -v '^+' | wc -l || true)
[ "$count" = 20 ]
count=$(grep ": allocated: failed" log | grep -v '^+' | wc -l || true)
[ "$count" = 15 ]
count=$(grep "waiting for a free" log | grep -v '^+' | wc -l || true)
[ "$count" -ge 1 ]
