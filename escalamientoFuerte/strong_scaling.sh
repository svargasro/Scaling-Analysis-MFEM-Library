#!/bin/bash



# for i in {1..3}
# do
# echo "$i ----------------------------------------"
# parallel "mpirun -np 1 ex1p -m ../data/star-surf.mesh -o {}" ::: 1 2 2>./output/output_${i}.txt
# done






for orden in {1..3}

do
echo "$orden ----------------------------------------"
parallel -N0 "mpirun -np 1 ../ex1p -m ../data/star-surf.mesh -o $orden" ::: {1..8} 2>./output/output_${orden}.txt
done



# parallel -N0 "echo funciona" ::: {1..3}









#parallel 'mpirun -np 1 ex1p -m ../data/star-surf.mesh -rl {} 2>./output/output_{}.txt' ::: 1000.0 10000.0
