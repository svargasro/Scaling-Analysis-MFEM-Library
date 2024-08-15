#!/bin/bash

# Compilación del programa
THREADS=4
#mpicxx  -O3 -std=c++11 -g -I.. -I../../hypre/src/hypre/include ex39p.cpp -o ex39pVal -L.. -lmfem -L../../hypre/src/hypre/lib -lHYPRE -L../../metis-4.0 -lmetis -lrt

# Ejecutar Valgrind en el programa MPI
mpirun -np $THREADS --oversubscribe valgrind --tool=memcheck --log-file=valgrind-out.%p ./ex39pVal

rm sol* mesh* 
