#This is script for gnuplot#
#enter in gnuplot terminal, type gnuplot, press enter#
#load 'simple.gnu'#
set terminal pngcairo enhanced color font 'Helvetica,48' size 3600,3000
set output "fraction_all-sec_st.png"
set border linewidth 10
#First plot***************
set xlabel "Time(ns)" font 'Helvetica Bold ,56'
set ylabel "Fraction of residues in all-helix" font 'Helvetica Bold,56'
set title "Temperature 300K" font 'Helvetica Bold,56'
set xrange [0:1000]
set yrange [0:1]
##set tics scale 2.5
set ytics 0.1
set ytics font ',52'
set xtics font ',52' rotate 90
set xtics 25
#set xzeroaxis lt 1 dt 2 lw 1.5 lc rgb 'black'
set key box lw 5 width 1
set key right top
#set key at 52,0.95
set key font ',52'
pl 'AVERAGE_DATA.dat' u 2:7 title "Alpha-Helix" w l lw 8 lc rgb 'red'
