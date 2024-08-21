#!/bin/bash
#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=volta
MAX_THREADS=16
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 10)
ORDER=${1:-1}
echo ${ORDER}


PC='0.5 0.42 20 0.5 0.5 -12 0.5 0.545 15'  # Point charge params
DBCS='1 2 3 4'  # Dirichlet Boundary Condition Surfaces
DBCV='0 0 0 0'  # Dirichlet Boundary Condition Values
MAXIT=25

output_file="resultados/output_${TARGET}_order_${ORDER}.txt"
time_file="resultados/time_${TARGET}_order_${ORDER}.txt"
if [ -f "$time_file" ]; then
    rm "$time_file" "$output_file"
    echo "$time_file y $output_file eliminados."
fi


# Loop para ejecutar comandos
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    echo -e "Iteración con $thread thread(s):" >> "$output_file"
    echo -n "Thread_$thread," >> "$time_file"
    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
    if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
	resultado=$(mpirun -np $thread --oversubscribe ./ejecutables/${TARGET} -pc "${PC}" -dbcs "${DBCS}" -dbcv "${DBCV}" -no-vis --no-visit -maxit ${MAXIT} -o ${ORDER} 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y el stderr a la variable
	echo -n "$resultado," >> "$time_file"
    else
        mpirun -np $thread --oversubscribe ./ejecutables/${TARGET} -pc "${PC}" -dbcs "${DBCS}" -dbcv "${DBCV}" -no-vis --no-visit -maxit ${MAXIT} -o ${ORDER} 2>> "$time_file";
        tail -n 2 temp_out.txt >> "$output_file";
    fi

    done
    echo -e "-------------------------------------------------------------------------" >> "$output_file"
done

python3 plot.py "$time_file"

rm temp_out.txt;

#for ((i=1; i<=$MAX_THREADS; i++)); do
#    rm time${i}.txt output${i}.txt
#done

#rm mesh* sol*
