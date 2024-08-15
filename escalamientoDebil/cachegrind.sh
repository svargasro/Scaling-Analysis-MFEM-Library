#!/bin/bash

# Compilación del programa
THREADS=1
FOLDER=valgrind_results/
#mpicxx  -O3 -std=c++11 -g -I.. -I../../hypre/src/hypre/include ex39p.cpp -o ex39pVal -L.. -lmfem -L../../hypre/src/hypre/lib -lHYPRE -L../../metis-4.0 -lmetis -lrt

# Ejecutar Valgrind en el programa MPI
mpirun -np $THREADS --oversubscribe valgrind --tool=cachegrind --log-file=cachegrind.out.%p ./ex39pVal
cg_annotate --auto=yes cachegrind.out.* > cachegrind-report.txt


# FOLDER=valgrind_results/
# #mpicxx  -O3 -std=c++11 -g -I.. -I../../hypre/src/hypre/include ex39p.cpp -o ex39pVal -L.. -lmfem -L../../hypre/src/hypre/lib -lHYPRE -L../../metis-4.0 -lmetis -lrt

# # Ejecutar Valgrind en el programa MPI
# mpirun -np $THREADS --oversubscribe valgrind --tool=cachegrind --log-file=${FOLDER}cachegrind.out.%p ./ex39pVal
# cg_annotate --auto=yes "${FOLDER}cachegrind.out.*" > "${FOLDER}"cachegrind-report.txt

rm sol* mesh*  
