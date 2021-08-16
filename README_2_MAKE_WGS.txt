
### Shell and perl scripts required for creating a single whole-genome sequence (WGS) data from simulated genomic regions (environment: cygwin).
###
### Location : folder 2-MAKE_GENOME
################################################################################################################################################


### Scripts provided: we provide scripts to generate the simulated WGS data, compute the ORs and create the output file used to perform the ABC estimations.

	-Main script: "make_simulated_WGS.pl" creates a single WGS dataset by randomly drawing simulated genomic regions from 2 sets of simulated files prepared in advance 
	(one Selink file per simulation with SNPs filtered from DAF values).
		1st Set: NEUTRAL, genomic regions simulated under neutrality, the ENV and the neutral PSV regions (psv set to 0 or 1 in logistic files).
			Files must be organized as follows (file names must be the same, the index of simulation is mandatory)
			One file per simulation, the selink output file with the neutrality statistics
					simulation 1  : user_path_1/Selink_sim1_AFR.out.filtered.txt
					....
					simulation N1 : user_path_1/Selink_simN1_AFR.out.filtered.txt

		2nd Set: SELECTED, genomic regions simulated under selection, the X sweeps to simulate (psv set to 1 in logistic files)
			Files must be organized as follows (file names must be the same, the index of simulation is mandatory)
			Two files per simulation, the selink output file with the neutrality statistics + the file storing the selection parameters (s,t)
					simulation 1  : user_path_2/Selink_sim1_AFR.out.filtered.txt	+	user_path_2/selection_parameters_sim1.txt
					....
					simulation N2 : user_path_2/Selink_simN2_AFR.out.filtered.txt	+	user_path_2/selection_parameters_simN2.txt
		This set of simulations can be performed with various distributions of s (selection coefficient) and t (age of selection) specifed by users.
		
		Note: in the folder 2-MAKE_GENOME, we created two folders named "neutral" and "selected" to examplify how to organize the 1st and 2nd sets of simulations.

	-Demonstration script: the bash Shell script "RUN_make_genome.sh" allows to create a single simulated WGS data with X sweeps specified by users using files stored in
	the "neutral" and "selected" folders.

### Installing "make_simulated_WGS.pl": the script "make_simulated_WGS.pl" calls the following scripts:
		+make_Logistic_file.pl (see README_3_LOGISTIC_FILE.txt for details) : this script and dependency must be installed in the folder "../3-MAKE_LOGISTIC_FILES" 
		+OddsRatio.sh          (see README_4_OR.txt for details)            : this script and dependency must be installed in the folder "../4-COMPUTE_OR" 
The scripts "make_Logistic_file.pl" and "OddsRatio.sh" and their dependency can be installed elsewhere by the users but the corresponding path must be updated in "make_simulated_WGS.pl".

### Output file: make_simulated_WGS.pl creates a single file named "ABC.txt" which stores the ORs computed using all SNPs in the WGS dataset newly generated.
the simulated files randomly drawn are merged together and the ORs are computed without any correction for covariates.
The "ABC.txt" contains one raw and is organized as follow:
	-three first columns (ABC parameters):
		+X : number of sweeps
		+S : average selection coefficient for the X simulated sweeps
		+T : average age of selection for the X simulated sweeps
	-other columns (ABC summary statistics):
		+OR 1 : OR for the neutrality statistic 1
		+... 
		+OR K : OR for the neutrality statistic K (the number and the choice of the K neutrality statistics used depends on users)
When building several simulated WGS datasets, the ABC.txt files created per WGS dataset can be merged into a single file which can be easily used with the standard ABC methods (e.g., the abc R package)
A minimum of 100,000 simulated WGS data is required to perform the ABC estimation of X, S and T.
