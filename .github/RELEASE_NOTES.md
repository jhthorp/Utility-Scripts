# Release Notes

All major features and bug fixes to this project will be documented in this file 
for each release including any steps required during a version upgrade. For 
extensive documentation of changes between releases, please see the 
[Changelog](CHANGELOG.md).

This project adheres to 
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - YYYY-MM-DD

Initial release of the following scripts:

* BadBlocks
	* run_badblocks.sh - A script to run a BadBlocks test in destructive mode or 
	operational mode (Non-Destructive).
	* run_badblocks_destructive.sh - A script to run a BadBlocks test in 
	destructive mode.
	* run_badblocks_operational.sh - A script to run a BadBlocks test in 
	operational mode (Non-Destructive).
* Burnin
	* burnin_drives.sh - A script to begin a drive Burn-In for a collection of 
	drives.
	* burnin_drive.sh - A script to begin a drive Burn-In for a single drive.
* CP (Copy)
	* copy_all_files_to_dir.sh - A script to copy all files recursively into a 
	single directory.
* Erase
	* erase_drives.sh - A script to begin a drive erase for a collection of 
	drives.
	* erase_drive.sh - A script to begin a drive erase for a single drive.
* Imaging
	* run_imaging.sh - A script to use the DD command to write data across 
	every bit in a drive or use the DD command to read all data bits from a 
	drive or use the DD command to write data across every bit in a drive and 
	read all data bits from the same drive in parallel.
	* run_imaging_read.sh - A script to use the DD command to read all data bits 
	from a drive.
	* run_imaging_write.sh - A script to use the DD command to write data across 
	every bit in a drive.
	* run_imaging_read_write.sh - A script to use the DD command to write data 
	across every bit in a drive and read all data bits from the same drive in 
	parallel.
* Processing
	* parallel_commands.sh - A script to execute any number of commands in 
	parallel.
* SCP (Secure Copy)
	* scp_from_remote.sh - A script to securely copy files from a remote server.
	* scp_to_remote.sh - A script to securely copy files to a remote server.
* SMART
	* run_smart_test.sh - A script to run a SMART conveyance, short or long 
	test.
	* run_smart_test_with_polling.sh - A script to run a SMART conveyance, short 
	or long test and continuusly poll for status.
	* run_smart_conveyance_test.sh - A script to run a SMART conveyance test.
	* run_smart_short_test.sh - A script to run a SMART short test.
	* run_smart_long_test.sh - A script to run a SMART long test.
	* read_smart_test_results.sh - A script to run a query for the SMART 
	summary.
* SSH
	* connect.sh - A script to connect to a server using an SSH connection.
	* run_command.sh - A script to execute a command over an SSH connection.
	* run_script.sh - A script to execute a script over an SSH connection.
* Status
	* list_drives.sh - A script to use the SYS or SMART commands to list either 
	all available drives or just those that are SMART-capable drives.
	* list_smart_drives.sh - A script to use the SYS or SMART commands to list 
	available SMART-capable drives.
	* list_smart_drives_smartctl.sh - A script to use the SMART commands to list 
	available SMART-capable drives.
	* list_smart_drives_sysctl.sh - A script to use the SYS CONTROL commands to 
	list available SMART-capable drives.
	* list_all_drives.sh - A script to use the SYS or SMART commands to list all 
	available drives.
	* list_all_drives_smartctl.sh - A script to use the SMART commands to list 
	all available drives.
	* list_all_drives_sysctl.sh - A script to use the SYS CONTROL commands to 
	list all available drives.
* TMUX
	* start_tmux_session.sh - A script to start a new TMUX session.
	* end_tmux_session.sh - A script to end an existing TMUX session.
	* attach_tmux_session.sh - A script to attach to an active TMUX session.
	* detach_tmux_session.sh - A script to detach from an active TMUX session.
	* select_session_pane.sh - A script to select/activate a specific TMUX 
	window pane.
	* send_tmux_pane_command.sh - A script to send and execute a command in a 
	specific TMUX window pane.
	* send_tmux_shell_command.sh - A script to send and execute a shell command 
	in a specific TMUX window.
	* set_layout.sh - A script to set a specific layout for an active TMUX 
	window.
	* set_layout_tiled.sh - A script to set a tiled layout for an active TMUX 
	window.
	* split_window_horizontal.sh - A script to split an active TMUX window 
	horizontally.
	* split_window_vertical.sh - A script to split an active TMUX window 
	vertically.

[//]: # (Version Diffs)
[1.0.0]: https://github.com/jhthorp/Utility-Scripts/releases/tag/v1.0.0