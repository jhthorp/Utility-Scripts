# Utility Scripts

The scripts within this project are for useful operations across all supported 
operating systems which include various utilities.

## Table of Contents

* [Warnings](#warnings)
* [Getting Started](#getting-started)
* [Prerequisites](#prerequisites)
* [Setup](#setup)
* [Scripts](#scripts)
	* [BadBlocks](#badblocks)
		* [run_badblocks.sh](#run_badblockssh)
		* [run_badblocks_operational.sh](#run_badblocks_operationalsh)
		* [run_badblocks_destructive.sh](#run_badblocks_destructivesh)
	* [CP](#cp)
		* [copy_all_files_to_dir.sh](#copy_all_files_to_dirsh)
	* [Imaging](#imaging)
		* [run_imaging.sh](#run_imagingsh)
		* [run_imaging_read_write.sh](#run_imaging_read_writesh)
		* [run_imaging_read.sh](#run_imaging_readsh)
		* [run_imaging_write.sh](#run_imaging_writesh)
	* [Processing](#processing)
		* [parallel_commands.sh](#parallel_commandssh)
	* [SCP](#scp)
		* [scp_from_remote.sh](#scp_from_remotesh)
		* [scp_to_remote.sh](#scp_to_remotesh)
	* [SMART](#smart)
		* [read_smart_test_results.sh](#read_smart_test_resultssh)
		* [run_smart_test.sh](#run_smart_testsh)
		* [run_smart_test_with_polling.sh](#run_smart_test_with_pollingsh)
		* [run_smart_conveyance_test.sh](#run_smart_conveyance_testsh)
		* [run_smart_short_test.sh](#run_smart_short_testsh)
		* [run_smart_long_test.sh](#run_smart_long_testsh)
	* [SSH](#ssh)
		* [connect.sh](#connectsh)
		* [run_command.sh](#run_commandsh)
		* [run_script.sh](#run_scriptsh)
	* [Status](#status)
		* [list_drives.sh](#list_drivessh)
		* [list_all_drives.sh](#list_all_drivessh)
		* [list_all_drives_smartctl.sh](#list_all_drives_smartctlsh)
		* [list_all_drives_sysctl.sh](#list_all_drives_sysctlsh)
		* [list_smart_drives.sh](#list_smart_drivessh)
		* [list_smart_drives_smartctl.sh](#list_smart_drives_smartctlsh)
		* [list_smart_drives_sysctl.sh](#list_smart_drives_sysctlsh)
	* [TMUX](#tmux)
		* [start_tmux_session.sh](#start_tmux_sessionsh)
		* [end_tmux_session.sh](#end_tmux_sessionsh)
		* [attach_tmux_session.sh](#attach_tmux_sessionsh)
		* [detach_tmux_session.sh](#detach_tmux_sessionsh)
		* [select_session_pane.sh](#select_session_panesh)
		* [send_tmux_pane_command.sh](#send_tmux_pane_commandsh)
		* [send_tmux_shell_command.sh](#send_tmux_shell_commandsh)
		* [set_layout.sh](#set_layoutsh)
		* [set_layout_tiled.sh](#set_layout_tiledsh)
		* [split_window_horizontal.sh](#split_window_horizontalsh)
		* [split_window_vertical.sh](#split_window_verticalsh)
* [Deployment](#deployment)
* [Dependencies](#dependencies)
* [Notes](#notes)
* [Test Environments](#test-environments)
	* [Operating System Compatibility](#operating-system-compatibility)
	* [Hardware Compatibility](#hardware-compatibility)
* [Contributing](#contributing)
* [Support](#support)
* [Versioning](#versioning)
* [Authors](#authors)
* [Copyright](#copyright)
* [License](#license)
* [Acknowledgments](#acknowledgments)

## Warnings

| :warning: |                      :warning:                       | :warning: |
|   :---:   |                        :---:                         |   :---:   |
| :warning: |   **Executing Imaging scripts may destroy data!**    | :warning: |
| :warning: |                      :warning:                       | :warning: |

## Getting Started

These instructions will get you a copy of the project up and running on your 
local machine for development and testing purposes. See 
[deployment](#deployment) for notes on how to deploy the project on a live 
system.

### Prerequisites

This project does not contain any prerequisites at this time.

### Setup

This project does not contain any setup at this time.  All you need to do is 
place the scripts onto your system and execute the desired functionality.

## Scripts

### BadBlocks

#### run_badblocks.sh

A script to run a BadBlocks test in destructive or operational (Non-Destructive) 
mode.

_Usage_

```
[bash] ./run_badblocks.sh [auto_skip] <drive> [blocksize] [destructive]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|        Block Size         |                Block Size to use                 |
|        Destructive        |               Type of test to run                |

_Commonly Used Block Sizes_

|        Block Size         |                      Value                       |
|           :---:           |                      :---:                       |
|           512b            |                       512                        |
|            1K             |                       1024                       |
|            2K             |                       2048                       |
|            4K             |                       4096                       |
|            8K             |                       8192                       |
|            16K            |                      16384                       |
|            32K            |                      32768                       |
|            64K            |                      65536                       |
|           128K            |                      131072                      |
|           256K            |                      262144                      |
|           512K            |                      524288                      |
|            1M             |                     1048576                      |
|            2M             |                     2097152                      |
|            4M             |                     4194304                      |
|            8M             |                     8388608                      |
|            16M            |                     16777216                     |
|            32M            |                     33554432                     |
|            64M            |                     67108864                     |

_Examples_

* **./run_badblocks.sh** "/dev/da1"
* **./run_badblocks.sh** "/dev/da1" 4096
* **./run_badblocks.sh** "/dev/da1" 4096 true
* **./run_badblocks.sh** "auto_skip" "/dev/da1" 4096 true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_badblocks_operational.sh

A script to run a BadBlocks test in operational (Non-Destructive) mode.

_Usage_

```
[bash] ./run_badblocks_operational.sh [auto_skip] <drive> [blocksize]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|        Block Size         |                Block Size to use                 |

_Commonly Used Block Sizes_

|        Block Size         |                      Value                       |
|           :---:           |                      :---:                       |
|           512b            |                       512                        |
|            1K             |                       1024                       |
|            2K             |                       2048                       |
|            4K             |                       4096                       |
|            8K             |                       8192                       |
|            16K            |                      16384                       |
|            32K            |                      32768                       |
|            64K            |                      65536                       |
|           128K            |                      131072                      |
|           256K            |                      262144                      |
|           512K            |                      524288                      |
|            1M             |                     1048576                      |
|            2M             |                     2097152                      |
|            4M             |                     4194304                      |
|            8M             |                     8388608                      |
|            16M            |                     16777216                     |
|            32M            |                     33554432                     |
|            64M            |                     67108864                     |

_Examples_

* **./run_badblocks_operational.sh** "/dev/da1"
* **./run_badblocks_operational.sh** "/dev/da1" 4096
* **./run_badblocks_operational.sh** "auto_skip" "/dev/da1" 4096

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_badblocks_destructive.sh

A script to A script to run a BadBlocks test in destructive mode.

_Usage_

```
[bash] ./run_badblocks_destructive.sh [auto_skip] <drive> [blocksize]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|        Block Size         |                Block Size to use                 |

_Commonly Used Block Sizes_

|        Block Size         |                      Value                       |
|           :---:           |                      :---:                       |
|           512b            |                       512                        |
|            1K             |                       1024                       |
|            2K             |                       2048                       |
|            4K             |                       4096                       |
|            8K             |                       8192                       |
|            16K            |                      16384                       |
|            32K            |                      32768                       |
|            64K            |                      65536                       |
|           128K            |                      131072                      |
|           256K            |                      262144                      |
|           512K            |                      524288                      |
|            1M             |                     1048576                      |
|            2M             |                     2097152                      |
|            4M             |                     4194304                      |
|            8M             |                     8388608                      |
|            16M            |                     16777216                     |
|            32M            |                     33554432                     |
|            64M            |                     67108864                     |

_Examples_

* **./run_badblocks_destructive.sh** "/dev/da1"
* **./run_badblocks_destructive.sh** "/dev/da1" 4096
* **./run_badblocks_destructive.sh** "auto_skip" "/dev/da1" 4096

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

### CP

#### copy_all_files_to_dir.sh

A script to copy all files recursively into a single directory.

_Usage_

```
[bash] ./copy_all_files_to_dir.sh [auto_skip] <srcPath> <srcDir> <destDir> 
<filenameStructure> [keepStructure]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|        Source Path        |        Source directory path to work from        |
|     Source Directory      |   Source directory relative to the source path   |
|   Destination Directory   |Destination directory relative to the source path |
|    Filename Structure     |             REGEX for file matching              |
|      Keep Structure       |           Keep the directory structure           |

_Examples_

* **./copy_all_files_to_dir.sh** "./path/to/dir" ./Source" "./Destination" 
"*.txt"
* **./copy_all_files_to_dir.sh** "./path/to/dir" "./Source" "./Destination" 
"*.txt" false
* **./copy_all_files_to_dir.sh** "auto_skip" "./path/to/dir" "./Source" 
"./Destination" "*.txt" false

### Imaging

#### run_imaging.sh

A script to use the DD command to write data across every bit in a drive or read 
all data bits from a drive or read and write data across every bit in a drive in 
parallel.

_Usage_

```
[bash] ./run_imaging.sh [auto_skip] <drive> [blocksize] [type] [write_random_pattern]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|        Block Size         |                Block Size to use                 |
|           Type            |             The type of test to run              |
|   Write Random Pattern    |              Write a random pattern              |

_Commonly Used Block Sizes_

|        Block Size         |                      Value                       |
|           :---:           |                      :---:                       |
|           512b            |                       512                        |
|            1K             |                       1024                       |
|            2K             |                       2048                       |
|            4K             |                       4096                       |
|            8K             |                       8192                       |
|            16K            |                      16384                       |
|            32K            |                      32768                       |
|            64K            |                      65536                       |
|           128K            |                      131072                      |
|           256K            |                      262144                      |
|           512K            |                      524288                      |
|            1M             |                     1048576                      |
|            2M             |                     2097152                      |
|            4M             |                     4194304                      |
|            8M             |                     8388608                      |
|            16M            |                     16777216                     |
|            32M            |                     33554432                     |
|            64M            |                     67108864                     |

_Types_

|         Type         |                      Description                      |
|        :---:         |                         :---:                         |
|         read         |                Read all bits of drive                 |
|        write         |             Write over all bits of drive              |
|      read-write      |         Read and write over all bits of drive         |

_Examples_

* **./run_imaging.sh** "/dev/da4"
* **./run_imaging.sh** "/dev/da4" 1048576
* **./run_imaging.sh** "/dev/da4" 1048576 "read-write"
* **./run_imaging.sh** "/dev/da4" 1048576 "read-write" true
* **./run_imaging.sh** "auto_skip" "/dev/da4" 1048576 "read-write" true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_imaging_read_write.sh

A script to use the DD command to read and write data across every bit in a 
drive in parallel.

_Usage_

```
[bash] ./run_imaging_read_write.sh [auto_skip] <drive> [blocksize] [write_random_pattern]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|        Block Size         |                Block Size to use                 |
|   Write Random Pattern    |              Write a random pattern              |

_Commonly Used Block Sizes_

|        Block Size         |                      Value                       |
|           :---:           |                      :---:                       |
|           512b            |                       512                        |
|            1K             |                       1024                       |
|            2K             |                       2048                       |
|            4K             |                       4096                       |
|            8K             |                       8192                       |
|            16K            |                      16384                       |
|            32K            |                      32768                       |
|            64K            |                      65536                       |
|           128K            |                      131072                      |
|           256K            |                      262144                      |
|           512K            |                      524288                      |
|            1M             |                     1048576                      |
|            2M             |                     2097152                      |
|            4M             |                     4194304                      |
|            8M             |                     8388608                      |
|            16M            |                     16777216                     |
|            32M            |                     33554432                     |
|            64M            |                     67108864                     |

_Examples_

* **./run_imaging_read_write.sh** "/dev/da3"
* **./run_imaging_read_write.sh** "/dev/da3" 1048576
* **./run_imaging_read_write.sh** "/dev/da3" 1048576 true
* **./run_imaging_read_write.sh** "auto_skip" "/dev/da3" 1048576 true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_imaging_read.sh

A script to use the DD command to read all data bits from a drive.

_Usage_

```
[bash] ./run_imaging_read.sh [auto_skip] <drive> [blocksize]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|        Block Size         |                Block Size to use                 |

_Commonly Used Block Sizes_

|        Block Size         |                      Value                       |
|           :---:           |                      :---:                       |
|           512b            |                       512                        |
|            1K             |                       1024                       |
|            2K             |                       2048                       |
|            4K             |                       4096                       |
|            8K             |                       8192                       |
|            16K            |                      16384                       |
|            32K            |                      32768                       |
|            64K            |                      65536                       |
|           128K            |                      131072                      |
|           256K            |                      262144                      |
|           512K            |                      524288                      |
|            1M             |                     1048576                      |
|            2M             |                     2097152                      |
|            4M             |                     4194304                      |
|            8M             |                     8388608                      |
|            16M            |                     16777216                     |
|            32M            |                     33554432                     |
|            64M            |                     67108864                     |

_Examples_

* **./run_imaging_read.sh** "/dev/da1"
* **./run_imaging_read.sh** "/dev/da1" 1048576
* **./run_imaging_read.sh** "auto_skip" "/dev/da1" 1048576

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_imaging_write.sh

A script to use the DD command to write data across every bit in a drive.

_Usage_

```
[bash] ./run_imaging_write.sh [auto_skip] <drive> [blocksize] [random]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|        Block Size         |                Block Size to use                 |
|          Random           |              Write a random pattern              |

_Commonly Used Block Sizes_

|        Block Size         |                      Value                       |
|           :---:           |                      :---:                       |
|           512b            |                       512                        |
|            1K             |                       1024                       |
|            2K             |                       2048                       |
|            4K             |                       4096                       |
|            8K             |                       8192                       |
|            16K            |                      16384                       |
|            32K            |                      32768                       |
|            64K            |                      65536                       |
|           128K            |                      131072                      |
|           256K            |                      262144                      |
|           512K            |                      524288                      |
|            1M             |                     1048576                      |
|            2M             |                     2097152                      |
|            4M             |                     4194304                      |
|            8M             |                     8388608                      |
|            16M            |                     16777216                     |
|            32M            |                     33554432                     |
|            64M            |                     67108864                     |

_Examples_

* **./run_imaging_write.sh** "/dev/da0"
* **./run_imaging_write.sh** "/dev/da0" 1048576
* **./run_imaging_write.sh** "/dev/da0" 1048576 true
* **./run_imaging_write.sh** "auto_skip" "/dev/da0" 1048576 true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

### Processing

#### parallel_commands.sh

A script to execute any number of commands in parallel.

_Usage_

```
[bash] ./parallel_commands.sh [auto_skip] <cmds>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|      Commands Array       |                 Commands to run                  |

_Examples_

* **./parallel_commands.sh** "echo Hello World"
* **./parallel_commands.sh** "echo Hello" "echo World"
* **./parallel_commands.sh** "echo Hello World" "echo Hello" "echo World"
* **./parallel_commands.sh** "auto_skip" "echo Hello World" "echo Hello" 
"echo World"

### SCP

#### scp_from_remote.sh

A script to securely copy files from a remote server.

_Usage_

```
[bash] ./scp_from_remote.sh [auto_skip] <host> <port> <user> <remotePath> 
<localPath>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|           User            |               User to connect with               |
|        Remote Path        |        Remote directory path to copy from        |
|        Local Path         |         Local directory path to copy to          |

_Examples_

* **./scp_from_remote.sh** 192.168.1.1 22 "root" "~/" "~/Documents"
* **./scp_from_remote.sh** "auto_skip" 192.168.1.1 22 "root" "~/" "~/Documents"

#### scp_to_remote.sh

A script to securely copy files to a remote server.

_Usage_

```
[bash] ./scp_to_remote.sh [auto_skip] <host> <port> <user> <localPath> 
<remotePath>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|           User            |               User to connect with               |
|        Local Path         |        Local directory path to copy from         |
|        Remote Path        |         Remote directory path to copy to         |

_Examples_

* **./scp_to_remote.sh** 192.168.1.1 22 "root" "~/Documents" "~/"
* **./scp_to_remote.sh** "auto_skip" 192.168.1.1 22 "root" "~/Documents" "~/"

### SMART

#### read_smart_test_results.sh

A script to run a query for the SMART summary.

_Usage_

```
[bash] ./read_smart_test_results.sh [auto_skip] <drive>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |          Drive to read the results from          |

_Examples_

* **./read_smart_test_results.sh** "/dev/da0"
* **./read_smart_test_results.sh** "auto_skip" "/dev/da0"

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_smart_test.sh

A script to run a SMART conveyance, short or long test.

_Usage_

```
[bash] ./run_smart_test.sh [auto_skip] <drive> <type> [captive]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|           Type            |               Type of test to run                |
|          Captive          |           Run the test in CAPTIVE mode           |

_Types_

|         Type         |                      Description                      |
|        :---:         |                         :---:                         |
|      conveyance      |           Manufacturer-specific test steps            |
|        short         |          Verifies major components of drive           |
|         long         |   Complete surface scan to reveal problematic areas   |

_Examples_

* **./run_smart_test.sh** "/dev/da5" "long"
* **./run_smart_test.sh** "/dev/da5" "conveyance" true
* **./run_smart_test.sh** "auto_skip" "/dev/da5" "conveyance" true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_smart_test_with_polling.sh

A script to run a SMART conveyance, short or long test and continuusly poll for 
status.

_Usage_

```
[bash] ./run_smart_test_with_polling.sh [auto_skip] <drive> <type>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|           Type            |               Type of test to run                |

_Types_

|         Type         |                      Description                      |
|        :---:         |                         :---:                         |
|      conveyance      |           Manufacturer-specific test steps            |
|        short         |          Verifies major components of drive           |
|         long         |   Complete surface scan to reveal problematic areas   |

_Examples_

* **./run_smart_test_with_polling.sh** "/dev/da5" "long"
* **./run_smart_test_with_polling.sh** "/dev/da5" "conveyance"
* **./run_smart_test_with_polling.sh** "auto_skip" "/dev/da5" "conveyance"

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_smart_conveyance_test.sh

A script to run a SMART conveyance test.

_Usage_

```
[bash] ./run_smart_conveyance_test.sh [auto_skip] <drive> [captive]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|          Captive          |           Run the test in CAPTIVE mode           |

_Examples_

* **./run_smart_conveyance_test.sh** "/dev/da2"
* **./run_smart_conveyance_test.sh** "/dev/da2" true
* **./run_smart_conveyance_test.sh** "auto_skip" "/dev/da2" true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_smart_short_test.sh

A script to run a SMART short test.

_Usage_

```
[bash] ./run_smart_short_test.sh [auto_skip] <drive> [captive]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|          Captive          |           Run the test in CAPTIVE mode           |

_Examples_

* **./run_smart_short_test.sh** "/dev/da2"
* **./run_smart_short_test.sh** "/dev/da2" true
* **./run_smart_short_test.sh** "auto_skip" "/dev/da2" true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

#### run_smart_long_test.sh

A script to run a SMART long test.

_Usage_

```
[bash] ./run_smart_long_test.sh [auto_skip] <drive> [captive]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Drive           |                  Drive to test                   |
|          Captive          |           Run the test in CAPTIVE mode           |

_Examples_

* **./run_smart_long_test.sh** "/dev/da2"
* **./run_smart_long_test.sh** "/dev/da2" true
* **./run_smart_long_test.sh** "auto_skip" "/dev/da2" true

_Drives Tested_

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                   WD Red Plus (8TB)                   |
|  :white_check_mark:  |                   WD Red Plus (6TB)                   |
|  :white_check_mark:  |                     WD Red (6TB)                      |
|  :white_check_mark:  |                   WD Red Plus (3TB)                   |
|  :white_check_mark:  |                  Kingston 240GB A400                  |

### SSH

#### connect.sh

A script to connect to a server using an SSH connection.

_Usage_

```
[bash] ./connect.sh [auto_skip] <host> <port> <user>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|           User            |               User to connect with               |

_Examples_

* **./connect.sh** 192.168.1.1 22 "root"
* **./connect.sh** "auto_skip" 192.168.1.1 22 "root"

#### run_command.sh

A script to execute a command over an SSH connection.

_Usage_

```
[bash] ./run_command.sh [auto_skip] <host> <port> <user> <cmd>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|           User            |               User to connect with               |
|          Command          |                  Command to run                  |

_Examples_

* **./run_command.sh** 192.168.1.1 22 "root" "pwd"
* **./run_command.sh** "auto_skip" 192.168.1.1 22 "root" "pwd"

#### run_script.sh

A script to execute a script over an SSH connection.

_Usage_

```
[bash] ./run_script.sh [auto_skip] <host> <port> <user> <script> <params>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Host            |            Host address to connect to            |
|           Port            |                Port to connect on                |
|           User            |               User to connect with               |
|          Script           |                  Script to run                   |
|          Params           |         Script parameters to pass along          |

_Examples_

* **./run_script.sh** 192.168.1.1 22 "root" 
"./Utility-Scripts/tmux/start_tmux_session" "session-name"
* **./run_script.sh** "auto_skip" 192.168.1.1 22 "root" 
"./Utility-Scripts/tmux/start_tmux_session" "session-name"

### Status

#### list_drives.sh

A script to use the SYS or SMART commands to list either all available drives
or just those that are SMART-capable drives.

_Usage_

```
[bash] ./list_drives.sh [auto_skip] [all_drives] [use_sysctl]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|        All Drives         |List all available drives or SMART-capable drives |
|        Use Sysctl         |          Use Sysctl instead of Smartctl          |

_Examples_

* **./list_drives.sh**
* **./list_drives.sh** true
* **./list_drives.sh** true true
* **./list_drives.sh** "auto_skip" true true

#### list_all_drives.sh

A script to use the SYS or SMART commands to list all available drives.

_Usage_

```
[bash] ./list_all_drives.sh [auto_skip] [use_sysctl]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|        Use Sysctl         |          Use Sysctl instead of Smartctl          |

_Examples_

* **./list_all_drives.sh**
* **./list_all_drives.sh** true
* **./list_all_drives.sh** "auto_skip" true

#### list_all_drives_smartctl.sh

A script to use the SMART commands to list all available drives.

_Usage_

```
[bash] ./list_all_drives_smartctl.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./list_all_drives_smartctl.sh**
* **./list_all_drives_smartctl.sh** "auto_skip"

#### list_all_drives_sysctl.sh

A script to use the SYS CONTROL commands to list all available drives.

_Usage_

```
[bash] ./list_all_drives_sysctl.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./list_all_drives_sysctl.sh**
* **./list_all_drives_sysctl.sh** "auto_skip"

#### list_smart_drives.sh

A script to use the SYS or SMART commands to list available SMART-capable 
drives.

_Usage_

```
[bash] ./list_smart_drives.sh [auto_skip] <use_sysctl>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|        Use Sysctl         |          Use Sysctl instead of Smartctl          |

_Examples_

* **./list_smart_drives.sh**
* **./list_smart_drives.sh** true
* **./list_smart_drives.sh** "auto_skip" true

#### list_smart_drives_smartctl.sh

A script to use the SMART commands to list available SMART-capable drives.

_Usage_

```
[bash] ./list_smart_drives_smartctl.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./list_smart_drives_smartctl.sh**
* **./list_smart_drives_smartctl.sh** "auto_skip"

#### list_smart_drives_sysctl.sh

A script to use the SYS CONTROL commands to list available SMART-capable drives.

_Usage_

```
[bash] ./list_smart_drives_sysctl.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./list_smart_drives_sysctl.sh**
* **./list_smart_drives_sysctl.sh** "auto_skip"

### TMUX

#### start_tmux_session.sh

A script to start a new TMUX session.

_Usage_

```
[bash] ./start_tmux_session.sh [auto_skip] <name>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Name            |                TMUX session name                 |

_Examples_

* **./start_tmux_session.sh** "Session Name"
* **./start_tmux_session.sh** "auto_skip" "Session Name"

#### end_tmux_session.sh

A script to end an existing TMUX session.

_Usage_

```
[bash] ./end_tmux_session.sh [auto_skip] <name>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Name            |                TMUX session name                 |

_Examples_

* **./end_tmux_session.sh** "Session Name"
* **./end_tmux_session.sh** "auto_skip" "Session Name"

#### attach_tmux_session.sh

A script to attach to an active TMUX session.

_Usage_

```
[bash] ./attach_tmux_session.sh [auto_skip] <name>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Name            |                TMUX session name                 |

_Examples_

* **./attach_tmux_session.sh** "Session Name"
* **./attach_tmux_session.sh** "auto_skip" "Session Name"

#### detach_tmux_session.sh

A script to detach from an active TMUX session.

_Usage_

```
[bash] ./detach_tmux_session.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./detach_tmux_session.sh**
* **./detach_tmux_session.sh** "auto_skip"

#### select_session_pane.sh

A script to select/activate a specific TMUX window pane.

_Usage_

```
[bash] ./select_session_pane.sh [auto_skip] <pane>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Pane            |                TMUX session pane                 |

_Examples_

* **./select_session_pane.sh** 1
* **./select_session_pane.sh** "auto_skip" 1

#### send_tmux_pane_command.sh

A script to send and execute a command in a specific TMUX window pane.

_Usage_

```
[bash] ./send_tmux_pane_command.sh [auto_skip] <pane> <cmd>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Pane            |                TMUX session pane                 |
|          Command          |     Command to run in the TMUX session pane      |

_Examples_

* **./send_tmux_pane_command.sh** 1 "pwd"
* **./send_tmux_pane_command.sh** "auto_skip" 1 "pwd"

#### send_tmux_shell_command.sh

A script to send and execute a shell command in a specific TMUX window.

_Usage_

```
[bash] ./send_tmux_shell_command.sh [auto_skip] <name> <cmd>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|           Name            |                TMUX session name                 |
|          Command          |        Command to run in the TMUX session        |

_Examples_

* **./send_tmux_shell_command.sh** "Session Name" "pwd"
* **./send_tmux_shell_command.sh** "auto_skip" "Session Name" "pwd"

#### set_layout.sh

A script to set a specific layout for an active TMUX window.

_Usage_

```
[bash] ./set_layout.sh [auto_skip] <layout>
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |
|          Layout           |                  Layout to set                   |

_Layouts_

|        Layout        |                      Description                      |
|        :---:         |                         :---:                         |
|   even-horizontal    |          Align all panes horizontally equal           |
|    even-vertical     |           Align all panes vertically equal            |
|   main-horizontal    | Align panes horizontally equal but first pane at 75%  |
|    main-vertical     |  Align panes vertically equal but first pane at 75%   |
|        tiled         |             Align panes in an equal grid              |

_Examples_

* **./set_layout.sh** tiled
* **./set_layout.sh** "auto_skip" tiled

#### set_layout_tiled.sh

A script to set a tiled layout for an active TMUX window.

_Usage_

```
[bash] ./set_layout_tiled.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./set_layout_tiled.sh**
* **./set_layout_tiled.sh** "auto_skip"

#### split_window_horizontal.sh

A script to split an active TMUX window horizontally.

_Usage_

```
[bash] ./split_window_horizontal.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./split_window_horizontal.sh**
* **./split_window_horizontal.sh** "auto_skip"

#### split_window_vertical.sh

A script to split an active TMUX window vertically.

_Usage_

```
[bash] ./split_window_vertical.sh [auto_skip]
```

_Options_

| Option Flag |                          Description                           |
|    :---:    |                             :---:                              |
|     N/A     |                              N/A                               |

_Parameters_

|         Parameter         |                   Description                    |
|           :---:           |                      :---:                       |
|      Automated Skip       |            Continue without prompting            |

_Examples_

* **./split_window_vertical.sh**
* **./split_window_vertical.sh** "auto_skip"

## Deployment

This section provides additional notes about how to deploy this on a live 
system.

## Dependencies

This project does not contain any dependencies at this time.

## Notes

This project does not contain any additional notes at this time.

## Test Environments

### Operating System Compatibility

|        Status        |                        System                         |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |                     MacOS 11.2.x                      |
|  :white_check_mark:  |                     MacOS 11.1.x                      |
|  :white_check_mark:  |                     MacOS 11.0.x                      |
|  :white_check_mark:  |                   TrueNAS 12.0-U2.1                   |
|  :white_check_mark:  |                    TrueNAS 12.0-U2                    |
|  :white_check_mark:  |                   TrueNAS 12.0-U1.1                   |
|  :white_check_mark:  |                    TrueNAS 12.0-U1                    |
|  :white_check_mark:  |                 TrueNAS 12.0-RELEASE                  |
| :information_source: |                TrueNAS < 12.0-RELEASE                 |
| :information_source: |            FreeNAS < TrueNAS 12.0-RELEASE             |

### Hardware Compatibility

|        Status        |                       Component                       |
|        :---:         |                         :---:                         |
|  :white_check_mark:  |              MacBook Pro (15-inch, 2018)              |

## Contributing

Please read [CODE_OF_CONDUCT](.github/CODE_OF_CONDUCT.md) for details on our 
Code of Conduct and [CONTRIBUTING](.github/CONTRIBUTING.md) for details on the 
process for submitting pull requests.

## Support

Please read [SUPPORT](.github/SUPPORT.md) for details on how to request 
support from the team.  For any security concerns, please read 
[SECURITY](.github/SECURITY.md) for our related process.

## Versioning

We use [Semantic Versioning](http://semver.org/) for versioning. For available 
releases, please see the 
[available tags](https://github.com/jhthorp/Utility-Scripts/tags) or look 
through our [Release Notes](.github/RELEASE_NOTES.md). For extensive 
documentation of changes between releases, please see the 
[Changelog](.github/CHANGELOG.md).

## Authors

* **Jack Thorp** - *Initial work* - [jhthorp](https://github.com/jhthorp)

See also the list of 
[contributors](https://github.com/jhthorp/Utility-Scripts/contributors) who 
participated in this project.

## Copyright

Copyright © 2020 - 2021, Jack Thorp and associated contributors.

## License

This project is licensed under the GNU General Public License - see the 
[LICENSE](LICENSE.md) for details.

## Acknowledgments

* N/A