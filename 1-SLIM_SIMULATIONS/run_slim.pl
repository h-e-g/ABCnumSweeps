#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to run simulations from a SLIM parameter file
### This script is provided *as is* without warranty of any kind.

use warnings;
use Cwd;
use File::Copy;
   
$nsim   ="$ARGV[0]"; #number of simulations
$model  ="$ARGV[1]"; #SLIM parameter file
$length ="$ARGV[2]"; #length of simulated DNA region

for ( $isim=1 ; $isim<=$nsim ; $isim++ ) {
		$curr_model="$model".".$isim";		
   		$command = "./slim $curr_model  > tmp_screen.txt";
		system($command);			
		
		$command = "mv tmp_screen.txt screen_$isim.txt";
		system($command);
			
   		$command = "mv tmp_results.txt SLIM_MS_output.txt";
		system($command);
		
		$command = "perl parse_ms.pl SLIM_MS_output.txt temp_MS_output.txt";
		system($command);
		
		$command = "rm SLIM_MS_output.txt";
		system($command); #advised to save disk
		
		$command = "perl ms_to_Selink.pl temp_MS_output.txt $length $isim";
		system($command);
				
		$command = "rm temp_MS_output.txt";
		system($command); #advised to save disk
		
		#filter SNPs
		$selinkfile         ="Selink_sim$isim"."_AFR.out";
		$selinkfile_xpehhh  ="Selink_sim$isim".".interpop.xph";
		$selinkfile_filtered=$selinkfile.".filtered.txt";
		$selinkfile_xpehhh_filtered=$selinkfile_xpehhh.".filtered.txt";
		$command = "perl filter_SNP.pl $selinkfile $selinkfile_xpehhh $selinkfile_filtered $selinkfile_xpehhh_filtered";
		system($command);
		
		$command = "rm Selink_sim$isim"."_*.out Selink_sim$isim".".interpop.daf Selink_sim$isim".".interpop.fst Selink_sim$isim".".interpop.xph";
		system($command); #advised to save disk		
}

