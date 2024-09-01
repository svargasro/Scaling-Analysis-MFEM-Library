#!/bin/bash

#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=$1
MAX_ORDER=$2
THREADS=$3
MAX_REPS=$4

ORDER=$(seq 1 $MAX_ORDER)
REPS=$(seq 1 $MAX_REPS)

timeOutput=resultados/time_${TARGET}_threads_${THREADS}_reps_${MAX_REPS}.csv

# Loop para ejecutar comandos
echo -e "Escalamiento Fuerte del ejemplo: ${TARGET}. $THREADS thread(s). $MAX_REPS repeticiones.\n"
# rm ./resultados/*.csv
# rm ./resultados/graficas/*
for orden in $ORDER; do
    echo -e "Ejecucion para el orden: $orden\n"
    echo -n "Orden_$orden," >> $timeOutput
    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
        if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
	        resultado=$(mpirun -np $THREADS --oversubscribe ./../cpp_y_ejecutables/${TARGET} -o $orden 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y el stderr a la variable
	        echo -n "$resultado," >> $timeOutput
        else
            resultado=$(mpirun -np $THREADS --oversubscribe ./../cpp_y_ejecutables/${TARGET} -o $orden 2>&1 >/dev/null | tail -n 2) #Similar al anterior pero se capturan las últimas dos líneas en vez de solo una, para capturar el tamaño.
            size=$(echo "$resultado" | awk 'NR==1') #Extrae la primera línea del resultado.
            time=$(echo "$resultado" | awk 'NR==2') #Extrae la segunda línea del resultado.
            echo -n "$time," >> $timeOutput
            echo "$size" >> $timeOutput
        fi
    done
done

python3 strongPlot.py $timeOutput