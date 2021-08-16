#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to generate SLIM parameter files from the template SLIM parameter file 
### This script is provided *as is* without warranty of any kind.

$paramfile ="$ARGV[0]";			#template SLIM parameter file
$nsim      ="$ARGV[1]";			#number of simulations
$min_age   =5355;
$max_age   =5699;
$range     =$max_age-$min_age;	#range of the rescaled age of selection (from $min_age=5355 to $max_age=5699)
$length    ="$ARGV[2]"; 			#length of simulated DNA region
$selpos    ="$ARGV[3]";			#location of the selected site
		

		
		for ( $isim=1 ; $isim<=$nsim ; $isim++ ) {
			#the SLIM parameter file required to perform simulations
			open($template, "<", "$paramfile") or die "cannot open < $paramfile: $!";
			$file="$paramfile".".$isim";
			open($outfile, ">", "$file") or die "cannot open < $file: $!";  
			
			#store the selection parameters used to simulate
			$file="selection_parameters_sim$isim.txt";			
			open($outparam, ">", "$file") or die "cannot open < $file: $!"; 
			
			#randomly draw the rescaled age of the selected mutation (flat prior given as an example)
			$drawn_age=$min_age + int(rand($range));			
			print $outparam "$drawn_age\t";
			
			#randomly draw the rescaled selection coefficient of the selected mutation (flat prior given as an example)
			$drawn_S=rand(0.055);			
			print $outparam "$drawn_S\t";		
			#Rescaling for performing simulations
			$drawn_S= 10*$drawn_S;
			
			#recombination map and burnin files specified by users
			$recmap_file="./recmap.txt";
			$burnin_file="./burnin.txt";
			
			#frequency of the selected mutation at the onset of selection			
			print $outparam "value_stored_in_SLiM_simulated_file_$isim\n";
			
			close $outparam;
			
			#replace values in the template file and create the SLIM parameter file required to perform simulations
			while ( $line=<$template> ) {
		       		if( $line=~m/\$LENGTH/){					
					$line=~s/\$LENGTH/$length/g;					
					print $outfile "$line";
					
				}elsif( $line=~m/\$SELPOS/){					
					$line=~s/\$SELPOS/$selpos/g;					
					print $outfile "$line";	
					
				}elsif( $line=~m/\$MUT_age/){					
					$line=~s/\$MUT_age/$drawn_age/g;					
					print $outfile "$line";
					
				}elsif( $line=~m/\$Scoef/){					
					$line=~s/\$Scoef/$drawn_S/g;					
					print $outfile "$line";
					
				}elsif( $line=~m/\$RECMAP_file/){					
					$string=$recmap_file;					
					$line=~s/\$RECMAP_file/$string/g;					
					print $outfile "$line";
					
				}elsif( $line=~m/\$ANCESTOR_file/){					
					$string=$burnin_file;				
					$line=~s/\$ANCESTOR_file/$string/g;					
					print $outfile "$line";
					
				}else{
					print $outfile "$line";
				}				
			}
			close $file;
			close $template;
			
		}
