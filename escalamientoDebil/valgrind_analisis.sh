THREADS=16

#mpig++ -g -o ex39pVal ex39p.cpp
#echo $TREADHS
mpirun -np $THREADS --oversubscribe valgrind --tool=memcheck --log-file=valgrind-out.%p ./ex39pVal

