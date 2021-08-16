
### Shell and perl scripts required for simulating a 5Mbp genomic region using SLIM (environment: cygwin).
### 
### Location : folder 1-SLIM_SIMULATIONS : 
##########################################################################################################


### Scripts provided: we provide several scripts to create the SLIM parameter file from a predefined template, run the simulation, parse the SLIM output file
into Selink file and compute the neutrality statistics using Selink.

	-the perl script named "draw_parameters.pl" create the SLIM parameter file from a predefined template.
	-the perl script named "run_slim.pl" calls:	
		+slim v2                             : run the simulation with the SLIM parameter file newly created
		+the perl script "parse_ms.pl"       : format the MS SLIM output  
		+the perl script "ms_to_Selink.pl"   : parse the SLIM output files into Selink files and compute the neutrality statistics using Selink (see the selink website for details https://github.com/h-e-g/selink)
		+the perl script "filter_SNP.pl"     : filter the simulated SNPs from DAF values

	-the bash Shell script "RUN_slim2_simulations.sh" can be used to rum simulations from the template SLIM "TEMPLATE_sweep_Africa". 
	The template "TEMPLATE_sweep_Africa" allows to simulate a sweep in Africa with ramdom or fixed parameters:
		+$ANCESTOR_file  : burnin (5N generations of burnin in a constant population size, see the SLIM manual)
		+$LENGTH         : length of the genomic region to simulate
		+$SELPOS         : position of the selected mutation
		+$RECMAP_file    : recombination map (column 1:position, column 2:recombination)
		+$Scoef          : selection coefficient
		+$MUT_age        : age of selection
