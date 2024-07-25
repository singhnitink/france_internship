#!/bin/bash

reps=(./K1L5/run1 ./K1L5/run2 ./K6L6/run1 ./K6L6/run2 ./K5L1/run1 ./K5L1/run2 ./K4L4/run1 ./K4L4/run2 ./K4L2/run1 ./K4L2/run2 ./K3L9/run1 ./K3L9/run2 ./K3L4/run1 ./K3L4/run2 ./K3L3/run1 ./K3L3/run2 ./K3L2/run1 ./K3L2/run2 ./K2L6/run1 ./K2L6/run2 ./K2L5/run1 ./K2L5/run2 ./K2L2/run1 ./K2L2/run2 ./K2L1/run1 ./K2L1/run2 ./K1L3/run1 ./K1L3/run2 ./K1L1/run1 ./K1L1/run2 )

BASEDIR=$(pwd)

cd $BASEDIR
for rep in ${reps[@]}
do
        cd $rep
        ### Index to clean this mess
        echo "13 | 1" > options
        echo "" >> options
        echo "quit" >> options
        gmx make_ndx -f p.tpr -o index.ndx < options
        ### trjconv this mess
        gmx trjconv -s p.tpr -f p.gro -o cleaner.gro -pbc mol -n index.ndx <<< "POPG_Protein"
        cd $BASEDIR
done

