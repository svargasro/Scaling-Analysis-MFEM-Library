#!/bin/bash
#SBATCH --job-name=strong_scalling     # Job name
#SBATCH --output=./output/mpi_strong_scalling_%j.out        # Standard output  log
#SBATCH --error=./output/mpi_strong_scalling_%j.err        # Standard  error log
#SBATCH --ntasks=10                # Number of MPI tasks (processes)
#SBATCH --nodes=1                  # Number of nodes
#SBATCH --ntasks-per-node=10       # Adjust based on your cluster's configuration
#SBATCH --time=01:00:00            # Time limit hrs:min:sec
#SBATCH --mem-per-cpu=1419
#SBATCH --partition=Inteli512400   # Partition

# srun stress -t 10 -c 1

# REPS=$(seq 1 10)
# parallel -N0 "stress -t 10 -c 1" ::: $REPS

ORDER=$(seq 6 6)

REPS=$(seq 1 6)

echo $REPS

for orden in $ORDER;
do
echo "$orden ----------------------------------------"
# parallel -N0 "stress -t 10 -c 1" ::: $REPS 
# parallel -N0 "mpirun -np 1 ex39p -o $orden" ::: $REPS 2>./output/output_${orden}.txt
parallel --jobs 3 --cpu 1 ::: "mpirun -np 1 ex39p -o $orden" 2>./output/output_${orden}.txt
done
