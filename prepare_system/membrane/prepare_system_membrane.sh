module load gromacs2020-gpu
# martinize2 -v -f hiv_tat.pdb -x cg_hiv_tat.pdb -o top.top -ff martini3007 -ff-dir ../new_model/NitinDev0394/force_fields/ -map-dir ../new_model/NitinDev0394/mappings/  -maxwarn 1
python2 insane.py -f ../cg_K5L1_coil.pdb -x 7.5 -y 7.5 -z 2.4 -sol W -o peptide_water_memb.gro -l POPG -p topol.top -box 7.5,7.5,12 -dm 3.20

###This segment is to calculate the number of ions required for 0.15M
# Define the filename
filename1="topol.top"
filename2="insane_output.dat"

# Use grep to extract the line containing "NA or CL" and store it in a variable ions
charge=$(grep "Charge" "$filename2")
net_charge=$(echo "$charge" | awk '{print $2}')

# Use grep to extract the line containing "W" and store it in a variable
line=$(grep "W" "$filename1")

# Extract the number from the line using awk
number=$(echo "$line" | awk '{print $2}')

# Calculate ions using the formula
x=$(echo "scale=2; (0.15 * $number * 4) / 55.5" | bc)

x_rounded=$(printf "%.0f" "$x")

# Print the result
echo "Number: $number"
echo "x: $x_rounded"
echo "netcharge: $net_charge"

if awk -v net_charge="$net_charge" 'BEGIN { exit !(net_charge > 0) }'; then
    nn=$(echo "$x_rounded + $net_charge" | bc)
    np=$(echo "$x_rounded")
else
    net_charge=$(echo "$net_charge * -1" | bc)
    nn=$(echo "$x_rounded" )
    np=$(echo "$x_rounded + $net_charge" | bc)
fi
nn=$(printf "%.0f" "$nn")
np=$(printf "%.0f" "$np")
echo "nn: $nn"
echo "np: $np"

###END of ions calculation


gmx_mpi grompp -f ions.mdp -c peptide_water_memb.gro -p topol.top -o solv_ions.tpr
gmx_mpi genion -s solv_ions.tpr -o solv_ions.gro -p topol.top -nn $nn  -np $np

# gmx grompp -p topol.top -c solv_ions.gro -f minimization.mdp -o minimization.tpr
# gmx mdrun -deffnm minimization -v -tableb table_d0.xvg table_d1.xvg
gmx make_ndx -f minimization.gro -o index.ndx << EOF
1 | 13
14 | 15
q
EOF
# gmx grompp -p topol.top -c minimization.gro -f eq.mdp -o eq.tpr
# gmx mdrun -deffnm eq -tableb table_d0.xvg table_d1.xvg
