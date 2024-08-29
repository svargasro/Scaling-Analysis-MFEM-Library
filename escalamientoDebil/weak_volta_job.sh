#!/bin/bash
#SBATCH --job-name=volta
#SBATCH --output=resultados/slurm/volta_%A_%a.out
#SBATCH --error=resultados/slurm/volta_%A_%a.err
#SBATCH --array=1-6
#SBATCH --nodelist=sala23
#SBATCH --exclusive
#SBATCH --partition=AMDRyzen7PRO5750G

# Obtenemos el valor de ORDER a partir del índice del array
ORDER=$SLURM_ARRAY_TASK_ID
echo $ORDER

# Ejecutamos el script con el valor correspondiente de ORDER
./weak_volta.sh $ORDER

