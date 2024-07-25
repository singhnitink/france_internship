#This is script for gnuplot#
#enter in gnuplot terminal, type gnuplot, press enter#
#load 'simple.gnu'#
set terminal pngcairo enhanced color font 'Helvetica,48' size 3600,3000
set output "fraction_K2L4-helix_Membrane_AA.png"
set border linewidth 10
#First plot***************
set xlabel "Time(ns)" font 'Helvetica Bold ,56'
set ylabel "Fraction of residues in helix" font 'Helvetica Bold,56'
set title "K2L4 in Membrane All atom" font 'Helvetica Bold,56'
set xrange [0:10000]
set yrange [0:1]
##set tics scale 2.5
set ytics 0.1
set ytics font ',52'
set xtics font ',52' rotate 90
set xtics 500
#set xzeroaxis lt 1 dt 2 lw 1.5 lc rgb 'black'
set key box lw 5 width 1
set key right top
#set key at 195,0.05
set key font ',52'
pl 'helixaverage_1.dat' u 2:7 title "RUN1" w l lw 8 lc rgb 'red' \
, 'helixaverage_2.dat' u 2:7 title "RUN2" w l lw 8 lc rgb 'green' 
