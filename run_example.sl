#!/bin/bash

#SBATCH -A IHESD
#SBATCH -p short
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:05:00
#SBATCH -J ex_hector
#SBATCH --output=/people/pres520/code/example_%A_%a.out
#SBATCH --error=/people/pres520/code/example_%A_%a.err

# README -----------------------------------------------------------------------
# Run the example script for parallizing hector per scenario and via batch 
# This uses a SLURM array task per scenario to lauch jobs on four nodes.
#
# USAGE:
#
# sbatch --array=1-4 /people/pres520/code/run_example.sl
#
# ------------------------------------------------------------------------------

module purge
module load gcc/8.4.0
module load R/4.0.2

# change directories into the one containing the renv virtual environment that hector has been installed in
cd /people/pres520/code

# R script to run 
EXAMPLE_SCRIPT="/people/pres520/code/example.R"

# run script with the slurm array index as the only argument to the script 
Rscript $EXAMPLE_SCRIPT $SLURM_ARRAY_TASK_ID


