# cli-tools

 A collection of handy command-line utilities for various tasks, including managing Slurm jobs and more. 

## Scripts

### scount

A simple Bash script to count Slurm jobs by user, status, or both.

#### Dependencies

* Slurm workload manager (`squeue` command)

## Installation

1.  Clone the repository: `git clone https://github.com/lauritsf/cli-tools.git`
2.  Allow execution of the script: `chmod +x /path/to/cli-tools/<directory>/<script_name>`

You can now use the script directly from this location: `/path/to/cli-tools/<directory>/<script_name> [options]`

Alternatively, you can:

*   **Copy the script:** Copy `/path/to/cli-tools/<directory>/<script_name>` to a directory in your `PATH`, such as `$HOME/bin`.
*   **Create a symbolic link:**  `ln -s /path/to/cli-tools/<directory>/<script_name> $HOME/bin/<script_name>`


## Slurm Utilities You Might Like

For more Slurm tools, including the excellent `pestat` script, check out [OleHolmNielsen/Slurm_tools](https://github.com/OleHolmNielsen/Slurm_tools). 

## Licence
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
