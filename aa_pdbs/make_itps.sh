#!/bin/bash

module load gromacs2020-cpu
names=("K12L12" "K1L1" "K1L2" "K1L3" "K1L4" "K1L5" "K2L1" "K2L2" "K2L3" "K2L4" "K2L5" "K2L6" "K3L1" "K3L2" "K3L3" "K3L4" "K3L5" "K3L6" "K3L9" "K4L1" "K4L2" "K4L3" "K4L4" "K4L5" "K5L1" "K6L6")
for name in "${names[@]}"; do
gmx_mpi pdb2gmx -f ${name}.pdb -o ${name}_gro.pdb -water none -p topol.top << EOF
9
EOF
tail -n +23 topol.top > topol_temp.top
head -n -12 topol_temp.top > ${name}_topol.itp
rm *top
done
