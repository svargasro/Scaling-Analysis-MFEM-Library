#!/bin/bash

#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

#Argumentos que se reciben por consola.
TARGET=$1 #Nombre del ejecutable.
MAX_ORDER=$2 #Máximo órden que se ejecuta (Inicia siempre en un 1)
THREADS=$3 #Número de threads con el que se ejecuta el programa.
MAX_REPS=$4 #Número de veces que se repite la ejecución del programa para cada orden.

ORDER=$(seq 1 $MAX_ORDER) #Se crea la secuencia de órdenes a ejecutar: (1,2,3,...,MAX_ORDER)
REPS=$(seq 1 $MAX_REPS) #Se crea la secuencia para las repeticiones.

#Dirección en donde se guardan los archivos de salida de la ejecución:
timeOutput=resultados/time_${TARGET}_threads_${THREADS}_reps_${MAX_REPS}.csv #El nombre del archivo será por ejemplo: time_ex1p_threads_4_reps_10.csv

#Bucle para elimiar el archivo de tiempo, si ya existe.
if [ -f "$timeOutput" ]; then
    rm "$timeOutput"
    echo "$timeOutput eliminado."
fi

echo -e "Escalamiento Fuerte del ejemplo: ${TARGET}. $THREADS thread(s). $MAX_REPS repeticiones.\n" #Se imprime información de interés al inicio del escalamiento.
# rm ./resultados/*.csv
# rm ./resultados/graficas/*
for orden in $ORDER; do #Se recorre cada órden.
    echo -e "Ejecucion para el orden: $orden\n" #Se imprime la información del orden para el usuario.
    echo -n "Orden_$orden," >> $timeOutput #Se envía el orden para el cual se está corriendo al archivo, de modo que sea más sencillo identificar la estructura.
    for Nreps in $REPS; do #Loop que maneja el número de veces que se ejecuta el programa para el orden dado.
        echo -e "Repeticion: $Nreps\n" #Se imprime información de la repetición en curso para el usuario.
        if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then #Condición para que se ejecute el bloque de comandos siempre que no se esté corriendo la última repetición.
	        resultado=$(mpirun -np $THREADS --oversubscribe ./../cpp_y_ejecutables/${TARGET} -o $orden 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y el stderr a la variable resultado.
	        echo -n "$resultado," >> $timeOutput #Se sobreescribe el archivo de resultado.
        else #En la última repetición.
            resultado=$(mpirun -np $THREADS --oversubscribe ./../cpp_y_ejecutables/${TARGET} -o $orden 2>&1 >/dev/null | tail -n 2) #Similar al anterior pero se capturan las últimas dos líneas en vez de solo una, para capturar el tamaño.
            size=$(echo "$resultado" | awk 'NR==1') #Extrae la primera línea del resultado (Tamaño).
            time=$(echo "$resultado" | awk 'NR==2') #Extrae la segunda línea del resultado (Tiempo).
	        echo -n "$time," >> $timeOutput #Se envía al archivo el tiempo.
            echo "$size" >> $timeOutput #Se envía al archivo el tamaño, sin "," para indiciar el final de la fila.
        fi
    done
done

python3 strongPlot.py $timeOutput #Se ejecuta el archivo .py que realiza las gráficas y se le da como argumento el archivo que se acaba de crear.

#rm mesh* sol*
