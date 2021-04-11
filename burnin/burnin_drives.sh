#!/bin/bash
################################################################################
#                            TrueNAS Drives Burn-In                            #
#                                                                              #
#             This script will export a single function that will              #
#               begin a drive Burn-In for a collection of drives               #
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
. "${stack_vars[${#stack_vars[@]}-1]}/../tmux/start_tmux_session.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../tmux/attach_tmux_session.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../tmux/split_window_horizontal.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../tmux/set_layout_tiled.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../tmux/select_session_pane.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../tmux/send_tmux_pane_command.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../tmux/end_tmux_session.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/../status/list_drives.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/burnin_drive.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will begin a drive Burn-In for a collection of drives.
#
# The following steps will be performed:
#   01) Start a new TMUX session named “drive_burnin[_{session_suffix}]” 
#       The brackets ([]) indicate the format used if a suffix is provided
#   02) Pull drive list from passed in values or grab all available SMART drives
#   03) Prompt for the user to confirm, if not ask about each drive
#   04) Setup a TMUX grid layout for all drives being burned in
#   05) Attach to the new TMUX session
#   06) Start the Burn-In process
#   07) End the TMUX session, if chosen, on detach
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - drives_override] The array of drive IDs to burn-in
#   [2 - zero_drives] The switch to zero the drives after testing has completed
#   [3 - session_suffix] The suffix to add to the session name
#   [4 - end_on_detach] The switch to end the process when the TMUX session is 
#                       detached
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
burnin_drives ()
{
  declare -r drives_override=${1-null}
  declare -r zero_drives=${2-false}
  declare -r session_suffix=${3-null}
  declare -r end_on_detach=${4-false}

  declare -r AUTOMATED_SKIP="auto_skip"

  # Start a new TMUX session and attach to it
  TMUX_SESSION_NAME="drive_burnin"

  if [ "${session_suffix}" != null ]
  then
      TMUX_SESSION_NAME="${TMUX_SESSION_NAME}_${session_suffix}"
  fi

  echo "TMUX Session Name: ${TMUX_SESSION_NAME}"

  start_tmux_session \
    ${TMUX_SESSION_NAME}

  $(send_tmux_pane_command \
    0 \
    "clear" \
  )

  $(send_tmux_pane_command \
    0 \
    "echo Beginning process to burn-in drives..." \
  )

  if [ "${drives_override}" = null ]
  then
      # List all SMART drives using the standard SMART controller
      drives=$(list_drives \
        false \
        false \
      )
      echo "All Drives Found In System: [${drives}]"
  else
      drives=${drives_override}
      echo "Drives List Passed In: [${drives}]"
  fi

  # Set a space as the delimiter
  IFS=' '

  # Read the split words into an array based on space delimiter
  read -a available_drives <<< "${drives}"

  # Print the drives being burned in
  echo "Available Drives To Burn-In: [${available_drives[@]}]"

  CONTINUE=false
  read -p "Would you like to continue (y/n)?" choice
  case "$choice" in 
    y|Y ) CONTINUE=true;;
    n|N ) CONTINUE=false;;
    * ) echo "Invalid Entry";;
  esac

  filtered_drives_to_burnin=()
  if [ "${CONTINUE}" = false ]
  then
    # Loop over each selected drive and filter out specifc drives
    drives_to_burnin=()
    for drive in "${available_drives[@]}"
    do
      SELECTED=false
      read -p "Would you like to burn-in drive: ${drive} (y/n)?" choice
      case "$choice" in 
        y|Y ) SELECTED=true;;
        n|N ) SELECTED=false;;
        * ) echo "Invalid Entry";;
      esac

      if [ "${SELECTED}" = true ]
      then
        drives_to_burnin+=(${drive})
      fi
      unset SELECTED
    done

    # Print the drives being burned in
    echo "Selected Drives To Burn-In: [${drives_to_burnin[@]}]"

    CONTINUE=false
    read -p "Would you like to continue (y/n)?" choice
    case "$choice" in 
      y|Y ) CONTINUE=true;;
      n|N ) CONTINUE=false;;
      * ) echo "Invalid Entry";;
    esac

    if [ "${CONTINUE}" = true ]
    then
      filtered_drives_to_burnin=("${drives_to_burnin[@]}")
    fi
  else
    filtered_drives_to_burnin=("${available_drives[@]}")
  fi

  if [ "${CONTINUE}" = true ]
  then
      # Print the filtered drives being burned in
      echo "Burn-In Drives: [${filtered_drives_to_burnin[@]}]"

      declare -r BURNIN_SCRIPT="./Utility-Scripts/burnin/burnin_drive.sh"

      # Loop over each selected drive to prepare the TMUX session
      for drive in "${filtered_drives_to_burnin[@]}"
      do
        echo "Splitting the TMUX Window for drive: ${drive}"

        # Split the TMUX window
        $(send_tmux_pane_command \
          0 \
          "bash ./Utility-Scripts/tmux/split_window_horizontal.sh" \
        )

        # Sleep
        sleep 0.1

        # Tile the TMUX window panes
        $(send_tmux_pane_command \
          0 \
          "bash ./Utility-Scripts/tmux/set_layout_tiled.sh" \
        )

        # Sleep
        sleep 0.1
      done

      # Select the first pane as the command pane
      $(send_tmux_pane_command \
        0 \
        "bash ./Utility-Scripts/tmux/select_session_pane.sh 0" \
      )

      # Loop over each selected drive and begin the burn-in process
      PANE_ITER=1
      for drive in "${filtered_drives_to_burnin[@]}"
      do
        echo "Preparing to Burn-In drive: ${drive}"

        # Log the drive activity
        $(send_tmux_pane_command \
          ${PANE_ITER} \
          "echo Burning in drive: ${drive}" \
        )

        # Sleep
        sleep 0.1

        # Burn-In the drive!
        $(send_tmux_pane_command \
          ${PANE_ITER} \
          "bash ${BURNIN_SCRIPT} ${AUTOMATED_SKIP} ${drive} ${zero_drives}" \
        )

        PANE_ITER=$((PANE_ITER+1))
      done

      # Attach to the TMUX session
      attach_tmux_session \
        ${TMUX_SESSION_NAME}

      # End the TMUX session after the user has detached
      if [ "${end_on_detach}" = true ]
      then
          end_tmux_session \
            ${TMUX_SESSION_NAME}
      fi
  else
      end_tmux_session \
        ${TMUX_SESSION_NAME}
  fi
  unset CONTINUE
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
!!       BY PROCEEDING, ALL DATA ON DISKS WILL BE DESTROYED        !!
!!       STOP AND DO NOT RUN IF DISKS CONTAIN VALUABLE DATA        !!
!!                                                                 !!
!!  DEPENDING ON DISK SIZES, THE RUNTIME CAN EXCEED SEVERAL DAYS   !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EOF

  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    burnin_drives "${@}"
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
        burnin_drives "${@}"
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