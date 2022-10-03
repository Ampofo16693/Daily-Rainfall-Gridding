#!/bin/bash

paths=`pwd`

if [ ! -d "Gridded_Data_0.25" ]; then
  mkdir "Gridded_Data_0.25"
fi


cd Grid_Data
ls *.csv > ../tmp_datt
cd ..

ls Grid_Data/*.csv > tmp_datt1

paste tmp_datt tmp_datt1 > datt

indat=${paths}/datt

while read b a 
do

#echo $a



# Define the names of the input and output files
topo=June_out1.grd                  
ext=extract_data.xyz


# Define map characteristics
# Define your area -R-3.35/1.3/4.40/11.20
north=11.5
south=4.5
east=1.5
west=-3.5
tick='-B0.25/0.25WSen'
proj='-JM6i'
gs=0.25

#gmt psbasemap -R$west/$east/$south/$north $proj $tick -P -K > $out

awk '{ print $1, $2, $3}' $a > $ext

gmt blockmean -R$west/$east/$south/$north -I$gs -V $ext > 1_$ext
gmt surface 1_$ext -R$west/$east/$south/$north -I$gs -G$topo -V
gmt grd2xyz $topo > Gridded_Data_0.25/$b


################ Replacing negative values using python

python <<-EOF

import numpy as np
import scipy as sp

[lon,lat,RR]=np.transpose(sp.genfromtxt("Gridded_Data_0.25/$b"))

RR[RR<0]=0

pp=[]
for i in range(RR.size):
  p=lon[i],lat[i],RR[i]
  pp.append(p)

np.savetxt("Gridded_Data_0.25/final_$b",pp,fmt='%.1f')

EOF

rm Gridded_Data_0.25/$b
echo 'Station ',$a,' Completed'
done < $indat

rm datt $ext 1_$ext tmp_datt tmp_datt1 $topo

exit
