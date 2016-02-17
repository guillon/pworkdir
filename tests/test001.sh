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

TEST_CASE="pworkdir: sequential creation of workdirs"

echo "Allocating workdirs for pid: $$"
rm -rf workdir-*
for i in $(seq 1 12); do
    workdir=$("$PWORKDIR" -d --pid $$ --timeout 3 --workdirs-limit 6 --space 0 --message-interval 1 alloc) || break
    echo "$i: allocated: $workdir"
done 2>&1 | tee -a log

"$PWORKDIR" list-all | xargs "$PWORKDIR" info

count=$(grep -c ": allocated:" log || true)
[ "$count" = 6 ]
count=$(grep -c "could not allocate " log || true)
[ "$count" = 1 ]
count=$(grep -c "waiting for a free" log || true)
[ "$count" -ge 1 ]



