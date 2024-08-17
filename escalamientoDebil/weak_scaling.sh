
#!/bin/bash
#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=ex1p
MAX_THREADS=64
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 10)
ORDER=7


# Loop para ejecutar comandos
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    echo -e "Iteración con $thread thread(s):" >> output.txt

    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
    if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
        mpirun -np $thread --oversubscribe ./${TARGET} -o $ORDER > /dev/null 2>> time$thread.txt
    else
        mpirun -np $thread --oversubscribe ./${TARGET} -o $ORDER > temp_out.txt 2>> time$thread.txt;
        tail -n 2 temp_out.txt >> output.txt;
    fi

    done
    # Calcular el promedio
    average=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' time$thread.txt)

    # Calcular la desviación estándar
    stdev=$(awk -v avg="$average" '{ sumsq += ($1 - avg)^2 } END { if (NR > 1) print sqrt(sumsq / (NR - 1)) }' time$thread.txt)

    # Guardar el promedio y la desviación estándar en time.txt
    echo "$thread $average $stdev" >> time.txt

    echo -e "-------------------------------------------------------------------------" >> output.txt
done

T1=$(awk 'NR==1 {print $2}' time.txt)

awk '{print $1, '$T1'/$2, '$T1'/$2/$1}' time.txt > metrics.txt

python3 plot.py

rm temp_out.txt;

#for ((i=1; i<=$MAX_THREADS; i++)); do
#    rm time${i}.txt output${i}.txt
#done

#rm mesh* sol*
