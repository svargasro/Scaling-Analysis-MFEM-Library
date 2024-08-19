#!/bin/bash

ORDER=2

rm results/times/*${ORDER}.txt


TARGET=volta
MAX_THREADS=16
THREADS=$(seq 1 $MAX_THREADS)
MAX_REPS=10
REPS=$(seq 1 $MAX_REPS)

MESH=../../data/ball-nurbs.mesh
PC='0.5 0.42 20 0.5 0.5 -12 0.5 0.545 15'  # Point charge params
DBCS='1 2 3 4'  # Dirichlet Boundary Condition Surfaces
DBCV='0 0 0 0'  # Dirichlet Boundary Condition Values
MAXIT=25

# Loop para ejecutar comandos
for thread in $THREADS; do
    echo -e "Ejecucion para el thread: $thread\n"
    for Nreps in $REPS; do
        echo -e "Repeticion: $Nreps\n"
        mpirun -np $thread --oversubscribe $TARGET -m $MESH -pc '0.5 0.42 20 0.5 0.5 -12 0.5 0.545 15' -dbcs '1 2 3 4' -dbcv '0 0 0 0' -no-vis --no-visit -maxit $MAXIT -o $ORDER 2>> time_${thread}_${ORDER}.txt
    done

    # Calcular el promedio
    average=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' time_${thread}_${ORDER}.txt)

    # Calcular la desviación estándar
    stdev=$(awk -v avg="$average" '{ sumsq += ($1 - avg)^2 } END { if (NR > 1) print sqrt(sumsq / (NR - 1)) }' time_${thread}_${ORDER}.txt)

    # Guardar el promedio y la desviación estándar en time.txt
    echo "$thread $average $stdev" >> time_order_${ORDER}.txt
done


T1=$(awk 'NR==1 {print $2}' time_order_${ORDER}.txt)
awk -v T1="$T1" '{ print $1, T1/$2, T1/$2/$1 }' time_order_${ORDER}.txt > metrics_order_${ORDER}.txt

cp metrics_order_${ORDER}.txt results/
cp time* results/times/

python results/plot.py results/metrics_order_${ORDER}.txt --order $ORDER

rm *.txt
