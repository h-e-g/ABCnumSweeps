#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to make the logistic files from simulated selink output files
### This provided script can be updated to create logistic files for other neutrality statistics 
### and/or create logistic files from empirical (1000G) selink output files
### This script is provided *as is* without warranty of any kind.
   
$Selink_output ="$ARGV[0]"; #name of the selink output file (filtered for daf values)
$annotation    ="$ARGV[1]"; #annotation="ENV" set PSV=0 for all SNPs in file (for genomic regions simulated under neutrality)	
                          ; #annotation="PSV" set PSV=1 for all SNPs in file (for genomic regions simulated under selection)
                          ; #annotation="file_name", the PSV/ENV statu is read from the specified file_name (for empirical and simulated WGS data)


$stat          ="$ARGV[2]"; #name of the neutrality statistics in the Selink output files
$normalize     ="$ARGV[3]"; #normalization if required
$logistic_file ="$ARGV[4]"; #the logistic file created for the considered neutrality statistic (here iHS)

		
		#annnotation of SNPs in the Selink_output
		if( $annotation  eq "PSV" || $annotation  eq "ENV"  ){
			#make PSV map (for simulated regions only)
			$command = "perl annotate.pl $Selink_output PSV_map.txt $annotation";
			system($command);		

			$PSV_file="PSV_map.txt";
		}else{
			#use and existing PSV map (for emprical data)
			$PSV_file=$annotation;
		}

		#extract iHS
		$command = "perl extract.pl $Selink_output $stat.txt";
		system($command);
		
		if( $normalize  eq "yes" ){
			$command = "perl normalize.pl $stat.txt normalized_$stat.txt $stat";			
			system($command);			
			rename("normalized_$stat.txt", "$stat.txt") || die ( "Error in renaming normalized_$stat.txt" );		
		}		
		
		$command = "perl candidate.pl $stat.txt candidate_$stat.txt $stat";
		system($command);
		
		$command = "perl enrichment.pl candidate_$stat.txt enrichment_$stat.txt $stat";
		#system($command);		
		
		$command = "perl append_files.pl candidate_$stat.txt enrichment_$stat.txt $PSV_file $logistic_file";
		system($command);

		#clean
		unlink("ihs.txt")  		    || die ( "Error in removing 'ihs.txt'" );
		unlink("candidate_ihs.txt") || die ( "Error in removing 'candidate_ihs.txt'" );
		if( $annotation  eq "PSV" || $annotation  eq "ENV"  ){
			unlink("PSV_map.txt") || die ( "Error in removing 'PSV_map.txt'" );
		}
