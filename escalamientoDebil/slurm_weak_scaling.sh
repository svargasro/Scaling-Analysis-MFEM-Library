#!/bin/bash
#SBATCH --job-name=multi_executables
#SBATCH --output=slurm_outputs/slurm_output_%A_%a.txt
#SBATCH --error=slurm_outputs/error/slurm_error_%A_%a.txt
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=AMDRyzen7PRO5750G # Aquí especificas la partición

# Limpia el archivo metrics.txt al comienzo
> metrics.txt

# Configura las variables
TARGET=ex39p
MAX_THREADS=$(nproc)
THREADS=$(seq 1 $MAX_THREADS)
MAX_REPS=10
REPS=$(seq 1 $MAX_REPS)
ORDER=1
# MESH=../data/star.mesh

# Loop para ejecutar comandos
for thread in $THREADS; do
    echo -e "Ejecución para el thread: $thread\n"
    for Nreps in $REPS; do
        echo -e "Repetición: $Nreps\n"
        /usr/bin/time -f "%S" mpirun -np $thread --oversubscribe ./$TARGET -o $ORDER 1>> std_out$thread 2>>time$thread.txt
    done

    # Calcular el promedio
    average=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' time$thread.txt)

    # Calcular la desviación estándar
    stdev=$(awk -v avg="$average" '{ sumsq += ($1 - avg)^2 } END { if (NR > 1) print sqrt(sumsq / (NR - 1)) }' time$thread.txt)

    # Guardar el promedio y la desviación estándar en time.txt
    echo "$thread $average $stdev" >> time.txt
done

T1=$(awk 'NR==1 {print $2}' time.txt)
DT1=$(awk 'NR==1 {print $3}' time.txt)
echo "T1: $T1, DT1: $DT1"

# Mostrar el contenido de time.txt
echo "Contenido de time.txt:"
cat time.txt

# Generar metrics.txt
echo "Generando metrics.txt"
awk -v T1="$T1" -v DT1="$DT1" '{
    t1 = $1;
    t2 = $2;
    dt2 = $3;
    Speedup = T1 / t2;
    uncertainty1 = Speedup * sqrt((DT1/T1)^2 + (dt2/t2)^2);
    Efficiency = Speedup / t1;
    uncertainty2 = Efficiency * sqrt((dt2/t2)^2 + (DT1/T1)^2);
    print $1, Speedup, uncertainty1, Efficiency, uncertainty2;
}' time.txt > metrics.txt

# Mostrar el contenido de metrics.txt
echo "Contenido de metrics.txt:"
cat metrics.txt

# Ejecutar script de Python para generar gráficas
python plot.py

# Limpiar archivos temporales
rm std_out* sol* mesh* time*

