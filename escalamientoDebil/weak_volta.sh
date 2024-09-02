#!/bin/bash
#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=volta #Nombre del ejecutable a utilizar
ORDER=${1:-1} #${1:-default_value} #Parámetro de orden
MAX_THREADS=${2:-16} #Número máximo de threads a utilizar
MAX_REPS=${3:-10} #Número de repeticiones para cada ejecución
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 $MAX_REPS)

PC='0.5 0.42 20 0.5 0.5 -12 0.5 0.545 15' # Point charge params
DBCS='1 2 3 4'                            # Dirichlet Boundary Condition Surfaces
DBCV='0 0 0 0'                            # Dirichlet Boundary Condition Values
MAXIT=25
#MESH="../data/ball-nurbs.mesh"
MESH="../data/inline-quad.mesh"

output_file="resultados/output_${TARGET}_order_${ORDER}.txt"
time_file="resultados/time_${TARGET}_order_${ORDER}.txt"

#Bucle para elimiar los archivos de tiempo y de salida, si ya existen.
if [ -f "$time_file" ]; then
    rm "$time_file" "$output_file"
    echo "$time_file y $output_file eliminados."
fi

# Bucle para ejecutar el comando con diferentes números de threads
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    echo -e "\nIteración con $thread thread(s):" >>"$output_file"
    echo -n "Thread_$thread," >>"$time_file"
    # Bucle para repetir la ejecución con el mismo número de threads
    for Nreps in $REPS; do

        echo -e "Repeticion: $Nreps\n"
        # Ejecutar el comando con mpirun y guardar unicamente el tiempo de ejecución para todas las iteraciones menos la última
        if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
            resultado=$(mpirun -np $thread --oversubscribe ../cpp_y_ejecutables/${TARGET} -pc "${PC}" -dbcs "${DBCS}" -dbcv "${DBCV}" -no-vis --no-visit -maxit ${MAXIT} -o ${ORDER} -m ${MESH} 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y el stderr a la variable
            echo -n "$resultado," >>"$time_file"
        else
            # Para la última repetición, guardar parte de la salida estándar para verificar que la simulación esta arrojando el resultado esperado
            resultado=$(mpirun -np $thread --oversubscribe ../cpp_y_ejecutables/${TARGET} -pc "${PC}" -dbcs "${DBCS}" -dbcv "${DBCV}" -no-vis --no-visit -maxit ${MAXIT} -o ${ORDER} -m ${MESH} 2>&1 >temp_out.txt | tail -n 1) #Enviar stdout a temp_out y el stderr a la variable
            echo "$resultado," >>"$time_file"

            awk '/Volume integral of charge density:/ {print "Volume integral of charge density: "$NF} /Surface integral of dielectric flux:/ {print "Surface integral of dielectric flux: "$NF}' temp_out.txt | tail -n 2 >> "$output_file" #Se extrae el resultado esperado de la simulación de las últimas dos filas.

        fi

        echo -n "" >>"$output_file"
    done
    echo -n "-------------------------------------------------------------------------" >>"$output_file"
done

# Generar las gráficas de escalamiento débil
python3 weakPlot.py "$time_file"
#Eliminar el archivo temporal
rm temp_out.txt
