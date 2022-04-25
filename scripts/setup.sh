#!/bin/bash

# README -----------------------------------------------------------------------
# Run the script to generate a parameter runlist, currently just on one node
#
# USAGE:
#
#
#
# ------------------------------------------------------------------------------

module purge
module load gcc/8.4.0
module load R/4.0.2

# change directories into the one containing the renv virtual environment that hector has been installed in
cd /people/pres520/code

# Move all ./output files to ./old
mv output/* old

# R script to run
SCRIPT="/people/pres520/code/gen_runlist.R"

# run script
Rscript $SCRIPT 
