#!/usr/bin/env python
# coding: utf-8

# # Use this to plot moving average along with per frame data

# In[1]:


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


plotfile=input('Enter filename to be saved: ')
runs=[105,155]
for file in runs:
    data1=pd.read_csv('average_'+str(file)+'.dat', delimiter="\t",skiprows=1, header=None)
    data2=pd.read_csv('perframe_'+str(file)+'.dat', delimiter="\t",skiprows=1, header=None)
    lines=np.genfromtxt('single_values.dat')
    plotfile=plotfile+str(file)
    # In[8]:


    #Using moving Average
    maxR1=np.max(data2.iloc[:,0])
    numbers=np.arange(0,(maxR1+1)/10,0.1)
    def moving_average(arr, window_size):
        return np.convolve(arr, np.ones(window_size)/window_size, mode='valid')
    maxR2=(np.size(moving_average(data2.iloc[:,1],10)))
    numbers2=np.arange(0,maxR2/10,0.1)
    plt.figure(facecolor='white', figsize=(15,10))
    #plt.title(x,weight='bold')

    plt.plot(numbers2,moving_average(data2.iloc[:,1],10),label="Helices",lw=2,color='red')
    plt.plot(numbers2,moving_average(data2.iloc[:,3],10),label=r'$\beta$-Sheets',lw=2,color='blue')
    plt.plot(numbers2,moving_average(data2.iloc[:,4],10),label="Turns",lw=2,color='green')
    plt.plot(numbers2,moving_average(data2.iloc[:,5],10),label="Coils",lw=2,color='magenta')

    plt.plot(numbers,data2.iloc[:,1],lw=1, alpha=0.5,color='red')
    plt.plot(numbers,data2.iloc[:,3],lw=1, alpha=0.5,color='blue')
    plt.plot(numbers,data2.iloc[:,4],lw=1, alpha=0.5,color='green')
    plt.plot(numbers,data2.iloc[:,5],lw=1, alpha=0.5,color='magenta')


    plt.axhline(y = lines[0], color = 'r', linestyle = '--',lw=1.5)
    plt.axhline(y = lines[1], color = 'blue', linestyle = '--',lw=1.5)
    plt.axhline(y = lines[2], color = 'green', linestyle = '--',lw=1.5)
    plt.axhline(y = lines[3], color = 'magenta', linestyle = '--',lw=1.5)

    plt.legend(numpoints = 1,fontsize=18, prop=dict(weight='bold'))
    plt.xticks(np.arange(0,550,50),rotation=0,fontsize=18,weight='bold')
    plt.yticks(np.arange(0,1.1,0.1),fontsize=18,weight='bold'),
    plt.xlim(0,500)
    plt.xlabel("Time(ns)",fontsize=18,weight='bold')
    plt.ylabel("Fraction of Secondary Structure Content",fontsize=18,weight='bold')
    ax = plt.gca()
    x_minor_locator = plt.MultipleLocator(5)
    y_minor_locator = plt.MultipleLocator(0.05)
    ax.xaxis.set_minor_locator(x_minor_locator)
    ax.yaxis.set_minor_locator(y_minor_locator)
    ax.tick_params(which='both', width=2)
    ax.tick_params(which='major', length=10)
    ax.tick_params(which='minor', length=5, color='black')
    plt.savefig(plotfile+'runs.png', dpi=300, bbox_inches='tight')
    #plt.show()


# In[ ]:
