#!/bin/bash

#SBATCH -A IHESD
#SBATCH -p short
#SBATCH -n 3
#SBATCH -N 1
#SBATCH -t 00:05:00
#SBATCH -J ex_hector
#SBATCH --output=/people/pres520/code/out_err/out_file_%A.out
#SBATCH --error=/people/pres520/code/out_err/error_file_%A.err

# README -----------------------------------------------------------------------
# Run the script to generate a parameter runlist, currently just on one node
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

# R script to run
SCRIPT="/people/pres520/code/run_hector.R"

# run script with the slurm array index as the only argument to the script
Rscript $SCRIPT $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_JOB_ID $SLURM_ARRAY_TASK_COUNT
