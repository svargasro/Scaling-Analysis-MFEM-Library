#!/bin/bash
#SBATCH --job-name=mfem_trabajo
#SBATCH --output=resultado_%j.out
#SBATCH --error=error_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8  # Ajusta según tus necesidades
#SBATCH --nodes=2
#SBATCH --time=01:00:00

# Cargar módulos necesarios
module load mfem

# Número de hilos a usar por núcleo
export OMP_NUM_THREADS=8  # Ajusta según el número de núcleos físicos

# Obtener los IDs de los núcleos físicos (ajustar según el sistema)
physical_cores=$(lscpu | grep 'Core(s) per socket:' | awk '{print $4}')
total_cores=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
sockets=$(lscpu | grep 'Socket(s):' | awk '{print $2}')

# Calcular núcleos físicos
physical_ids=$(seq -s, 0 $((physical_cores * sockets - 1)))

# Ejecutar el programa MFEM con afinidad de CPU a núcleos físicos
taskset -c $physical_ids ./NOMBRE_SCRIPT.sh 