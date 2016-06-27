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

TEST_CASE="pworkdir: parallel creation of workdirs with relative space constraint"

# Force global dir to be local
PWORKDIR="$PWORKDIR --workdirs-basedir $PWD"

# Compute 10% of free space and arrange to have at most 6 workdirs in the limit
free_space="$(df -k "." | tail -1 | tr '\t' ' ' | sed 's/  */,/g' | cut -f2 -d, || true)"
allowed_space=$((free_space / 10))
workdir_space=$((allowed_space / 6))

env env SHELL="$(which bash)" PWORKDIR="$PWORKDIR" parallel -j 20 -u 'echo {}: allocated: $($PWORKDIR --pid '$$' -t 5 --workdirs-space-ratio 10% --space '"$workdir_space"' --message-interval 1 alloc || echo failed)' ::: $(seq 1 20) 2>&1 | tee -a log

count=$(grep -c ": allocated:" log | grep -v '^+' || true)
[ "$count" = 20 ]
count=$(grep -c ": allocated: failed" log | grep -v '^+' || true)
[ "$count" = 14 ]
count=$(grep -c "waiting for a free" log | grep -v '^+' || true)
[ "$count" -ge 1 ]
