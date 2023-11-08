cpus=2


for a in run1
do
mkdir ${a}
cd ./${a}
cp ../*.itp .
#gmx_mpi grompp -p ../topol.top -c ../minimization.gro -f ../eq.mdp -o eq.tpr -n ../index.ndx -maxwarn 2
#gmx_mpi mdrun -deffnm eq -tableb ../../table_d0.xvg ../../table_d1.xvg -ntomp 1 -nb gpu -pme gpu -bonded gpu -gpu_id 0 -pin on -pinoffset $cpus -pinstride 1 -v

#gmx_mpi grompp -p ../topol.top -c eq.gro -f ../production.mdp -o production.tpr -n ../index.ndx -maxwarn 2
#gmx_mpi mdrun -deffnm production -tableb ../../table_d0.xvg ../../table_d1.xvg -ntomp 1 -nb gpu -pme gpu -bonded gpu -gpu_id 0 -pin on -pinoffset $cpus -pinstride 1

gmx_mpi mdrun -deffnm production -cpi production.cpt -append -tableb ../../table_d0.xvg ../../table_d1.xvg -ntomp 1 -nb gpu -pme gpu -bonded gpu -gpu_id 0 -pin on -pinoffset $cpus -pinstride 1 -v

cpus=$(($cpus + 2))
cd ../
done
