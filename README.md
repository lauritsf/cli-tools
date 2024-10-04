# cli-tools

 A collection of handy command-line utilities for various tasks, including managing Slurm jobs and more. 

## Scripts

### scount

A simple Bash script to count Slurm jobs by user, status, or both.

#### Dependencies

* Slurm workload manager (`squeue` command)

### countfiles

A Bash script to count files in a specified directory and its subdirectories. This is particularly useful when you have a limit on the number of files allowed in your home directory, and you need to identify which directories contain the most files.

## Installation

1.  Clone the repository: `git clone https://github.com/lauritsf/cli-tools.git`
2.  Run `make install` to install the script to `$HOME/bin`.

Make sure `$HOME/bin` is in your `PATH`. You can usually do this by adding `export PATH="$HOME/bin:$PATH"` to your shell's configuration file (e.g., `~/.bashrc` or `~/.zshrc`).

## Slurm Utilities You Might Like

For more Slurm tools, including the excellent `pestat` script, check out [OleHolmNielsen/Slurm_tools](https://github.com/OleHolmNielsen/Slurm_tools). 

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
