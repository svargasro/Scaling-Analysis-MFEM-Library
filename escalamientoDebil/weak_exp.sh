#!/bin/bash
#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=$1
ORDER=$2
MAX_THREADS=$3
MAX_REPS=$4
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 $MAX_REPS)

# Loop para ejecutar comandos
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    echo -e "Iteración con $thread thread(s):" >> resultados/output_${TARGET}_order_${ORDER}.txt
    echo -n "Thread_$thread," >> resultados/time_${TARGET}_order_${ORDER}.csv
    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
    if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
	resultado=$(mpirun -np $thread --oversubscribe ../cpp_y_ejecutables/${TARGET} -o $ORDER 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y la última línea del stderr a la variable
	echo -n "$resultado," >> resultados/time_${TARGET}_order_${ORDER}.csv
    else
        resultado=$(mpirun -np $thread --oversubscribe ../cpp_y_ejecutables/${TARGET} -o $ORDER 2>&1 > temp_out.txt | tail -n 1) #Enviar stdout a temp_out.txt y la última línea del stderr a la variable
        echo "$resultado" >> resultados/time_${TARGET}_order_${ORDER}.csv
        tail -n 2 temp_out.txt >> resultados/output_${TARGET}_order_${ORDER}.txt;
    fi

    done
    echo -e "-------------------------------------------------------------------------" >> resultados/output_${TARGET}_order_${ORDER}.txt
done

python3 plot.py resultados/time_${TARGET}_order_${ORDER}.csv

rm temp_out.txt;

#rm mesh* sol*
