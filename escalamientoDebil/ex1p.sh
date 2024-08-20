
#!/bin/bash
#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=ex1p
MAX_THREADS=16
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 10)
ORDER=1

# Loop para ejecutar comandos
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    echo -e "Iteración con $thread thread(s):" >> resultados/output.txt
    echo -n "Thread_$thread," >> resultados/time_${TARGET}_order_${ORDER}.txt
    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
    if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
	resultado=$(mpirun -np $thread --oversubscribe ./ejecutables/${TARGET} -o $ORDER 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y el stderr a la variable
	echo -n "$resultado," >> resultados/time_${TARGET}_order_${ORDER}.txt
    else
        mpirun -np $thread --oversubscribe ./ejecutables/${TARGET} -o $ORDER > temp_out.txt 2>> resultados/time_${TARGET}_order_${ORDER}.txt;
        tail -n 2 temp_out.txt >> resultados/output.txt;
    fi

    done
    echo -e "-------------------------------------------------------------------------" >> resultados/output.txt
done

python3 plot.py resultados/time_${TARGET}_order_${ORDER}.txt

rm temp_out.txt;

#for ((i=1; i<=$MAX_THREADS; i++)); do
#    rm time${i}.txt output${i}.txt
#done

#rm mesh* sol*
