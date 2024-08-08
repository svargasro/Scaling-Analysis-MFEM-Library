#!/bin/bash
#SBATCH --job-name=multi_executables
#SBATCH --output=slurm_output_%A_%a.txt
#SBATCH --error=slurm_error_%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8 # Ajusta este valor según la configuración de tu clúster
#SBATCH --mem=15G
#SBATCH --time=01:00:00
#SBATCH --array=0-39 # Ajusta esto al número total de ejecutables
#SBATCH --partition=AMDRyzen7PRO5750G # Aquí especificas la partición "Intel"


#Limpiar metrics
>metrics.txt

# Inicializar lista de ejecutables
executables=()

# Llenar lista de ejecutables recorriendo la carpeta examples
for exe in examples/*; do
  if [[ -x "$exe" ]]; then
    executables+=("$exe")
  fi
done

# Lista de ejecutables
#executables=(ex0p ex1p ex2p ex3p ex4p ex5p ex6p ex7p ex8p ex9p ex10p ex11p ex12p ex13p ex14p ex15p ex16p ex17p ex18p ex19p ex20p ex21p ex22p ex23p ex24p ex25p ex26p ex27p ex28p ex29p ex30p ex31p ex32p ex33p ex34p ex35p ex36p ex37p ex39p)

echo executables

# Seleccionar el ejecutable basado en el índice del array
executable=${executables[$SLURM_ARRAY_TASK_ID]}

# Limpiar archivos de salida al comienzo
rm -f stdout*
> time.txt
for thread in $(seq 1 $(nproc)); do
    > time$thread.txt
done

ORDER=1
MESH=../data/star.mesh
# MESH=../../../../data/

# Loop para ejecutar comandos
for thread in $(seq 1 $(nproc)); do
    echo -e "Ejecucion para el thread: $thread\n"
    for Nreps in $(seq 1 10); do
        echo -e "Repeticion: $Nreps\n"
        /usr/bin/time -f "%S" mpirun -np $thread --oversubscribe ./$executable -o $ORDER -m $MESH 1>>stdout$Nreps.txt 2>>time$thread.txt
    done
    # Calcular el promedio
    average=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' time$thread.txt)

    # Calcular la desviación estándar
    stdev=$(awk -v avg="$average" '{ sumsq += ($1 - avg)^2 } END { if (NR > 1) print sqrt(sumsq / (NR - 1)) }' time$thread.txt)

    # Guardar el promedio y la desviación estándar en time.txt
    echo "$thread $average $stdev" >> time.txt
done

# Asegurarse de que T1 está correctamente calculado
T1=$(awk 'NR==1 {print $2}' time.txt)
echo "T1: $T1"

# Verificar el contenido de time.txt
echo "Contenido de time.txt:"
cat time.txt

# Asegurarse de que metrics.txt se llena correctamente
echo "Generando metrics.txt"
awk '{print $1, $2/'$T1', $2/'$T1'/'$1'}' time.txt > metrics.txt

# Verificar el contenido de metrics.txt
echo "Contenido de metrics.txt:"
cat metrics.txt

# Ejecutar el script de Python para generar las gráficas
python plot.py

# Limpiar archivos de tiempo
for ((i=1; i<=$(nproc); i++)); do
    rm time${i}.txt
done

rm times* mesh* sol*
