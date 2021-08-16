
### Shell and perl scripts required for creating logistic files from simulated selink output files (environment: cygwin).
###
### Location : folder 3-MAKE_LOGISTIC_FILES
#########################################################################################################################


### The logistic file: this is the input data file required to compute the odds ratio for selection for a given neutrality statistic (see below for a description of this file). 
In our analysis pipeline we considered one logistic file per neutrality statistic (this can be easily modified by users). 
A logistic file stores the PSV (psv=0/1) and the candidate SNPs (candidate=0/1) definitions for all SNPs retained in the analysis (empirical or simulated SNPs)

### Scripts provided: we provide several scripts to create the logistic file for the neutrality statistic iHS, used here as an example.
The scripts provided can be updated to create logistic files for any other neutrality statistics.
They can also be updated to create logistic files from empirical (1000G) selink output files.

	-Main script: the bash shell script named "make_Logistic_file_iHS.pl" call several perl scripts.	
		+the perl script "annotate.pl"       : create PSV map for simulated loci
		+the perl script "extract.pl"        : get the iHS values from selink files
		+the perl script "normalize.pl"      : normalize iHS 
		+the perl script "candidate.pl"      : determine the candidate SNPs of selection for iHS (the 1% most negative values)
		+the perl script "enrichment.pl"     : determine the significant enrichment in candidate SNPs 100K around each SNP
		+the perl script "append_files.pl"   : make the logistic file

	-Demonstration script: the bash Shell script "RUN_make_Logistic_file_iHS.sh" can be used to build the logistic file from a simulated Selink output file provided (see the section entitled "Demonstration data" below).

### Logistic files format : the input file required to perform the logistic regression with R contains one raw per analyzed snp with eight columns defined as follow:
	the five following columns [mandatory]:
		-snp        : rs (or genomic location) of the SNPs
		-daf        : derived allele frequency
		-PSV        : indicator variable being equal to 1 if the SNP is a PSV or 0 otherwise.
		-candidate  : indicator variable being equal to 1 if the SNP is a candidate SNP of selection for the neutrality statistics used and 0 otherwise.
		-enrichment : indicator variable equal to 1 if the enrichment in candidate SNPs measured 100 kb around a ENV SNP is significant and 0 otherwise.
	
	the three last columns [optional]: covariates used in the logistic regression with covariate (not used for simulated data)
		-coverage   : the mean coverage computed 100 kb around the SNP 
		-recrate    : the mean recombination rate (HapMap recombination maps) computed 100 kb around the SNP 
		-numSNP     : the number of SNPs computed 100 kb around the SNP 
	
### Demonstration data (toy example): create the logistic file from the selink output file given as an example "Selink_sim1_AFR.out.filtered.txt".
The name of the the logistic file given by default is 'Selink_sim1_AFR.out.filtered.txt'.logistic.ihs.txt
(5Mb genomic region simulated under selection in Africa).
Genomic thresholds and normalization values computed from WGS data simulated in the same population are also given (see the three files "AFR_*_iHS.txt").
Neutral simulations can be done by setting the selection coefficient value equal to 0 or by removing the slim command lines used to simulate selection in the template file (advised).
