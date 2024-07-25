set term pdf size 3in,3in font "Times New Roman,10"
set out "Weak Scaling.pdf"
set title "Weak Scaling"

set xlabel "nThreads"
set ylabel "SpeedUp"
set title "SpeedUp"

np= 4
set xrange [0:np];
set yrange [0:np];

plot x lc "black" notitle, \
	 "metrics.txt" using 1:2 pt 5 ps 0.5 dt 2 lc "green" title 'SpeedUp'

set xlabel "nThreads"
set ylabel "Eficiencia"
set title "Efficiency"

set xrange [0:np];
set yrange [0:1.01];

plot 1 lc "red" notitle, \
	 0.6 lc "blue" notitle, \
	 "metrics.txt" using 1:3 pt 5 ps 0.5 dt 2 lc "green" title 'Efficiency'

unset output