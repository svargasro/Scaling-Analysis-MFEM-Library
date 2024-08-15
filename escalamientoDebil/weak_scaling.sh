#!/bin/bash

TARGET=ex39p
MAX_THREADS=16
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 10)
ORDER=2
MESH=../data/compass.msh

for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    > memoria_thread${thread}.csv  # Inicializa el archivo de memoria para este thread
    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
        
        # Inicia el monitoreo de memoria
        ./monitor_memoria.sh $$ >> memoria_thread${thread}.csv &
        MONITOR_PID=$!
        
        # Ejecuta el programa
        /usr/bin/time -f "%S" mpirun -np $thread ./${TARGET} -o $ORDER -m $MESH 1>>stdout$Nreps.txt 2>>time$thread.txt
        
        # Detiene el monitoreo de memoria
        kill $MONITOR_PID
        wait $MONITOR_PID 2>/dev/null  # Espera a que termine el proceso de monitoreo
        
        sleep 1  # Pequeña pausa para asegurar que el monitoreo se ha detenido
    done
    
    # Calcula el promedio y la desviación estándar
    average=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' time$thread.txt)
    stdev=$(awk -v avg="$average" '{ sumsq += ($1 - avg)^2 } END { if (NR > 1) print sqrt(sumsq / (NR - 1)) }' time$thread.txt)
    
    # Guarda el promedio y la desviación estándar en time.txt
    echo "$thread $average $stdev" >> time.txt
done

# El resto de tu script (cálculos, generación de gráficos, limpieza)
T1=$(awk 'NR==1 {print $2}' time.txt)
awk '{print $1, '$T1'/$2, '$T1'/$2/$1}' time.txt > metrics.txt

python plot.py

# Limpieza
for ((i=1; i<=$MAX_THREADS; i++)); do
    rm time${i}.txt
done

rm mesh* sol* stdout*.txt

# No elimines los archivos de memoria, los necesitarás para graficar
# rm memoria_thread*.csv

