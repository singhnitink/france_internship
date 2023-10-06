#module load gromacs2020-cpu
# martinize2 -v -f hiv_tat.pdb -x cg_hiv_tat.pdb -o top.top -ff martini3007 -ff-dir ../new_model/NitinDev0394/force_fields/ -map-dir ../new_model/NitinDev0394/mappings/  -maxwarn 1
gmx editconf -f $1 -center 3.5 3.5 3.5 -o system_boxed.gro
gmx solvate -cp system_boxed.gro -cs water.gro -radius 0.20 -box 7.0 7.0 7.0 -o solvated.gro -p topol.top
cp topol.top topol_temp.top
gmx grompp -f ions.mdp -c solvated.gro -p topol_temp.top -o solv_ions_temp.tpr
gmx genion -s solv_ions_temp.tpr -o solv_ions_temp.gro -p topol_temp.top -neutral
###This segment is to calculate the number of ions required for 0.15M
# Define the filename
filename="topol_temp.top"

# Use grep to extract the line containing "NA or CL" and store it in a variable ions
charge=$(grep "NA\|CL" "$filename")
net_charge=$(echo "$charge" | awk '{print $2}')

# Use grep to extract the line containing "W" and store it in a variable
number=$(grep "^W\s" $filename | awk '{print $2}')

# Calculate ions using the formula
x=$(echo "scale=2; (0.15 * $number * 4) / 55.5" | bc)

x_rounded=$(printf "%.0f" "$x")




# Print the result
echo "Number: $number"
echo "x: $x_rounded"

# Check if "net_charge" is empty or not
if [ -z "$net_charge" ]; then
    echo "net_charge is 0"
	netcharge=0
	nn=$(echo "$x_rounded")
	np=$(echo "$x_rounded")
else
    echo "net_charge: $net_charge"
	
	if [ $(echo "$charge" | awk '{print $1}') == "CL" ]; then

	nn=$(($x_rounded + $net_charge))
	np=$(echo "$x_rounded")
    else
    np=$(($x_rounded + $net_charge))
    nn=$(echo "$x_rounded")
   fi
fi


echo "nn: $nn" 
echo "np: $np"

###END of ions calculation
###Remove the previous ionization line from the topol.top
#grep -v "NA\|CL" topol.top > temp.top
#mv temp.top topol.top

gmx grompp -f ions.mdp -c solvated.gro -p topol.top -o solv_ions.tpr
gmx genion -s solv_ions.tpr -o solv_ions.gro -p topol.top -nn $nn  -np $np




gmx grompp -p topol.top -c solv_ions.gro -f minimization.mdp -o minimization.tpr
gmx mdrun -deffnm minimization -v -tableb ../table_d0.xvg ../table_d1.xvg
gmx make_ndx -f minimization.gro -o index.ndx
#gmx grompp -p topol.top -c minimization.gro -f eq.mdp -o eq.tpr
#gmx mdrun -deffnm eq -tableb ../table_d0.xvg ../table_d1.xvg
