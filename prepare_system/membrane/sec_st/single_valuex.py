import numpy as np
import statistics
##This is to get average of all four runs from stride value
#name = input("Enter the pattern: ")

name="K5L1"
data1=np.genfromtxt('helixaverage_1.dat',delimiter='',comments='#',invalid_raise=False)
data2=np.genfromtxt('helixaverage_2.dat',delimiter='',comments='#',invalid_raise=False)
#data3=np.genfromtxt('helixaverage_3.dat',delimiter='',comments='#',invalid_raise=False)
file1=open(name+'_helix_average_std.dat','w')
#count=data1.shape[0]
calc1=data1[52:,3] ##rows to consider, column number
calc2=data2[52:,3] ##rows to consider, column number
#calc3=data3[52:,3] ##rows to consider, column number
#print(data3[52:,3])

average1=calc1.mean()
average2=calc2.mean()
#average3=calc3.mean()

lines=data2.shape[0]
dataset=[average1,average2]#,average3]
average=statistics.mean(dataset)
std=statistics.stdev(dataset)
#print(average1,average2,average3)
#print("PARAMETER Average %.2f  Std %2f"%(average,std))
file1.write("%s  \t\t%.3f \t %0.3f \n"%(name,average,std))
file1.close()
