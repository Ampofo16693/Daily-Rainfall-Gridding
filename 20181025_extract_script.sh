#!/bin/bash

input=Ghana_1960_2015_0.25.nc

cdo splityear ${input} Split_year/
yyyy=1960

while [ $yyyy -le 2015 ]
do

	cdo splitmon Split_year/${yyyy}.nc Split_month/
    # Loop over the months in the year
    #################################
     mm=1					#for months. 
     while [ $mm -le 12 ]
     do
      if [ $mm -le 9 ] ; then			#if the month is less or eual to 9, precede it with zero.
        mm=0${mm}
      fi

	mv Split_month/${mm}.nc Split_month/${yyyy}_${mm}.nc
	cdo splitday Split_month/${yyyy}_${mm}.nc Daily_Data/ 

 if [ "$mm" = "01" -o "$mm" = "03" -o "$mm" = "05" -o "$mm" = "07" -o  "$mm" = "08" -o "$mm" = "10" -o "$mm" = "12" ] ; then
      days=31
     elif [ "$mm" -eq "04" -o "$mm" -eq "06" -o "$mm" -eq "09" -o "$mm" -eq "11" ] ; then
	  days=30
	  
      elif [ "$mm" -eq "02" ] ; then
		if [ $((year % 4)) -eq 0 ]; then
		  if [ $((year % 100)) -eq 0 ]; then 
			    if [ $((year % 400)) -eq 0 ]; then
			      days=29
			    else
			      days=28
			    fi
		  else
		    days=29
		  fi
		else
		  days=28
		fi          
fi

dd=1
while [ $dd -le $days ]
do

if [ $dd -le 9 ] ; then
dd=0${dd}
fi

	mv Daily_Data/${dd}.nc Daily_Data/${yyyy}_${mm}_${dd}.nc

echo $mm $dd

dd=`expr $dd + 1`
done
echo 'Done with' $mm
mm=`expr $mm + 1`	#monthly increment
done

echo 'Done with' $yyyy
yyyy=`expr $yyyy + 1`		#annual increment
done
exit
