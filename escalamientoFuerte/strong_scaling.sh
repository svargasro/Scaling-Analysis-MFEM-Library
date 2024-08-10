#!/bin/bash



# for i in {1..3}
# do
# echo "$i ----------------------------------------"
# parallel "mpirun -np 1 ex1p -m ../data/star-surf.mesh -o {}" ::: 1 2 2>./output/output_${i}.txt
# done

# mpirun -np 1 ex39p -o 6 2>./output/output_6.txt


# ORDER=$(seq 1 30)

# REPS=$(seq 1 10)

ORDER=$(seq 6 6)

REPS=$(seq 1 4)

echo $REPS

for orden in $ORDER;
do
echo "$orden ----------------------------------------"
# parallel -N0 "stress -t 10 -c 1" ::: $REPS 
# parallel -N0 "mpirun -np 1 ex39p -o $orden" ::: $REPS 2>./output/output_${orden}.txt
seq 10 | parallel -j 10 "mpirun -np 1 ex39p -o $orden 2>>./output/output_$orden.txt"
done

# python3 plot.py

#rm ./output/output_*.txt

# parallel -N0 "echo funciona" ::: {1..3}









#parallel 'mpirun -np 1 ex1p -m ../data/star-surf.mesh -rl {} 2>./output/output_{}.txt' ::: 1000.0 10000.0
