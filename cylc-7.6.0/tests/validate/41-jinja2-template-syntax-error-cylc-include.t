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
# Test validation for a bad Jinja2 TemplateSyntaxError in a suite cylc include.
. $(dirname $0)/test_header
#-------------------------------------------------------------------------------
set_test_number 2
install_suite $TEST_NAME_BASE $TEST_NAME_BASE
#-------------------------------------------------------------------------------
TEST_NAME=$TEST_NAME_BASE-val
run_fail "$TEST_NAME" cylc validate suite.rc
cmp_ok "$TEST_NAME.stderr" <<'__ERROR__'
Jinja2Error:
  File "<unknown>", line 7, in template
TemplateSyntaxError: Encountered unknown tag 'end'. Jinja was looking for the following tags: 'elif' or 'else' or 'endif'. The innermost block that needs to be closed is 'if'.
Context lines:
# This is a bit of graph configuration.
        {% if true %}
        graph = foo
        {% end if %	<-- Jinja2Error
__ERROR__
#-------------------------------------------------------------------------------
purge_suite $SUITE_NAME
exit
