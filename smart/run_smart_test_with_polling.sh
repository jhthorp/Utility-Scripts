#!/bin/bash
################################################################################
#                         Run SMART Test With Polling                          #
#                                                                              #
#             This script will export a single function that will              #
#  run a SMART conveyance, short or long test and continuusly poll for status  #
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
. "${stack_vars[${#stack_vars[@]}-1]}/run_smart_test.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will run a SMART conveyance, short or long test and continuusly 
# poll for status.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - drive] The drive to test
#   [2 - type] The type of test to run
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
run_smart_test_with_polling ()
{
  declare -r drive=${1}
  declare -r type=${2} # Values: short, long, conveyance
  
  # Collect the Drive Capabilities
  declare -r drive_capabilities=$(smartctl \
    -c ${drive})

  # Set the Drive polling interval
  drive_polling_rate=30 # Default to 30 seconds
  drive_polling_interval=30 # Default to 30 seconds

  # Determine the Drive's Short Self-Test Polling Rates
  if [ "${type}" = "short" ]
  then
      drive_polling_rate=$(echo "${drive_capabilities}" | 
        grep \
          "Short self-test routine" \
          -i \
          -A \
          1 \
      )

      drive_polling_rate=$(echo "${drive_polling_rate}" | 
        grep \
        -o '([^(]\+)' | 
        cut \
          -d '(' \
          -f 2 | 
        cut \
          -d ')' \
          -f 1 \
      )

      # Trim leading spaces
      drive_polling_rate=`echo ${drive_polling_rate} | sed 's/^ *//g'`

      # Trim trailing spaces
      drive_polling_rate=`echo ${drive_polling_rate} | sed 's/ *$//g'`

      drive_polling_interval=$((drive_polling_rate*60/20))

  # Determine the Drive's Long Self-Test Polling Rates
  elif [ "${type}" = "long" ]
  then
      drive_polling_rate=$(echo "${drive_capabilities}" | 
        grep \
          "Extended self-test routine" \
          -i \
          -A \
          1 \
      )

      drive_polling_rate=$(echo "${drive_polling_rate}" | 
        grep \
          -o '([^(]\+)' | 
        cut \
          -d '(' \
          -f 2 | 
        cut \
          -d ')' \
          -f 1 \
      )

      # Trim leading spaces
      drive_polling_rate=`echo ${drive_polling_rate} | sed 's/^ *//g'`
      
      # Trim trailing spaces
      drive_polling_rate=`echo ${drive_polling_rate} | sed 's/ *$//g'`

      drive_polling_interval=$((drive_polling_rate*60/20))

  # Determine the Drive's Conveyance Self-Test Polling Rates
  else # conveyance
      drive_polling_rate=$(echo "${drive_capabilities}" | 
        grep \
          "Conveyance self-test routine" \
          -i \
          -A \
          1 \
      )

      drive_polling_rate=$(echo "${drive_polling_rate}" | 
        grep \
          -o '([^(]\+)' | 
        cut \
          -d '(' \
          -f 2 | 
        cut \
          -d ')' \
          -f 1 \
      )

      # Trim leading spaces
      drive_polling_rate=`echo ${drive_polling_rate} | sed 's/^ *//g'`

      # Trim trailing spaces
      drive_polling_rate=`echo ${drive_polling_rate} | sed 's/ *$//g'`

      drive_polling_interval=$((drive_polling_rate*60/20))
  fi

  # Set the Drive polling interval if not previously set
  if [ ${drive_polling_interval} -le 1 ]
  then
      echo "Could not find polling interval, defaulting to 30 seconds..."
      drive_polling_interval=30 # Default to 30 seconds
  fi

  # Print the Self-Test Polling Times
  echo "SMART Self-Test Estimated RunTime: ${drive_polling_rate} minutes"
  echo "SMART Self-Test Polling Interval: ${drive_polling_interval} seconds"

  # Run the SMART test
  run_smart_test ${drive} ${type} false

  # Print a begin statement
  echo "SMART Self-Test has been initiated..."
  echo $(date "+%Y-%m-%d %H:%M:%S") "SMART Self-Test Status: 0%"

  # Sleep for a percentage of the recommended polling interval before 
  # monitoring for test completion
  for ((i=0; i<${drive_polling_interval}; i++))
  do
    sleep 1
  done

  # Get the SMART Status Code (0-complete, 249-in progress, 41-interrupted)
  drive_self_test_status=$(echo "$(smartctl -a ${drive})" | 
    grep \
      "Self-test execution status:" \
      -i \
      -A \
      1 \
  )

  drive_self_test_status_code=$(echo "${drive_self_test_status}" | 
    grep \
      -o '([^(]\+)' | 
    cut \
      -d '(' -f 2 | 
    cut \
      -d ')' \
      -f 1 \
  )

  # Trim leading spaces
  drive_self_test_status_code=`echo ${drive_self_test_status_code} | sed 's/^ *//g'`

  # Trim trailing spaces
  drive_self_test_status_code=`echo ${drive_self_test_status_code} | sed 's/ *$//g'`

  FIRST_STATUS_PROGRESS="10%"
  FIRST_STATUS_CODE="[${drive_self_test_status_code}]"
  FIRST_STATUS_VAL="${FIRST_STATUS_PROGRESS} ${FIRST_STATUS_CODE}"
  FIRST_STATUS="SMART Self-Test Status: ${FIRST_STATUS_VAL}"
  echo $(date "+%Y-%m-%d %H:%M:%S") ${FIRST_STATUS}

  MAX_INTERVAL=false
  while [ ${drive_self_test_status_code} -ne 0 -a \
          ${drive_self_test_status_code} -ne 41 -a \
          ${drive_self_test_status_code} -ge 240 -a \
          ${drive_self_test_status_code} -le 250 ]
  do
    # Collect the percentage of progress
    drive_self_test_status_progress=$(echo "${drive_self_test_status}" | 
      grep \
        -o '[^ ]\+%' | 
      cut \
        -d '%' \
        -f \
        1 \
    )

    # Trim leading spaces
    drive_self_test_status_progress=`echo ${drive_self_test_status_progress} | sed 's/^ *//g'`

    # Trim trailing spaces
    drive_self_test_status_progress=`echo ${drive_self_test_status_progress} | sed 's/ *$//g'`

    drive_self_test_status_progress=$((100-drive_self_test_status_progress))

    CUR_STATUS_PROGRESS="${drive_self_test_status_progress}%"
    CUR_STATUS_CODE="[${drive_self_test_status_code}]"
    CUR_STATUS_VAL="${CUR_STATUS_PROGRESS} ${CUR_STATUS_CODE}"
    CUR_STATUS="SMART Self-Test Status: ${CUR_STATUS_VAL}"
    echo $(date "+%Y-%m-%d %H:%M:%S") ${CUR_STATUS}

    # If we are over 90%, lower the polling interval to end quicker
    if [ ${drive_self_test_status_progress} -ge 90 -a ${MAX_INTERVAL} == false ]
    then
        echo "We have hit 90%, lowering the polling interval.."
        drive_polling_interval=$((drive_polling_interval/4))
        MAX_INTERVAL=true

        # Cap the polling interval to a minimum of 1 seconds
        if [ ${drive_polling_interval} -le 1 ]
        then
            echo "Polling interval is under 1 second, setting to 1 second..."
            drive_polling_interval=1 # Reset the polling interval to 1 second
        fi
    fi

    # Sleep for a percentage of the recommended polling interval
    for ((i=0; i<${drive_polling_interval}; i++))
    do
      sleep 1
    done

    # Get the SMART Status Code (0-complete, 249-in progress, 41-interrupted)
    drive_self_test_status=$(echo "$(smartctl -a ${drive})" | 
      grep \
        "Self-test execution status:" \
        -i \
        -A \
        1 \
    )

    drive_self_test_status_code=$(echo "${drive_self_test_status}" | 
      grep \
        -o '([^(]\+)' | 
      cut \
        -d '(' \
        -f 2 | 
      cut \
        -d ')' \
        -f \
        1 \
    )

    # Trim leading spaces
    drive_self_test_status_code=`echo ${drive_self_test_status_code} | sed 's/^ *//g'`

    # Trim trailing spaces
    drive_self_test_status_code=`echo ${drive_self_test_status_code} | sed 's/ *$//g'`
  done

  # Print a end statement
  echo $(date "+%Y-%m-%d %H:%M:%S") "SMART Self-Test Status: 100%"
  echo "SMART Self-Test has completed..."
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

  # Collect the type
  if [ "${1}" = "auto_skip" ]
  then
    type=${3}
  else
    type=${2}
  fi

  # Prepare the disclaimer
  if [ "${type}" = "short" ]
  then
      read -d '' warning <<- EOF
!!     DEPENDING ON DISK SIZE, THE RUNTIME CAN EXCEED AN HOUR      !!
EOF
  elif [ "${type}" = "long" ]
  then
      read -d '' warning <<- EOF
!!      DEPENDING ON DISK SIZE, THE RUNTIME CAN EXCEED A DAY       !!
EOF
  else # conveyance
      read -d '' warning <<- EOF
!!     DEPENDING ON DISK SIZE, THE RUNTIME CAN EXCEED AN HOUR      !!
EOF
  fi

  # Print a disclaimer
  cat << EOF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!                             WARNING                             !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
${warning}
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EOF

  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    run_smart_test_with_polling "${@}"
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
        run_smart_test_with_polling "${@}"
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