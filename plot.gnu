set datafile separator ";"
set ylabel "KB / S"
set xlabel "Seconds"
set title "#TITLE#"

set y2label "% CPU" tc lt 1
#set y2range [0:110]



set style line 1 lt rgb 'red'
set style line 2 lt rgb 'green'
set style line 3 lt rgb 'blue'

set y2tics 50 nomirror tc lt 1
set ytics nomirror

set term png small size 800, 400
set output "#OUTPUT#.png"

plot 	"#INPUT#" using 1:3 with linespoints ti "READ IO" ls 2,\
		"#INPUT#" using 1:4 with linespoints ti "WRITE IO" ls 3 ,\
	 	"#INPUT#" using 1:2 with linespoints ti "CPU" ls 1 axes x1y2
