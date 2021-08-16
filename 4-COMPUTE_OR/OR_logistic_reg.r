

### Guillaume Laval (12 08 2021)
### Script used to compute the OR
### This script is provided *as is* without warranty of any kind.

#clean R variables
rm( list=ls() )


variable <- commandArgs(trailingOnly=TRUE)
#a <- as.numeric(variable[2])
LOGISTIC_REGRESSION_FILE 	=  variable[1] ; #logistic regession file a given neutrality statistics 
LOGISTIC_MODEL 	            =  variable[2] ; #logistic regession with or without covariates [0 or 1]



data=read.table( paste0( LOGISTIC_REGRESSION_FILE ) , header=T)


result_file=paste0( LOGISTIC_REGRESSION_FILE, ".OR.txt" )
      if( LOGISTIC_MODEL == 0 ){
		cat ( file=result_file, append=F, paste0( "OR(eq1)\tuncorrected_OR(eq2)\tRatio\n")  )
}else if( LOGISTIC_MODEL == 1 ){
		cat ( file=result_file, append=F, paste0( "OR(eq1)\tcorrected_OR(eq3)\tRatio\n")  )
}else{
		cat ( paste0( "wrong option for COVARIATES, abort...\n")  )
}

	#OR computations

	psv=data[[3]]	
	candidate=data[[4]]	
	enrichment=data[[5]]	
	psv[ enrichment == 1 ]=1

	#OR (equation 1)
	P_psv_given_cand= length( psv[ psv == 1 & candidate == 1 ] ) / length( psv[ candidate == 1 ] );
	P_env_given_cand= length( psv[ psv == 0 & candidate == 1 ] ) / length( psv[ candidate == 1 ] );
	odds_psv_given_cand=P_psv_given_cand/P_env_given_cand
	
	P_psv_given_noncand= length( psv[ psv == 1 & candidate == 0 ] ) / length( psv[ candidate == 0 ] );
	P_env_given_noncand= length( psv[ psv == 0 & candidate == 0 ] ) / length( psv[ candidate == 0 ] );
	odds_psv_given_noncand=P_psv_given_noncand/P_env_given_noncand
	
	
	OddsRatio=odds_psv_given_cand/odds_psv_given_noncand;
	cat( file=result_file, append=T, OddsRatio, "\t" );
	
	
	#OR from the logistic regression (equation 2 or 3)
	
	      if( LOGISTIC_MODEL == 0 ){
		r=glm( psv ~ candidate                                                   , family=binomial) ;
		OddsRatio=exp( r$coefficients[2] ) ;
		cat( file=result_file, append=T, OddsRatio, "\t" );		
		
	}else if( LOGISTIC_MODEL == 1 ){
		cov=data$coverage
		rec=data$recrate
		Nsnp=data$numSNP
		
		r=glm( psv ~ candidate + cov + rec + Nsnp + cov*rec + cov*Nsnp + rec*Nsnp, family=binomial) ;
		OddsRatio=exp( r$coefficients[2] ) ;
		cat( file=result_file, append=T, OddsRatio, "\t" );
		
	}
	
	#ratio of the proportions of candidate SNPs observed in PSV and in ENV.
	num= length( psv[ psv == 1 & candidate == 1 ] ) / length( psv[ psv == 1 ] );
	denom= length( psv[ psv == 0 & candidate == 1 ] ) / length( psv[ psv == 0 ] );
	OddsRatio=num/denom;
	cat( file=result_file, append=T, OddsRatio, "\n" );
	
	