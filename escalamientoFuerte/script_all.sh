#!/bin/bash
#SBATCH --job-name=mfem_trabajo
#SBATCH --output=resultado_%j.out
#SBATCH --error=error_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16  # Ajusta según tus necesidades
#SBATCH --nodes=1
#SBATCH --time=01:00:00

# Cargar módulos necesarios
module load mfem

# Número de hilos a usar por núcleo
export OMP_NUM_THREADS=16  # Ajusta según el número de núcleos físicos y lógicos

# Ejecutar el programa MFEM sin restricciones de afinidad de CPU
srun --mpi=pmi2 ./strong_scaling.sh 
