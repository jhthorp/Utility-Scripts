#!/bin/bash
################################################################################
#                     Run A Basic Imaging Read-Write Test                      #
#                                                                              #
#             This script will export a single function that will              #
#         use the DD command to write data across every bit in a drive         #
#            and read all data bits from the same drive in parallel            #
################################################################################
#       Copyright © 2020 - 2021, Jack Thorp and associated contributors.       #
#                                                                              #
#    This program is free software: you can redistribute it and/or modify      #
#    it under the terms of the GNU General Public License as published by      #
#    the Free Software Foundation, either version 3 of the License, or         #
#    any later version.                                                        #
#                                                                              #
#    This program is distributed in the hope that it will be useful,           #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of            #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
#    GNU General Public License for more details.                              #
#                                                                              #
#    You should have received a copy of the GNU General Public License         #
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.    #
################################################################################

################################################################################
#                                 SCRIPT SETUP                                 #
################################################################################
#===============================================================================
# This section will store some "Process Global" variables into a stack that
# fully supports nesting into the upcoming includes so that these variables
# are correctly held intact.
#
# The following variables are currently being stored:
#    0 - SOURCING_INVOCATION - Boolean - If the script was sourced not invoked
#    1 - DIR - String - The script's directory path
#===============================================================================
# Get the global stack if it exists
if [ -z ${stack_vars+x} ]; 
then 
  declare stack_vars=(); 
fi

# Determine the BASH source (SOURCING_INVOCATION)
(return 0 2>/dev/null) &&
stack_vars[${#stack_vars[@]}]=1 || 
stack_vars[${#stack_vars[@]}]=0

# Determine the exectuable directory (DIR)
stack_vars[${#stack_vars[@]}]="${BASH_SOURCE%/*}"
if [[ ! -d "${stack_vars[${#stack_vars[@]}-1]}" ]]; 
then 
  stack_vars[${#stack_vars[@]}-1]="${PWD}"; 
fi

################################################################################
#                               SCRIPT INCLUDES                                #
################################################################################
. "${stack_vars[${#stack_vars[@]}-1]}/../processing/parallel_commands.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/run_imaging_write.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/run_imaging_read.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will use the DD command to write data across every bit in a 
# drive and read all data bits from the same drive in parallel.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - drive] The drive to test
#   [2 - blocksize] The BlockSize to use
#                   Commonly Used Block Sizes:
#                           512b - 512
#                           1K - 1024
#                           2K - 2048
#                           4K - 4096
#                           8K - 8192
#                           16K - 16384
#                           32K - 32768
#                           64K - 65536
#                           128K - 131072
#                           256K - 262144
#                           512K - 524288
#                           1M - 1048576
#                           2M - 2097152
#                           4M - 4194304
#                           8M - 8388608
#                           16M  - 16777216
#                           32M  - 33554432
#                           64M - 67108864
#   [3 - write_random_pattern] Write a random pattern
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
run_imaging_read_write ()
{
  declare -r drive=${1}
  declare -r blocksize=${2:-1048576}
  declare -r write_random_pattern=${3:-false}

  # Local Variables
  declare -r AUTOMATED_SKIP="auto_skip"
  declare -r CUR_DIR="${BASH_SOURCE%/*}"

  declare -r WRITE_SCRIPT="${CUR_DIR}/run_imaging_write.sh"
  declare -r WRITE_PARAMS="${drive} ${blocksize} ${write_random_pattern}"
  declare -r WRITE_PARAMS_AUTO="${AUTOMATED_SKIP} ${WRITE_PARAMS}"
  declare -r WRITE_CMD="${WRITE_SCRIPT} ${WRITE_PARAMS_AUTO}"

  declare -r READ_SCRIPT="${CUR_DIR}/run_imaging_read.sh"
  declare -r READ_PARAMS="${AUTOMATED_SKIP} ${drive} ${blocksize}"
  declare -r READ_PARAMS_AUTO="${AUTOMATED_SKIP} ${READ_PARAMS}"
  declare -r READ_CMD="${READ_SCRIPT} ${READ_PARAMS_AUTO}"

  parallel_commands \
    "${WRITE_CMD}" \
    "${READ_CMD}"
}

################################################################################
#                               SCRIPT EXECUTION                               #
################################################################################
#===============================================================================
# This section will execute if the script is invoked from the terminal rather 
# than sourced into another script as a function.  If the first parameter is 
# "auto_skip" then any prompts will be bypassed.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [ALL] All arguments are passed into the script's function except the first 
#         if it is "auto_skip".
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
if [ ${stack_vars[${#stack_vars[@]}-2]} = 0 ]; # SOURCING_INVOCATION
then
  # Print a copyright/license header
  cat << EOF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| Copyright © 2020 - 2021, Jack Thorp and associated contributors.  |
|          This program comes with ABSOLUTELY NO WARRANTY.          |
|   This is free software, and you are welcome to redistribute it   |
|                     under certain conditions.                     |
|        See the GNU General Public License for more details.       |
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF

  # Print a disclaimer
  cat << EOF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!                             WARNING                             !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!        BY PROCEEDING, ALL DATA ON DISK WILL BE DESTROYED        !!
!!       STOP AND DO NOT RUN IF DISK CONTAINS VALUABLE DATA        !!
!!                                                                 !!
!!      DEPENDING ON DISK SIZE, THE RUNTIME CAN EXCEED A DAY       !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EOF

  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    run_imaging_read_write "${@}"
  else
    CONTINUE=false
    read -p "Would you like to continue (y/n)?" choice
    case "$choice" in 
      y|Y ) CONTINUE=true;;
      n|N ) CONTINUE=false;;
      * ) echo "Invalid Entry";;
    esac

    if [ "${CONTINUE}" = true ]
    then
        # Start the script
        unset CONTINUE
        run_imaging_read_write "${@}"
    fi
    unset CONTINUE
  fi
fi

################################################################################
#                                SCRIPT TEARDOWN                               #
################################################################################
#===============================================================================
# This section will remove the "Process Global" variables from the stack
#===============================================================================
unset stack_vars[${#stack_vars[@]}-1] # DIR
unset stack_vars[${#stack_vars[@]}-1] # SOURCING_INVOCATION