import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
plt.style.use('classic')
mpl.use('pdf')
mpl.rcParams['xtick.major.size'] = 8
mpl.rcParams['xtick.major.width'] = 2
mpl.rcParams['ytick.major.size'] = 8
mpl.rcParams['ytick.major.width'] = 2
mpl.rcParams['axes.linewidth']= 2
plt.rcParams["mathtext.fontset"] = "dejavuserif"
plt.figure(facecolor='white', figsize=(15,10))
files=["../sec_st_1.dat","../sec_st_2.dat","../sec_st_3.dat"]
file_counter=0
width=-0.30
for file in files:
    data=np.genfromtxt(file,dtype=None,encoding=None,delimiter='')
    data=np.char.array(data,unicode=True)
    lines=data.shape[0]
    nres=20 #number of residues in peptide chain
    X=[] #creating an empty list to store fraction helix values

    #generating an empty matrix to store values of helix as 1 else 0
    rows = lines
    cols = nres

    mat = [[0 for i in range(cols)] for i in range(rows)]
    ##
    a=0
    while a<lines:
        b=1
        while b<nres+1:
            #print(data[a,b])
            #25 => is number of residues+1
            #a is line b is column
            if data[a,b]=='H':
                mat[a][b-1]=1
            #else:
                #mat[a][b]=0
            b+=1
        #print("**Next-Line**")
        a+=1
    ##Part2
    c=5000 #*********************************change for equillibration time
    counter=lines-c
    d=0
    result1=[]
    while d<nres:
        c=5000
        helicity=0
        while c<lines:
            helicity=helicity+mat[c][d]
            #print(mat[c][d])
            c=c+1
        result1.append(helicity)
        #print("**Next-Line**")
        d+=1
    final_result = [z / counter for z in result1]
    ##Plotting
    colors=['r','g','b','cyan']
    marker=['o','s','p','v']
    Simulation_run=file_counter+1
    label="Run "+str(Simulation_run)
    plt.plot(np.arange(1,nres+1,1),final_result, linestyle='-', marker=marker[file_counter], color=colors[file_counter],label=label,linewidth=3,markersize=15)
    #plt.bar(np.arange(1,nres+1,1)+width,final_result, color=colors[file_counter],width = 0.33,label=label)
    file_counter+=1
    width=width+0.30
legend = plt.legend(numpoints = 1, loc='best',frameon=False, fontsize=24)
#legend.get_frame().set_facecolor('none')
plt.yticks(np.arange(0,1.1,.1),fontsize=18,weight='bold')
plt.xticks(np.arange(0,nres+1,1),fontsize=18,weight='bold')
plt.ylim(0.0,1.05)
plt.xlim(0.2,nres+0.5)
plt.ylabel("Average Helicity",fontsize=18,weight='bold')
plt.xlabel("Residue Number",fontsize=18,weight='bold')
plt.title(r'Lysine in Water (PME)',fontsize=24,weight='bold')
ax = plt.gca()
#x_minor_locator = plt.MultipleLocator(10)
y_minor_locator = plt.MultipleLocator(0.05)
#ax.xaxis.set_minor_locator(x_minor_locator)
ax.yaxis.set_minor_locator(y_minor_locator)
ax.tick_params(which='both', width=2)
ax.tick_params(which='major', length=10)
ax.tick_params(which='minor', length=5, color='black')
plotfile='lysine_solution-PME.png'
plt.savefig(plotfile, dpi=300, bbox_inches='tight')
#plt.show()
