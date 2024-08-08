#!/bin/bash
#SBATCH --job-name=multi_executables
#SBATCH --output=slurm_outputs/slurm_output_%A_%a.txt
#SBATCH --error=slurm_outputs/slurm_error_%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8 # Ajusta este valor según la configuración de tu clúster
#SBATCH --array=0 # Ajusta esto al número total de ejecutables
#SBATCH --partition=AMDRyzen7PRO5750G # Aquí especificas la partición 


#Limpiar archivos previos
rm -f metrics* 
rm -r slurm_outputs/*


for thread in $(seq 1 $(nproc)); do
    rm -f time${thread}_*.txt
done

# Inicializar lista de ejecutables
executables=()

# Llenar lista de ejecutables recorriendo la carpeta examples
#for exe in examples/*; do
#  if [[ -x "$exe" ]]; then
#    executables+=("$exe")
#  fi
#done

executables="/examples/ex0p"

# Seleccionar el ejecutable basado en el índice del array
executable=${executables[$SLURM_ARRAY_TASK_ID]}
exec_name=$(basename $executable)

ORDER=1
MESH=../data/star.mesh
# MESH=../../../data/

# Loop para ejecutar comandos por cada thread y repetición
for thread in $(seq 1 $(nproc)); do
    echo -e "Ejecución para el thread: $thread\n"
    for Nreps in $(seq 1 10); do
        echo -e "Repetición: $Nreps\n"
        time_file="time_${exec_name}_${thread}_${Nreps}.txt"
        /usr/bin/time -f "%S" mpirun -np $thread --oversubscribe ./$executable -o $ORDER -m $MESH 1>>/dev/null 2>>$time_file
    done

    # Calcular el promedio
    average=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' time_${exec_name}_${thread}_*.txt)

    # Calcular la desviación estándar
    stdev=$(awk -v avg="$average" '{ sumsq += ($1 - avg)^2 } END { if (NR > 1) print sqrt(sumsq / (NR - 1)) }' time_${exec_name}_${thread}_*.txt)

    # Guardar el promedio y la desviación estándar en time.txt
    echo "$thread $average $stdev" >> time_${exec_name}.txt
done

# Asegurarse de que T1 está correctamente calculado
T1=$(awk 'NR==1 {print $2}' time_${exec_name}.txt)
echo "T1: $T1"

# Verificar el contenido de time.txt
echo "Contenido de time_${exec_name}.txt:"
cat time_${exec_name}.txt

# Asegurarse de que metrics.txt se llena correctamente
echo "Generando metrics_${exec_name}.txt"
awk '{ print $1, '$T1'/$2, '$T1'/$3, '$T1'/$2/$1, '$T1'/$3/$1}' time_${exec_name}.txt > metrics_${exec_name}.txt

# Verificar el contenido de metrics.txt
echo "Contenido de metrics_${exec_name}.txt:"
cat metrics_${exec_name}.txt

# Ejecutar el script de Python para generar las gráficas
python plot.py

# Limpiar archivos de tiempo
for ((i=1; i<=$(nproc); i++)); do
    rm time_${exec_name}_${i}_*.txt
done

# Lista de patrones de archivos a eliminar
patterns_to_delete=(
    "euler*"
    "ex16-init.*"
    "ex16-final.*"
    "ex16-mesh.*"
    "ex25p-sol_i.*"
    "ex25p-sol_r.*"
    "mesh.*"
    "metrics.txt"
    "mode_*"
    "port_mesh.*"
    "port_mode.*"
    "mode_deriv_*.00000*"
    "slurm_output_2004_*.txt"
    "slurm_output_2013_*.txt"
    "slurm_error_2004_*.txt"
    "slurm_error_2013_*.txt"
    "sol.*"
    "time*"
)

# Recorrer y eliminar archivos según los patrones
for pattern in "${patterns_to_delete[@]}"; do
    rm -f $pattern
done
# Limpiar archivos de salida al comienzo
rm -f stdout*
rm -f time.txt

echo "Archivos eliminados."

