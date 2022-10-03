#!/bin/bash
paths=`pwd`		#allocates the present working directory (pwd) to the variable paths. Whenever the paths is invoked, it gives the pwd.





#python reneg.py


echo "What is your starting year?"
read yr_start
echo "What is your ending year?"
read yr_end

     yyyy=$yr_start		#the initial year.

     while [ $yyyy -le $yr_end ]			#while the year is less or equal to the final year.
     do						#loop over the years.





    # Loop over the months in the year
    #################################
     mm=1					#for months. 
     while [ $mm -le 13 ]
     do
      if [ $mm -le 9 ] ; then			#if the month is less or eual to 9, precede it with zero.
        mm=0${mm}
      fi
 
 if [ "$mm" = "01" -o "$mm" = "03" -o "$mm" = "05" -o "$mm" = "07" -o  "$mm" = "08" -o "$mm" = "10" -o "$mm" = "12" ] ; then
      days=31
     elif [ "$mm" -eq "04" -o "$mm" -eq "06" -o "$mm" -eq "09" -o "$mm" -eq "11" ] ; then
	  days=30
	  
      elif [ "$mm" -eq "02" ] ; then
	  
          if [ `expr $yyyy % 400` -eq "0" ] ; then
           days=29
           elif [ `expr $yyyy % 100` -eq "0" ] ; then
           days=28
           elif [ `expr $yyyy % 4` -eq "0" ] ; then
           days=29
           elif [ `expr $yyyy % 4` -ne "0" ] ; then
           days=28
          fi
	fi

      dd=1
      while [ $dd -le $days ]
      do
	  
      if [ $dd -le 9 ] ; then
	dd=0${dd}
      fi

        
input=${paths}/Gridded_Data/final_${yyyy}${mm}${dd}.csv		#assign the input file to the variable "input".
output=${paths}/NC/${yyyy}${mm}${dd}.nc

	if [ -s $output ] ; then  # remove (rm) output if already exists before saving
	rm $output
	fi


cdo -r -f nc input,my_gridfile.txt try.nc < ${input}
cdo setday,${dd} try.nc tryy.nc 
cdo setmon,${mm} tryy.nc try1.nc
cdo setyear,${yyyy} try1.nc ${output}

dd=`expr $dd + 1`
done
mm=`expr $mm + 1`	#monthly increment
done
echo 'Done with' $yyyy
yyyy=`expr $yyyy + 1`		#annual increment
done

####rm *13.nc

cdo mergetime NC/*.nc Ghana_1960_2015_05.nc
rm try*
exit
