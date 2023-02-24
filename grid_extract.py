# -*- coding: utf-8 -*-
"""
Created on Sun Aug 27 14:55:23 2017

@author: gyerph
"""

import numpy as np
import scipy as sp
import os
import os.path            #To trace the path to our current directory
#from os.path import basename   #Used to assess file name from its working directory, without including its directory and subdirectory names.
import glob               #used to access subdirectories
path=os.getcwd()          #Save the current working directory to the variable path
os.chdir           




#[yr_start,yr_end]=sp.genfromtxt('try.csv')#,delimiter=',')
[yr_start,yr_end]=[1960,2015]

for yy in range(np.int(yr_start),np.int(yr_end)+1):     #loop through the years you want to vertically stack.
   for mm in range(1,13):              #loop through months 1 to 12.  (The 13 here limits it to 12.)
        if (mm==1 or mm==3 or mm==5 or mm==7 or mm==8 or mm==10 or mm==12):  # Condition for identifying number of days in a month.
            days=31
        elif (mm==4 or mm==6 or mm==9 or mm==11):
            days=30
        elif (mm==2):           # Condition for identifying number of days in February for both Ordinary and Leap years.
            if ( yy % 4 == 0 )):
              if ( yy % 100 == 0 ): 
                   if ( yy % 400 == 0 ):
                     days=29
                   else
                     days=28
              else
                days=29
            else
              days=28
               
        for dd in range(1,days+1):      #After completing the condition for days in a month, you now loop through the days, from day 1 to the final day of each month.
            pr=[]                   #create empty arrays for appending data
            
            all_files=glob.glob(os.path.join(path, "Name_Coordinates_Assigned/*.csv"))    #Store all files ending in '.csv' to the variable all_files
            all_files=sorted(all_files)            
            for file in all_files:          #Loop through all selected files
                [year,mon,day,st_name,lon,lat,data]=np.transpose(sp.genfromtxt(file, delimiter=',', skip_header=0))  #import data, skipping the first line and indicating that each column is separated by commas
                data[data==-999]=np.nan
                i=np.size(year)
                val=data[(year==yy)&(mon==mm)&(day==dd)]
                
                p=lon[2],lat[2],val
                pr.append(p)         
                                     
                       
            if (dd<10):
                dd_str='0'+np.str(dd)
            else:
                dd_str=np.str(dd)
                
            if (mm<10):
                mm_str='0'+np.str(mm)
            else:
                mm_str=np.str(mm)
            
            yy_str=np.str(yy)
            
            print('Day '+yy_str+mm_str+dd_str+' Completed') 
                
            np.savetxt('Grid_Data/'+yy_str+mm_str+dd_str+'.csv',pr,fmt='%.2f')

#            print(yy,mm,dd)
