#!/bin/bash



# for i in {1..3}
# do
# echo "$i ----------------------------------------"
# parallel "mpirun -np 1 ../ex1p -m ../data/star-surf.mesh -o {}" ::: 1 2 2>./output/output_${i}.txt
# done


ORDER=$(seq 1 4)

REPS=$(seq 1 10)

for orden in $ORDER

do
echo "$orden ----------------------------------------"
parallel -N0 "mpirun -np 1 ../ex1p -m ../data/star.mesh -o $orden" ::: $REPS 2> output_${orden}.txt
done


python plot.py


#orm output_*.txt

# parallel -N0 "echo funciona" ::: {1..3}









#parallel 'mpirun -np 1 ex1p -m ../data/star-surf.mesh -rl {} 2>./output/output_{}.txt' ::: 1000.0 10000.0
