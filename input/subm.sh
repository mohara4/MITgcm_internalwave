#!/bin/bash
#
#job name
#SBATCH --job-name=n_r_chaxdim
#SBATCH --output=results_1
#SBATCH -N 1
#SBATCH --ntasks-per-node=10
#SBATCH --partition=compute
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=osu894@bangor.ac.uk

#normal batch commands
module load mpi/intel/2020/4

mpirun ./mitgcmuv > output.dat
