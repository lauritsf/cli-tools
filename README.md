# cli-tools

 A collection of handy command-line utilities for various tasks, including managing Slurm jobs and more. 

## Scripts

### scount

A simple Bash script to count Slurm jobs by user, status, or both.

#### Dependencies

* Slurm workload manager (`squeue` command)

### countfiles

A Bash script to count files in a specified directory and its subdirectories. This is particularly useful when you have a limit on the number of files allowed in your home directory, and you need to identify which directories contain the most files.

## Modules

### singularity-bindings-lumi

This module sets up the environment for a frictionless experience with Singularity containers on LUMI. It simplifies the process of using Singularity by:

* Automatically binding essential LUMI directories (like `/pfs`, `/scratch`, `/projappl`) into your containers.
* Setting environment variables as shortcuts to commonly used container directories.

#### Usage

1. **Make the module available:**
   ```bash
   module use <path to modules directory>  # e.g., module use ~/repositories/cli-tools/modules
   ```
2. **Make the module available:**
   ```bash
   module load singularity-bindings-lumi
   ```

## Installation

1.  Clone the repository: `git clone https://github.com/lauritsf/cli-tools.git`
2.  Run `make install` to install the script to `$HOME/bin`.

Make sure `$HOME/bin` is in your `PATH`. You can usually do this by adding `export PATH="$HOME/bin:$PATH"` to your shell's configuration file (e.g., `~/.bashrc` or `~/.zshrc`).

## Slurm Utilities You Might Like

For more Slurm tools, including the excellent `pestat` script, check out [OleHolmNielsen/Slurm_tools](https://github.com/OleHolmNielsen/Slurm_tools). 

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
