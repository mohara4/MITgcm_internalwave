#!/bin/bash
#
#job name
#SBATCH --job-name=veri_glob_oce
#SBATCH --output=results_1
#SBATCH -N 1
#SBATCH --ntasks-per-node=5
#SBATCH --partition=dev
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=osu894@bangor.ac.uk

#normal batch commands
module load mpi/intel/2020/4

mpirun ./mitgcmuv > output.dat
