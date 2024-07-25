#!/bin/bash
module load gromacs2020-gpu
packmol < packmol.inp
gmx_mpi editconf -f peptide_POPG.pdb -o newbox.gro -center 4.12916525 4.12916525 4.5
gmx_mpi solvate -cp newbox.gro -cs spc216.gro -p topol.top -o solv.gro -box 8.2583305 8.2583305 12.5
gmx_mpi grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr
gmx_mpi genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -conc 0.15 -neutral << EOF
15
EOF

gmx_mpi grompp -f minim.mdp -c solv_ions.gro  -p topol.top -o em.tpr
gmx_mpi mdrun -v -deffnm em -ntomp 10
gmx_mpi make_ndx -f em.gro -o index.ndx << EOF
1 | 20
q
EOF
gmx_mpi grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr -n index.ndx
gmx_mpi mdrun -v -deffnm nvt -ntomp 5 -nb gpu -gpu_id 1
gmx_mpi grompp -f npt.mdp -c nvt.gro  -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr -n index.ndx
gmx_mpi mdrun -v -deffnm npt -ntomp 5 -nb gpu -gpu_id 1
#gmx_mpi grompp -f prd.mdp -c npt.gro -r npt.gro -t npt.cpt -p topol.top -o prd1.tpr
#gmx_mpi mdrun -v -deffnm prd1 -ntomp 5 -nb gpu -gpu_id 1

##Analysis
#gmx_mpi make_ndx -f em.gro -o index.ndx
#gmx_mpi trjconv -f prd1.xtc -s prd1.tpr -fit rot+trans -o viz1.xtc -conect 
#pbc wrap -centersel "protein" -center com -compound residue -all
##or
#gmx_mpi  trjconv -s prd1.tpr -f prd1.xtc -o prd1_noPBC.xtc -pbc mol -ur compact
#RMSD
#gmx_mpi rms -s prd.tpr -f viz.xtc -o rmsd.xvg -tu ns
#RMSF
#gmx_mpi rmsf -f viz.xtc -s prd.tpr -o rmsf.xvg -res
#ROG
#gmx_mpi gyrate -s prd1.tpr -f viz.xtc -o gyrate.xvg
#Hbonds
#gmx_mpi hbond -f viz.xtc -s prd1.tpr -b 100 -tu ns -num hbonds.xvg
#SASS
#gmx_mpi sasa -f viz.xtc  -s prd1.tpr -b 800 -tu ns -o sasa.xvg
#DSSP
