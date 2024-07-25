# Different charge density patterns
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator
plt.style.use('classic')
#mpl.use('pdf')
mpl.rcParams['xtick.major.size'] = 8
mpl.rcParams['xtick.major.width'] = 2
mpl.rcParams['ytick.major.size'] = 8
mpl.rcParams['ytick.major.width'] = 2
mpl.rcParams['axes.linewidth']= 2

# Set the style and backend
plt.style.use('classic')
mpl.use('pdf')

# List of files to process
a = ["K1L1","K1L3","K1L5","K2L1","K2L2","K2L5","K2L6","K3L2","K3L3","K3L4","K3L9","K4L2","K4L4","K5L1","K6L6"]

# Open the output file
write_file = open('merged_sec_st-AllAtom.dat', 'w')

# Initialize lists to store average and std values
averagex = []
stdx = []

# Iterate through the list of files
for file in a:
    # Open each input file for reading
    with open(f"../{file}/sec_st/{file}_helix_average_std.dat", 'r') as data:
        # Read the content and write it to the output file
        content = data.read()
        write_file.write(content)

        # Split the content into values and append to the respective lists
        values = content.split()
        averagex.append(float(values[1]))  # Convert to float
        stdx.append(float(values[2]))     # Convert to float

# Close the output file
write_file.close()

# Create a plot
plt.figure(facecolor='white', figsize=(15,10))
plt.errorbar(a, averagex, yerr=stdx, fmt="o",color='red',markersize=12)
plt.xticks(a, a, rotation='vertical',fontsize=16,weight='bold')
plt.yticks(np.arange(0,1.1,0.1),fontsize=16,weight='bold')
plt.ylim(0,1.0)
plt.xlabel(r"Pattern $K_{x}L_{y}$",fontsize=18,weight='bold')
plt.ylabel(r"Fraction of residues in helix-All atom",fontsize=18,weight='bold')

plt.margins(0.05)

# Save the plot as an image file
plotfile = 'All_atom.png'
plt.savefig(plotfile, dpi=300, bbox_inches='tight')

# Uncomment the following line if you want to display the plot
# plt.show()
