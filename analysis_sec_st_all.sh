# Create an array with the given values
#"K1L1" "K1L3" "K1L5" "K2L1" "K2L2" "K2L5" "K2L6" "K3L2" "K3L3" "K3L4" "K3L9" "K4L2" "K4L4" "K5L1" "K6L6"
names=("K1L1" "K1L3" "K1L5" "K2L1" "K2L2" "K2L5" "K2L6" "K3L2" "K3L3" "K3L4" "K3L9" "K4L2" "K4L4" "K5L1" "K6L6")
# Iterate through the array and echo each name
for name in "${names[@]}"; do
    echo "$name"
    cd ./${name}
    #cp -r ../sec_st .
    cd sec_st/

    rm *.png
    #vmd -dispdev text -e calc.tcl
    #cp ../../sec_st/single_valuex.py .
    #sed -i -e "s/XXXX/${name}/g" single_valuex.py
    #bash bash_average_sscache.sh

    cp ../../sec_st/simple.gnu .
    sed -i -e "s/XXXX/${name}/g" simple.gnu
    gnuplot simple.gnu

    cd each_residue/
    rm *.png
    cp ../../../sec_st/each_residue/helicity_eachresidue.py .
    sed -i -e "s/XXXX/${name}/g" helicity_eachresidue.py
    python3 helicity_eachresidue.py
    cp *.png ../../../results/.
    cd ../../../
done

echo "Done Perfectly"
