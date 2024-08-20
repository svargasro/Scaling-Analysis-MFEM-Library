#!/bin/bash


archivo="./optimalNumberCores.txt" # Ruta al archivo
cores=$(<"$archivo" ) # Leer todo el contenido
echo "$cores" # Mostrar el contenido

ORDER=$(seq 1 2)
REPS=$(seq 1 2)

rm ./output/*
for orden in $ORDER;
do
echo "$orden ----------------------------------------"
for rep in $REPS;
do
mpirun -np $cores ex1p -o $orden 2>>./output/output_$orden.txt
done
done


python3 strongPlot.py
