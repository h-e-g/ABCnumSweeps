#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to create selink input files and run the selink computations
### This script is provided *as is* without warranty of any kind.

#use strict; 
use warnings;
use FileHandle;
use Cwd;
use File::Copy;

$ms_name  ="$ARGV[0]"; #formatted MS output
$LENGTH   ="$ARGV[1]"; #length of simulated DNA region
$currSIM  ="$ARGV[2]"; #simulation to analyze

#Definition of the three simulated populations
$name[0]="AFR"; $samplesize[0]=200; 
$name[1]="EUR"; $samplesize[1]=200; 
$name[2]="ASI"; $samplesize[2]=200; 


open($ms, "<", "$ms_name") or die "cannot open < $ms_name: $!";
	
	$firstime=1;
	my $line="";  $iind=0;
	while ( $line=<$ms> ) {
		chomp($line);	
		
	   	if( $line=~m/p/){			
			if( $firstime ){
				$selink_name  ="tmp_selink.sample";  
				open(my $smple, ">", "$selink_name") or die "cannot open < $selink_name: $!";	
				
				$selink_name  ="tmp_selink.hap";  
				open($selink, ">", "$selink_name") or die "cannot open '$selink_name': $!";
							
	   			$selink_name  ="tmp_selink.legend";  
				open(my $legend, ">", "$selink_name") or die "cannot open '$selink_name': $!";
				
				#create the selink.sample file
				for( $ipop=0 ; $ipop<3 ; $ipop++ ) {
					for( $icpt=1 ; $icpt<= ($samplesize[$ipop]/2) ; $icpt++ ) {
						print $smple "$name[$ipop]_$icpt\t1\t$name[$ipop]\n";
					}
				}
				close $smple;
			
				#create the selink.legend file						
	    		$line=<$ms>; chomp($line);
				@pos=split(/\t/,$line);				
				
				print $legend "ID\tpos\tallele0\tallele1\tancestral\n";
				for( my $isnp=0; $isnp<@pos ; $isnp++ ) {
					$rel_pos=$pos[$isnp]*$LENGTH;
					$abs_pos=int(  $rel_pos );
					
					if( $pos[$isnp] == 0.5 ){						
						print $legend "rs_selected\t$abs_pos\tA\tT\tA\n";
					}else{
						print $legend "rs_$isnp\t$abs_pos\tA\tT\tA\n";
					}
				}	
				close $legend;
			
				$firstime=0;
			}else{
				$line=<$ms>; 
			}
		}else{
			@temp=split(//,$line);			
			for( my $isnp=0; $isnp<@temp ; $isnp++ ) {
				$IND[$iind][$isnp][0]=$temp[$isnp];
			}
			
			$line=<$ms>; chomp($line);@temp=split(//,$line);					
			for( my $isnp=0; $isnp<@temp ; $isnp++ ) {
				$IND[$iind][$isnp][1]=$temp[$isnp];
			}
						
			$iind++;
			
		}
	}
	close $ms;	
	
	#create the selink.hap file
	$Nind=$iind;
	$Nsnp=@pos;	
	for( my $isnp=0; $isnp<$Nsnp ; $isnp++ ) {
		for( my $iind=0; $iind<$Nind ; $iind++ ) {		
			print $selink "$IND[$iind][$isnp][0]";
			print $selink "$IND[$iind][$isnp][1]";
		}
		print $selink "\n";
	}
	close $selink;	
	
	print "\t\trunning selink\n";
	$selink_window="100000"; #Selink computations using 100kb sliding windows
	$command = "./selink -l $selink_window -s -p -w -i -o Selink_sim$currSIM -T tmp_selink";
	system($command);
	
	$command = "rm Selink_sim*_excluded.out";
	system($command);
	
	$command = "rm *.hap *.legend *.sample ";
	system($command);
	
