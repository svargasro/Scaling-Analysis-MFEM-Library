#!/bin/bash
#SBATCH --job-name=volta
#SBATCH --output=resultados/weak_volta_%A_%a.out
#SBATCH --error=resultados/weak_volta_%A_%a.err
#SBATCH --partition=AMDRyzen7PRO5750G          # Asegúrate de especificar la partición correcta
#SBATCH --cpus-per-task=1               # Número de CPUs por tarea
#SBATCH --exclusive                     # Asegura que no compartas el nodo con otros trabajos
#SBATCH --array=1-4         

# Obtenemos el valor de ORDER a partir del índice del array
ORDER=$SLURM_ARRAY_TASK_ID
echo $ORDER

# Ejecutamos el script con el valor correspondiente de ORDER
./weak_volta.sh $ORDER

