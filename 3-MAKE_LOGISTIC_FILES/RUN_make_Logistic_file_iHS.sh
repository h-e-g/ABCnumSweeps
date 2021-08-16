#!/bin/bash


Selink_output="Selink_sim1_AFR.out.filtered.txt"   ; #simulated region to analyze (the Selink output file provided for a 5Mb region simulated in Africa)  	
annotation="PSV"                                   ; #annotation="PSV" set PSV=1 for all SNPs in the simulated file (for genomic regions simulated under selection)
stat="ihs"                                         ; #name of the neutrality statistics in the Selink output files
normalize="yes"                                    ; #normalization if required

logistic_file="$Selink_output.logistic.$stat.txt"  ; #the logistic file created for the considered neutrality statistic (here iHS)


#Run to create a logictic file from the selink output file given as an example "Selink_sim1_AFR.out" (5Mb genomic region simulated under neutrality in Africa)
perl make_Logistic_file.pl $Selink_output $annotation $stat $normalize $logistic_file
 
 
