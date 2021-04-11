#!/bin/bash
################################################################################
#                            TrueNAS Drive Burn-In                             #
#                                                                              #
#             This script will export a single function that will              #
#                   begin a drive Burn-In for a single drive                   #
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
. "${stack_vars[${#stack_vars[@]}-1]}/../smart/run_smart_test_with_polling.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../smart/read_smart_test_results.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../imaging/run_imaging.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../badblocks/run_badblocks.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will begin a drive Burn-In for a single drive.
#
# The following steps will be performed:
#   01) Pull drive info and display it
#   02) Run a SMART conveyance test
#   03) Run a SMART short test
#   04) Run a SMART long test
#   05) Read SMART results and display them
#   06) Run a basic imaging write test
#   07) Read SMART results and display them
#   08) Run a basic imaging read test
#   09) Read SMART results and display them
#   10a) If an HDD, perform the following steps (a)
#   10a1) Run a basic imaging read-write test
#   10a2) Read SMART results and display them
#   10a3) Run a destructive BadBlocks test
#   10a4) Read SMART results and display them
#   10b) If an SSD, perform the following steps (b)
#   10b1) Nothing at this time
#   11) Run a SMART conveyance test
#   12) Run a SMART short test
#   13) Run a SMART long test
#   14) Read SMART results and display them
#   15) If desired, zero-out the drive
#   16) Pull drive info and display it
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - drive] The drive to test
#   [2 - zero_drive] The switch to zero the drive after testing has completed
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
burnin_drive ()
{
  declare -r drive=${1}
  declare -r zero_drive=${2-false}

  declare -r AUTOMATED_SKIP="auto_skip"
  declare -r IMAGING_BS=1048576
  declare -r BADBLOCKS_BS=4096

  declare -r BORDER_PC="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  declare -r BORDER="${BORDER_PC}${BORDER_PC}${BORDER_PC}${BORDER_PC}"

  version="1.0.0"
  filename=$(echo "${drive}" | 
    sed \
      -e 's/\//_/g' \
  )
  filename="${filename}.txt"

  # Print a copyright/license header
  cat > ${filename} << EOF
Copyright © 2020 - 2021, Jack Thorp and associated contributors.
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under certain conditions.
See the GNU General Public License for more details.
EOF

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Print some disclaimer info
  cat >> ${filename} << EOF
This file was generated by running the burn-in scripts (Version ${version}) located at:
https://github.com/jhthorp/Utility-Scripts

For support, please create a GitHub Issue (https://github.com/jhthorp/Utility-Scripts/issues/new) 
or submit a Pull Request.

Run Options:
  Drive ID: ${drive}
  Zero Drives: ${zero_drive}
EOF

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Print the Drive Info
  drive_info=$(smartctl \
    -a \
    ${drive} \
  )
  echo "${drive_info}" \
    >> ${filename} \
    2>&1

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Print the Drive Capabilities
  declare -r drive_capabilities=$(smartctl \
    -c \
    ${drive} \
  )
  echo "${drive_capabilities}" \
    >> ${filename} \
    2>&1

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Determine the Drive's Rotational Rate
  drive_rotational_rate=$(echo "${drive_info}" | 
    grep \
      'Rotation Rate' \
  )
  drive_rotational_rate=${drive_rotational_rate//Rotation Rate:}

  # Trim leading spaces
  drive_rotational_rate=`echo ${drive_rotational_rate} | sed 's/^ *//g'`

  # Trim trailing spaces
  drive_rotational_rate=`echo ${drive_rotational_rate} | sed 's/ *$//g'`

  if [ "${drive_rotational_rate}" = "Solid State Device" ]
  then
      echo "Drive is a SSD..." \
        >> ${filename} \
        2>&1
      drive_medium="SSD"
  else
      echo "Drive is a HDD..." \
        >> ${filename} \
        2>&1
      drive_medium="HDD"
  fi

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Run the SMART tests
  echo "Running SMART conveyance test..." \
    >> ${filename} \
    2>&1
  $(run_smart_test_with_polling \
    ${drive} \
    "conveyance" \
    >> ${filename} \
    2>&1 \
  )

  echo "Running SMART short test..." \
    >> ${filename} \
    2>&1
  $(run_smart_test_with_polling \
    ${drive} \
    "short" \
    >> ${filename} \
    2>&1 \
  )

  echo "Running SMART long test..." \
    >> ${filename} \
    2>&1
  $(run_smart_test_with_polling \
    ${drive} \
    "long" \
    >> ${filename} \
    2>&1 \
  )

  # Get the SMART Report
  $(read_smart_test_results \
    ${drive} \
    >> ${filename} \
    2>&1 \
  )

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Run the basic imaging write test
  echo "Running IMAGING write test..." \
    >> ${filename} \
    2>&1
  $(run_imaging \
    ${drive} \
    ${IMAGING_BS} \
    "write" \
    false \
    >> ${filename} \
    2>&1 \
  )

  # Get the SMART Report
  $(read_smart_test_results \
    ${drive} \
    >> ${filename} \
    2>&1 \
  )

  # Run the basic imaging read test
  echo "Running IMAGING read test..." \
    >> ${filename} \
    2>&1
  $(run_imaging \
    ${drive} \
    ${IMAGING_BS} \
    "read" \
    >> ${filename} \
    2>&1 \
  )

  # Get the SMART Report
  $(read_smart_test_results \
    ${drive} \
    >> ${filename} \
    2>&1 \
  )

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Run the HDD/SSD steps
  if [ "${drive_medium}" = "SSD" ]
  then
      echo "Running SSD tests..." \
        >> ${filename} \
        2>&1
  else
      echo "Running HDD tests..." \
        >> ${filename} \
        2>&1

      # Run the basic imaging read-write test
      echo "Running IMAGING read-write test..." \
        >> ${filename} \
        2>&1
      $(run_imaging \
        ${drive} \
        ${IMAGING_BS} \
        "read-write" \
        false \
        >> ${filename} \
        2>&1 \
      )

      # Get the SMART Report
      $(read_smart_test_results \
        ${drive} \
        >> ${filename} \
        2>&1 \
      )

      # Run a Badblocks test
      echo "Running BADBLOCKS test..." \
        >> ${filename} \
        2>&1
      $(run_badblocks \
        ${drive} \
        ${BADBLOCKS_BS} \
        true \
        >> ${filename} \
        2>&1 \
      )

      # Get the SMART Report
      $(read_smart_test_results \
        ${drive} \
        >> ${filename} \
        2>&1 \
      )
  fi

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1
  
  # Run the SMART tests
  echo "Running SMART conveyance test..." \
    >> ${filename} \
    2>&1
  $(run_smart_test_with_polling \
    ${drive} \
    "conveyance" \
    >> ${filename} \
    2>&1 \
  )

  echo "Running SMART short test..." \
    >> ${filename} \
    2>&1
  $(run_smart_test_with_polling \
    ${drive} \
    "short" \
    >> ${filename} \
    2>&1 \
  )

  echo "Running SMART long test..." \
    >> ${filename} \
    2>&1
  $(run_smart_test_with_polling \
    ${drive} \
    "long" \
    >> ${filename} \
    2>&1 \
  )

  # Get the SMART Report
  $(read_smart_test_results \
    ${drive} \
    >> ${filename} \
    2>&1 \
  )

  if [ "${zero_drive}" = true ]
  then
      # Print a border
      echo ${BORDER} \
        >> ${filename} \
        2>&1

      # If this is an SMR drive, zero out the bits to prevent performance loss
      echo "Zeroing out the drive..." \
        >> ${filename} \
        2>&1
      $(run_imaging \
        ${drive} \
        ${IMAGING_BS} \
        "write" \
        false \
        >> ${filename} \
        2>&1 \
      )
  else # TODO: Add this as a switch?
    # Run a pass with a RANDOM pattern
    echo "Prepare the drive for data by randomizing the bits..." \
      >> ${filename} \
      2>&1
    openssl \
      enc \
        -aes-256-ctr \
        -pass pass:"$(dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64)" \
        -nosalt \
        < /dev/zero \
        > ${drive}
  fi

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Print the Drive Info
  drive_info=$(smartctl \
    -a \
    ${drive} \
  )
  echo "${drive_info}" \
    >> ${filename} \
    2>&1

  # Print a border
  echo ${BORDER} \
    >> ${filename} \
    2>&1

  # Add a COMPLETED message
  echo "Burn-In has completed..." \
    >> ${filename} \
    2>&1
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
!!  DEPENDING ON DISK SIZE, THE RUNTIME CAN EXCEED SEVERAL DAYS    !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EOF

  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    burnin_drive "${@}"
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
        burnin_drive "${@}"
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