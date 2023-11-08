module load gromacs2020-gpu
#gmx_mpi grompp -p topol.top -c solv_ions.gro -f minimization.mdp -o minimization.tpr
#gmx_mpi mdrun -deffnm minimization -v -tableb ../table_d0.xvg ../table_d1.xvg -ntomp 2
#gmx make_ndx -f minimization.gro -o index.ndx


cpus=2


for a in run1 run2 run3
do
mkdir ${a}
cd ./${a}
cp ../*.itp .
gmx_mpi grompp -p ../topol.top -c ../minimization.gro -f ../eq.mdp -o eq.tpr
gmx_mpi mdrun -deffnm eq -tableb ../../table_d0.xvg ../../table_d1.xvg -ntomp 1 -nb gpu -pme gpu -bonded gpu -gpu_id 1 -pin on -pinoffset $cpus -pinstride 1 -v

gmx_mpi grompp -p ../topol.top -c eq.gro -f ../production.mdp -o production.tpr
gmx_mpi mdrun -deffnm production -tableb ../../table_d0.xvg ../../table_d1.xvg -ntomp 1 -nb gpu -pme gpu -bonded gpu -gpu_id 1 -pin on -pinoffset $cpus -pinstride 1

#gmx_mpi mdrun -deffnm production -cpi production.cpt -append -tableb ../../table_d0.xvg ../../table_d1.xvg -ntomp 1 -nb gpu -pme gpu -bonded gpu -gpu_id 0 -pin on -pinoffset $cpus -pinstride 1 -v

cpus=$(($cpus + 2))
cd ../
done

#gmx_mpi trjconv -s ../minimization.tpr -f production.xtc -o viz.xtc -fit rot+trans  -skip 10 << EOF
#1
#0
#EOF
#gmx_mpi trjconv -s ../minimization.tpr -f production.xtc -o ../without_water.xtc -fit rot+trans -skip 10 <<### EOF
#1
#1
#EOF
