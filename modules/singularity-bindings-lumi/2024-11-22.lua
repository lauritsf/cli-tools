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
