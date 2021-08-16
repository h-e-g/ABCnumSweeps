
### Shell, perl and R scripts required for the computation of the odds ratio (OR) for selection (environment: cygwin).
###
### Location : folder 4-COMPUTE_OR
######################################################################################################################


### Scripts provided: we provide several scripts to compute the OR for a given neutrality statistics.
The neutrality statistic iHS is used here as an example.
	
	-Main script: the bash shell script named "OddsRatio.sh" calls the R script "OR_logistic_reg.r".
		+"OR_logistic_reg.r" computes the odds ratio for selection (OR) according to the two following logistic regression models:
			+a model without covariates :: PSV ~ candidateSNP              (equation 2 of the manuscript).
			+a model with covariates    :: PSV ~ candidateSNP + covariates (equation 3 of the manuscript).
	
	-Demonstration script: the bash Shell script "RUN_OR_computation.sh" can be used to compute the OR using a data file provided (see the section entitled "Demonstration data" below).

### OddsRatio.sh: script to launch OR_logistic_reg.r using the following command
	-R CMD BATCH "--args $LOGISTIC_REGRESSION_FILE $LOGISTIC_MODEL" OR_logistic_reg.r

### OR_logistic_reg.r: two mandatory options 
	-LOGISTIC_REGRESSION_FILE : the input data file i.e., the Logistic file (see the file README_3_LOGISTIC_FILE.txt for details) 
	-LOGISTIC_MODEL           : 0 [logistic model without covariates] / 1 [logistic model with covariates]
	
### Logistic file: the input data file required to perform the logistic regressions is fully described in README_3_LOGISTIC_FILE.txt. In brief this file contains:
	-the five first columns (snp, daf, PSV, candidate and enrichment) are mandatory to compute the uncorrected OR from the logistic regression without covariates.
	-the three last columns (coverage, recrate and numSNP) are optional and are used in the logistic regression with covariates.

### Results file: file storing the OR computed by the R script "OR_logistic_reg.r". The name by default is '$LOGISTIC_REGRESSION_FILE'.OR.txt
	-the OR from equation 1         : the Odds ratio value computed from equation 1 is given for information
	-the OR from equation 2 or 3    : Odds ratio value computed from the regression models (either uncorrected or corrected depending on the LOGISTIC_MODEL option set by users)
	-Ratio                          : this value, which is the ratio between the percentages of candidate SNPs in PSVs and in ENVs, is given for comparison.

### Demonstration data (toy example): the logistic regression file for the chromosome 2 (with LCT region) in the CEU population.
Quick computations can be run by using the following bash shell commands implemented in the script "RUN_OR_computation.sh".
	./OddsRatio.sh LOGISTIC_iHS_chr2.txt 0 (without covariates)
		the results will be stored in the output file "LOGISTIC_iHS_chr2.txt.OR.txt":
			OR(eq1)	uncorrected_OR(eq2)	Ratio
			1.735635 	1.735635 	1.728049 
	./OddsRatio.sh LOGISTIC_iHS_chr2.txt 1 (with covariates)
		the results will be stored in the output file "LOGISTIC_iHS_chr2.txt.OR.txt":
			OR(eq1)	corrected_OR(eq3)	Ratio
			1.735635 	1.693425	1.728049

### Notes: the logistic files described above can be easily generated from any other neutrality statistics contained in the Selink outputs (see the selink website for details https://github.com/h-e-g/selink).
The OR_logistic_reg.r script can be used for any kind of neutrality statistics, even for neutrality statistics not used in our study.
The text file "OR_computation.txt" provides a short guideline to compute various ORs on simulated and empirical WGS data.

