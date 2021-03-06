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
# Test cylc insert command, with wildcard in a task name string
. "$(dirname "$0")/test_header"
set_test_number 4
install_suite "${TEST_NAME_BASE}" "${TEST_NAME_BASE}"

run_ok "${TEST_NAME_BASE}-validate" cylc validate "${SUITE_NAME}"
run_ok "${TEST_NAME_BASE}" cylc run --hold "${SUITE_NAME}"
LOG="${SUITE_RUN_DIR}/log/suite/log"
poll "! grep -q -F 'Held on start-up' '${LOG}' 2>'/dev/null'"
run_ok "${TEST_NAME_BASE}-insert" cylc insert "${SUITE_NAME}" '2008/*'
poll "! grep -q -F 'Command succeeded: insert_tasks' '${LOG}' 2>'/dev/null'"
cylc stop --max-polls=10 --interval=6 "${SUITE_NAME}" 2>'/dev/null'
cut -d' ' -f 2- "${LOG}" >'trimmed-log'
{
    for I in {001..500}; do
        echo "INFO - [v_i${I}.2008] -inserted"
    done
    echo "INFO - Command succeeded: insert_tasks([u'2008/*'], stop_point_string=None, no_check=False)"
} >'expected-log'
contains_ok 'trimmed-log' 'expected-log'

purge_suite "${SUITE_NAME}"
exit
