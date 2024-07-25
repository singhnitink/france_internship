import pandas as pd
import numpy as np
'''This file will be used to  calculate the secondary stucture content
... generated from the sscache script'''
data=np.genfromtxt('SEC_ST_FILE_SSCACHE.dat',dtype=None,encoding=None,delimiter='')
file1=open('PER_FRAME.dat','w') #contains helixaverage of 5ns 250 frames
data=np.char.array(data,unicode=True)
lines=data.shape[0]
nres=data.shape[1]-1 #number of residues in peptide chain
print(f'Number of residues is {nres}')
loop=nres+1
H=[] #creating an empty list to store fraction helix values
HGI=[]
E=[]
T=[]
C=[]
a=0
file1.write("#frame,all_helix/nres,alpha_helix/nres,beta_sheet/nres,turns/nres,coils/nres \n")
while a<lines:
    b=1
    all_helix=0
    alpha_helix=0
    beta_sheet=0
    coils=0
    turns=0
    while b<loop:
        #a is line b is colum
        xx=0
        if data[a,b]=='H' or data[a,b]=='G' or data[a,b]=='I':
            all_helix+=1
            if data[a,b]=='H':
                alpha_helix+=1
        elif data[a,b]=='E':
            beta_sheet+=1
        elif data[a,b]=='T':
            turns+=1
        elif data[a,b]=='C':
            coils+=1
        else:
            xx+=1
        b+=1
    #print(a,helix/nres)
    HGI.append(all_helix/nres)
    H.append(alpha_helix/nres)
    E.append(beta_sheet/nres)
    T.append(turns/nres)
    C.append(coils/nres)
    file1.write("%d\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n"%(a,all_helix/nres,alpha_helix/nres,beta_sheet/nres,turns/nres,coils/nres))
    a+=1
HGI.append(all_helix/nres)
H.append(alpha_helix/nres)
E.append(beta_sheet/nres)
T.append(turns/nres)
C.append(coils/nres)
file1.write("%d\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n"%(a,all_helix/nres,alpha_helix/nres,beta_sheet/nres,turns/nres,coils/nres))
file1.close()
#******* averaging the data stored in list X
t1=0 #start time
interval=100 #interval 100ns
##**Change the value of interval for changing the time period of mean##
file2=open('AVERAGE_DATA.dat','w') #contains helixaverage every 5ns ie. 250 frames
t2=t1+interval
m=0
mean_int=1*interval #divided by 1 because 1ns = 1 frame in viz.xtc
#100 is here for 1ns# use only when you are sving the dcd file every 50000 steps
n=mean_int
file2.write('#t1 t2 run av-allhelix  std-allhelix  median-allhelix\t')
file2.write('#av-alphahelix  std-alphahelix median-alphahelix\t')
file2.write('#av-beta-sheet std-beta-sheet median-beta-sheet\t')
file2.write('#av-turns std-turns median-turns\t')
file2.write('#av-coils std-coils median-coils\n')
while n<=len(H):
    #all-helix
    mean_allhelix=np.mean(HGI[m:n])
    std_allhelix=np.std(HGI[m:n])
    median_allhelix=np.median(HGI[m:n])
    ####alpha-helix
    mean_helix=np.mean(H[m:n])
    std_helix=np.std(H[m:n])
    median_helix=np.median(H[m:n])
    #####beta-sheets
    mean_betasheet=np.mean(E[m:n])
    std_betasheet=np.std(E[m:n])
    median_betasheet=np.median(E[m:n])
    ######Turns
    mean_turns=np.mean(T[m:n])
    std_turns=np.std(T[m:n])
    median_turns=np.median(T[m:n])
    #####Coils
    mean_coils=np.mean(C[m:n])
    std_coils=np.std(C[m:n])
    median_coils=np.median(C[m:n])
    file2.write('%d\t%d\t RUN \t%.2f\t%.2f\t%.2f\t'%(t1,t2,mean_allhelix,std_allhelix,median_allhelix))
    file2.write('%.2f\t%.2f\t%.2f \t'%(mean_helix,std_helix,median_helix,))
    file2.write('%.2f\t%.2f\t%.2f \t'%(mean_betasheet,std_betasheet,median_betasheet))
    file2.write('%.2f\t%.2f\t%.2f \t'%(mean_turns,std_turns,median_turns))
    file2.write('%.2f\t%.2f\t%.2f \n'%(mean_coils,std_coils,median_coils))
    ##print(m,n)
    m+=mean_int
    n+=mean_int
    t1+=interval
    t2+=interval
file2.close()
print(len(H))
print('done')
