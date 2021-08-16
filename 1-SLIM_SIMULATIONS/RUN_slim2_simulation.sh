#!/bin/bash


Nsim=1          ; 	#number of simulations
LENGTH="5000000"; 	#length of the simulated DNA region
SELPOS="2500000";	#location of the selected site

#Create 'Nsim' SLiM input files from the specified template SLiM input files 'TEMPLATE_sweep_Africa'
perl draw_parameters.pl TEMPLATE_sweep_Africa $Nsim 5000000 2500000

#Run the SLiM simulations and compute various neutrality statistics using selink
perl run_slim.pl $Nsim TEMPLATE_sweep_Africa $LENGTH
 
 
