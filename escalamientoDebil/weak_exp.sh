#!/bin/bash
#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=$1         #Nombre del ejecutable a utilizar
ORDER=$2          #Parámetro de orden
MAX_THREADS=$3    #Número máximo de threads a utilizar
MAX_REPS=$4       #Número de repeticiones para cada ejecución
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 $MAX_REPS)

output_file="resultados/output_${TARGET}_order_${ORDER}.txt"
time_file="resultados/time_${TARGET}_order_${ORDER}.csv"

#Bucle para elimiar los archivos de tiempo y de salida, si ya existen.
if [ -f "$time_file" ]; then
    rm "$time_file" "$output_file"
    echo "$time_file y $output_file eliminados."
fi

echo -e "Escalamiento Debil del ejemplo: ${TARGET}. Hasta $MAX_THREADS thread(s). $MAX_REPS repeticiones. Orden $ORDER\n" #Se imprime información de interés al inicio del escalamiento.
# Bucle para ejecutar el comando con diferentes números de threads
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    echo -e "Iteración con $thread thread(s):" >> resultados/output_${TARGET}_order_${ORDER}.txt
    echo -n "Thread_$thread," >> resultados/time_${TARGET}_order_${ORDER}.csv
    
    # Bucle para repetir la ejecución con el mismo número de threads
    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
    # Ejecutar el comando con mpirun y guardar unicamente el tiempo de ejecución para todas las iteraciones menos la última    
    if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
	resultado=$(mpirun -np $thread --oversubscribe ../cpp_y_ejecutables/${TARGET} -o $ORDER 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y la última línea del stderr a la variable
	echo -n "$resultado," >> resultados/time_${TARGET}_order_${ORDER}.csv
    else
        # Para la última repetición, guardar parte de la salida estándar para verificar que la simulación esta arrojando el resultado esperado
        resultado=$(mpirun -np $thread --oversubscribe ../cpp_y_ejecutables/${TARGET} -o $ORDER 2>&1 > temp_out.txt | tail -n 1) #Enviar stdout a temp_out.txt y la última línea del stderr a la variable
        echo "$resultado" >> resultados/time_${TARGET}_order_${ORDER}.csv
        # Agregar las últimas dos líneas de la salida estándar al archivo de verificación de resultados
        tail -n 2 temp_out.txt >> resultados/output_${TARGET}_order_${ORDER}.txt;
    fi

    done
    echo -e "-------------------------------------------------------------------------" >> resultados/output_${TARGET}_order_${ORDER}.txt
done

# Generar las gráficas de escalamiento débil
python3 plot.py resultados/time_${TARGET}_order_${ORDER}.csv

# Eliminar el archivo temporal
rm temp_out.txt;
