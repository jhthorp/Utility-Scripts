#!/bin/bash
################################################################################
#                                  List Drives                                 #
#                                                                              #
#             This script will export a single function that will              #
#      use the SYS or SMART commands to list either all available drives       #
#                  or just those that are SMART-capable drives                 #
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
. "${stack_vars[${#stack_vars[@]}-1]}/list_all_drives.sh"
. "${stack_vars[${#stack_vars[@]}-1]}/list_smart_drives.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will use the SYS or SMART commands to list either all available 
# drives or just those that are SMART-capable drives.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - all_drives] The switch for all available drives or SMART-capable drives
#   [2 - use_sysctl] The switch for sysctl or smartctl
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
list_drives ()
{
  declare -r all_drives=${1:-false}
  declare -r use_sysctl=${2:-false}

  if [ "${all_drives}" = true ]
  then
    echo $(list_all_drives \
      ${use_sysctl} \
    )
  else
    echo $(list_smart_drives \
      ${use_sysctl} \
    )
  fi
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

  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    list_drives "${@}"
  else
    # Start the script
    list_drives "${@}"
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