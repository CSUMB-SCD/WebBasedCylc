#!/bin/bash
# THIS FILE IS PART OF THE CYLC SUITE ENGINE.
# Copyright (C) 2008-2018 NIWA
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Test intercycle dependencies.
. $(dirname $0)/test_header
#-------------------------------------------------------------------------------
set_test_number 3
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-iso8601
run_ok $TEST_NAME python $CYLC_DIR/lib/cylc/cycling/iso8601.py
TEST_NAME=$TEST_NAME_BASE-integer
run_ok $TEST_NAME python $CYLC_DIR/lib/cylc/cycling/integer.py
TEST_NAME=$TEST_NAME_BASE-cycling
run_ok $TEST_NAME python $CYLC_DIR/lib/cylc/cycling/__init__.py
