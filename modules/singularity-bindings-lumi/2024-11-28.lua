help([==[

Description
===========
This module sets up the environment for a frictionless experience with Singularity containers.
The module is based on the system-cpeGNU-23.09-noglibc.lua module and the default.lua module.

It also sets up environment variables as shortcuts to commonly used container directories.
]==])

whatis("Description: This module sets up the environment for a frictionless experience with Singularity containers.")

-- System files
-- source: /appl/local/training/modules/AI-20240529/singularity-bindings/system-cpeGNU-23.09-noglibc.lua
-- source: https://lumi-supercomputer.github.io/LUMI-EasyBuild-docs/p/PyTorch/
prepend_path("SINGULARITY_BIND", "/var/spool/slurmd", ",")
prepend_path("SINGULARITY_BIND", "/opt/cray/", ",")
prepend_path("SINGULARITY_BIND", "/usr/lib64/libcxi.so.1", ",")
prepend_path("SINGULARITY_BIND", "/usr/lib64/libjansson.so.4", ",")

-- Slurm files and directories
-- Added for enabling Slurm commands in Singularity containers (needed for submitit launcher)
-- Note: You might still need to add add user `slurm` or `slurmadmin` to the container
--       See https://info.gwdg.de/wiki/doku.php?id=wiki:hpc:usage_of_slurm_within_a_singularity_container
prepend_path("SINGULARITY_BIND", "/usr/bin/srun", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/sbatch", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/scancel", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/squeue", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/sinfo", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/scontrol", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/sacct", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/salloc", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/sreport", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/sstat", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/sacctmgr", ",")
prepend_path("SINGULARITY_BIND", "/usr/bin/sprio", ",")
prepend_path("SINGULARITY_BIND", "/usr/lib64/libslurm.so", ",")
prepend_path("SINGULARITY_BIND", "/usr/lib64/slurm/", ",")
prepend_path("SINGULARITY_BIND", "/etc/slurm/", ",")
prepend_path("SINGULARITY_BIND", "/var/run/munge", ",")
prepend_path("SINGULARITY_BIND", "/run/munge", ",")
prepend_path("SINGULARITY_BIND", "/usr/lib64/libmunge.so.2", ",")
prepend_path("SINGULARITY_BIND", "/usr/lib64/libmunge.so.2.0.0", ",")
prepend_path("SINGULARITY_BIND", "/usr/share/lua/5.3", ",")
prepend_path("SINGULARITY_BIND", "/usr/lib64/lua/5.3", ",")

-- User files
-- source: /appl/local/training/modules/AI-20240629/singularity-bindings/default.lua
prepend_path("SINGULARITY_BIND", "/pfs",",")
prepend_path("SINGULARITY_BIND", "/scratch",",")
prepend_path("SINGULARITY_BIND", "/projappl",",")
prepend_path("SINGULARITY_BIND", "/project",",")
prepend_path("SINGULARITY_BIND", "/flash",",")
prepend_path("SINGULARITY_BIND", "/appl",",")

-- Container directories
setenv("SIF_IMAGES", "/appl/local/containers/sif-images")
setenv("TESTED_CONTAINERS", "/appl/local/containers/tested-containers")

-- Unload function
function unload()
    unsetenv("SINGULARITY_BIND")
    unsetenv("SIF_IMAGES")
    unsetenv("TESTED_CONTAINERS")
end
