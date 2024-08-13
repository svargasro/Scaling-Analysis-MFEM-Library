#!/bin/bash

ORDER=$(seq 1 1)

REPS=$(seq 1 10)

rm ./output/*
for orden in $ORDER;
do
echo "$orden ----------------------------------------"
for rep in $REPS;
do
mpirun -np 2 ex1p -o $orden 2>>./output/output_$orden.txt
done
done


python3 plot.py
