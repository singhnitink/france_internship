#!/bin/bash
module load gromacs2020-cpu
for a in 1 2 3
do
cd ./run${a}
gmx_mpi trjconv -f production.xtc -s ../minimization.tpr -o viz.xtc -fit rot+trans -skip 10 << EOF
1
0
EOF

gmx_mpi trjconv -f production.xtc -s ../minimization.tpr -o ../without_water_${a}.xtc -fit rot+trans -skip 10 << EOF
1
1
EOF
cd ..
done