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

# common setup for unit tests

set -e
set -o pipefail

DIRNAME="$(dirname "$(readlink -e "$0")")"
TEST="$(basename "$0")"
SRCDIR="${SRCDIR:-$(readlink -e "$DIRNAME/..")}"
PWORKDIR="${PWORKDIR:-$SRCDIR/pworkdir}"
TMPDIR="${TMPDIR:-/tmp}"
KEEPTEST="${KEEPTEST:-0}"
KEEPFAIL="${KEEPFAIL:-0}"
_skipped=0
_xfail=0

test_cleanup() {
  : # Override this function in the test if some local cleanup is needed
}

cleanup() {
  local exit=$?
  set +x
  trap - INT QUIT TERM EXIT
  test_cleanup
  cd "$TMPDIR" # ensure not in TMPTEST before cleaning
  [ -d "$TMPTEST" ] && [ "$KEEPTEST" = 0 ] && [ "$KEEPFAIL" = 0 -o $exit = 0 ] && chmod -R +rwX "$TMPTEST" && rm -rf "$TMPTEST"
  [ $exit -ge 128 ] && interrupted && exit $exit
  [ $_skipped = 1 ] && exit 0
  [ $exit = 0 -a $_xfail = 1 ] && failure_xpass && exit 1
  [ $exit != 0 -a $_xfail = 1 ] && success_xfail && exit 0
  [ $exit = 0 -a $_xfail = 0 ] && success
  [ $exit != 0 -a $_xfail = 0 ] && failure
  exit $exit
}

if [ "$DEBUGTEST" = "" ]; then
  exec {_fd_out}>&1 {_fd_err}>&2 >"$TEST.log" 2>&1
else
  _fd_out=1
  _fd_err=2
fi

trap "cleanup" INT QUIT TERM EXIT

interrupted() {
  set +x
  echo "***INTERRUPTED: $TEST: $TEST_CASE" >&$_fd_out
}

failure() {
  set +x
  local reason=${1+": $1"}
  echo "***FAIL: $TEST: $TEST_CASE$reason" >&$_fd_out
}

failure_xpass() {
  set +x
  local reason=${1+": $1"}
  echo "***FAIL: XPASS: $TEST: $TEST_CASE$reason" >&$_fd_out
}

success() {
  set +x
  echo "SUCCESS: $TEST: $TEST_CASE" >&$_fd_out
}

success_xfail() {
  set +x
  echo "SUCCESS: XFAIL: $TEST: $TEST_CASE" >&$_fd_out
}

skip() {
  set +x
  local reason=${1+": $1"}
  echo "---SKIP: $TEST: $TEST_CASE$reason" >&$_fd_out
  _skipped=1
  exit 0
}

xfail() {
  local reason=${1+": $1"}
  echo "Mark test as XFAIL$reason" >&$_fd_out
 _xfail=1
}

chmod -R +rwX "$TEST.dir" 2>/dev/null || true
rm -rf "$TEST.dir"
[ "$KEEPTEST" != 0 -o "$KEEPFAIL" != 0 ] || TMPTEST=$(mktemp -d $TMPDIR/pworkdir.XXXXXX)
[ "$KEEPTEST" = 0 -a "$KEEPFAIL" = 0 ] || TMPTEST=$(mkdir -p "$TEST.dir" && echo "$PWD/$TEST.dir")
[ "$KEEPTEST" = 0 -a "$KEEPFAIL" = 0 ] || echo "Keeping test directory in: $TMPTEST" >&$_fd_out
[ "$DEBUGTEST" = "" ] || PS4='+ $0: ${FUNCNAME+$FUNCNAME :}$LINENO: '
[ "$DEBUGTEST" = "" ] || set -x
cd "$TMPTEST"


