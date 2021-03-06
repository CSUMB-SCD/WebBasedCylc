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

set_test_number 14

# Configure a fake editor that just copies a job file to ${DESTFILE}.
create_test_globalrc '' '
[editors]
    terminal = my-editor
    gui = my-editor'


function run_tests {
    HOST=$1

    TEST_NAME="${TEST_NAME_BASE}-validate"
    run_ok "${TEST_NAME}" cylc validate --set="HOST=$HOST" "${SUITE_NAME}"

    # Run the suite to generate some log files.
    TEST_NAME="${TEST_NAME_BASE}-suite-run"
    run_ok "${TEST_NAME}" cylc run --set="HOST=$HOST" --no-detach "${SUITE_NAME}"

    LOG_DIR="$(cylc get-global-config --print-run-dir)/${SUITE_NAME}"
    JOB_LOG_DIR="${LOG_DIR}/log/job/1/foo/01"

    for OPT_JOBFILE in -o_job.out -e_job.err -u_job.status \
            -a_job-activity.log "-f job.custom_job.custom"; do
        OPT="${OPT_JOBFILE%_*}"
        JOBFILE="${OPT_JOBFILE#*_}"
        TEST_NAME="${TEST_NAME_BASE}-${JOBFILE}"
        export DESTFILE="${JOBFILE}.edit"
        # Check we can view the job log file in the "editor".
        run_ok "${TEST_NAME}" cylc cat-log ${OPT} --teditor "${SUITE_NAME}" foo.1
        # Compare viewed (i.e. copied by the fake editor) file with the original.
        cmp_ok "${DESTFILE}" "${JOB_LOG_DIR}/${JOBFILE}"
    done

    # Finally, test --geditor on the 'job' file.
    TEST_NAME="${TEST_NAME_BASE}-job"
    JOBFILE="job"
    export DESTFILE="${JOBFILE}.edit"
    run_ok "${TEST_NAME}" cylc cat-log --geditor "${SUITE_NAME}" foo.1
    cmp_ok "${DESTFILE}" "${JOB_LOG_DIR}/${JOBFILE}"
}
