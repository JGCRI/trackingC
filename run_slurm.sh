#!/bin/bash

#SBATCH -A IHESD
#SBATCH -p short
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:05:00
#SBATCH -J ex_hector
#SBATCH --output=/people/pres520/code/out_err/out_file_%A.out
#SBATCH --error=/people/pres520/code/out_err/error_file_%A.err

# README -----------------------------------------------------------------------
# Run the example script for parallizing hector per scenario and via batch
# This uses a SLURM array task per scenario to lauch jobs on four nodes.
#
# USAGE:
#
# sbatch /people/pres520/code/run_slurm.sh
#
# ------------------------------------------------------------------------------

module purge
module load gcc/8.4.0
module load R/4.0.2

# change directories into the one containing the renv virtual environment that hector has been installed in
cd /people/pres520/code

# Set environment variable for number of nodes
export nodes=1

# Move all ./output files to ./old
# Will need to create these directories
mv output/* old

# R script to run
SCRIPT="/people/pres520/code/gen_runlist.R"

# run script with the slurm array index as the only argument to the script
Rscript $SCRIPT $SLURM_ARRAY_TASK_ID
