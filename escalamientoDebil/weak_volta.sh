#!/bin/bash
#El comando !/bin/bash indica que el script se ejecutará en bash
#Esto es esencial para scripts que utilizan características
#específicas de Bash que no están disponibles en otros shells
#como sh (Shell estándar de UNIX).

TARGET=volta
ORDER=${1:-1} #${1:-default_value}
MAX_THREADS=${2:-16}
MAX_REPS=${3:-10}
THREADS=$(seq 1 $MAX_THREADS)
REPS=$(seq 1 $MAX_REPS)

PC='0.5 0.42 20 0.5 0.5 -12 0.5 0.545 15' # Point charge params
DBCS='1 2 3 4'                            # Dirichlet Boundary Condition Surfaces
DBCV='0 0 0 0'                            # Dirichlet Boundary Condition Values
MAXIT=25
#MESH="../data/ball-nurbs.mesh"
MESH="../data/inline-quad.mesh"

output_file="resultados/outputs/output_${TARGET}_order_${ORDER}.txt"
time_file="resultados/times/time_${TARGET}_order_${ORDER}.txt"
if [ -f "$time_file" ]; then
    rm "$time_file" "$output_file"
    echo "$time_file y $output_file eliminados."
fi

# Loop para ejecutar comandos
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    echo -e "\nIteración con $thread thread(s):" >>"$output_file"
    echo -n "Thread_$thread," >>"$time_file"
    for Nreps in $REPS; do

        echo -e "Repeticion: $Nreps\n"
        if [ "$Nreps" -ne "$(echo "$REPS" | tail -n 1)" ]; then
            resultado=$(mpirun -np $thread --oversubscribe ./ejecutables/${TARGET} -pc "${PC}" -dbcs "${DBCS}" -dbcv "${DBCV}" -no-vis --no-visit -maxit ${MAXIT} -o ${ORDER} -m ${MESH} 2>&1 >/dev/null | tail -n 1) #Enviar stdout a /dev/null y el stderr a la variable
            echo -n "$resultado," >>"$time_file"
        else
            resultado=$(mpirun -np $thread --oversubscribe ./ejecutables/${TARGET} -pc "${PC}" -dbcs "${DBCS}" -dbcv "${DBCV}" -no-vis --no-visit -maxit ${MAXIT} -o ${ORDER} -m ${MESH} 2>&1 >temp_out.txt | tail -n 1) #Enviar stdout a temp_out y el stderr a la variable
            echo "$resultado," >>"$time_file"
            awk '/Volume integral of charge density:/ {print "Volume integral of charge density: "$NF} /Surface integral of dielectric flux:/ {print "Surface integral of dielectric flux: "$NF}' temp_out.txt | tail -n 2 >> "$output_file"
        fi

        echo -n "" >>"$output_file"
    done
    echo -n "-------------------------------------------------------------------------" >>"$output_file"
done

python3 plot.py "$time_file"

rm temp_out.txt

#for ((i=1; i<=$MAX_THREADS; i++)); do
#    rm time${i}.txt output${i}.txt
#done

#rm mesh* sol*
