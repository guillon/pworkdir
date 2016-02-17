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

SHELL=/bin/sh
PREFIX=/usr/local

help:
	@echo "usage: make TARGET [PARAMETERS]"
	@echo
	@echo "where TARGET is one of:"
	@echo "make all       : build all (no-op for this software)"
	@echo "make check     : run unit tests"
	@echo "make install   : install into PREFIX"
	@echo "make clean     : clean build and tests"
	@echo "make distclean : clean everything"
	@echo "make uninstall : uninstall from PREFIX"
	@echo "make dependencies : force download of all dependencies"
	@echo
	@echo "where PARAMETERS are from (current values):"
	@echo "PREFIX=$(PREFIX)"


all:

check: all
	$(MAKE) -C tests check

dependencies:
	$(MAKE) -C tests dependencies

clean:
	$(MAKE) -C tests clean

distclean:
	$(MAKE) -C tests distclean

install: all
	mkdir -p $(PREFIX)/bin
	cp pworkdir $(PREFIX)/bin
	chmod 755 $(PREFIX)/bin/pworkdir

uninstall:
	rm -f $(PREFIX)/bin/pworkdir

.PHONY: help all check clean distclean install uninstall dependencies
