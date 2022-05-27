# -*- coding: utf-8 -*-
"""
Created on Mon Apr  5 14:33:57 2021

@author: 15193
"""

import matplotlib.pyplot as plt



def main():
    
# Importing the matplotlb.pyplot


# Declaring a figure "gnt"
    fig, gnt = plt.subplots()

# Setting Y-axis limits
    gnt.set_ylim(0, 100)

# Setting X-axis limits
    gnt.set_xlim(0, 50)

# Setting labels for x-axis and y-axis
    gnt.set_xlabel('seconds since start')
    gnt.set_ylabel('Task')

# Setting ticks on y-axis
    gnt.set_yticks([15, 30, 45, 60, 75])
# Labelling tickes of y-axis
    gnt.set_yticklabels(['1', '2', '3','4','5'])

# Setting graph attribute
    gnt.grid(True)


    gnt.broken_barh([(0, 4)], (15, 9), facecolors =('tab:orange'))
    gnt.broken_barh([(4, 1), (10, 6)], (30, 9),facecolors ='tab:blue')
    gnt.broken_barh([(5, 5)], (45, 9),facecolors =('tab:red'))
    gnt.broken_barh([(16, 8)], (60, 9), facecolors =('tab:green'))
    gnt.broken_barh([(24, 9)], (75, 9),facecolors ='tab:brown')
    plt.savefig("gantt_RSJF.png")

if __name__=="__main__":
    main()