#!/bin/bash



#This script allows to easily create a single simulated whole-genome sequence (WGS) data.
#Do loop can be implemented to create the 100,000 simulated WGS required for the ABC estimations.
#The ABC.txt output files created per simulated WGS data can be merged together to perform the ABC estimations.


neutral="neutral";			#path to neutral neutral simulations (set 1) [Fake: simulations must be prepared in advance by users]
selected="selected";		#path to selected logistic files     (set 2) [Fake: simulations must be prepared in advance by users]
WGS=".";					#path to store the WGS data generated (namely the output file "ABC.txt")
X="2";						#number of selective sweeps to simulate


#Run to create a WGS data using files stored in the "neutral" and "selected" folders.
perl make_simulated_WGS.pl $neutral $selected $WGS $X
 
 
