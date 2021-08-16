#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to normalize the iHS values by bin of derived allele frequency (DAF) 
### This script is provided *as is* without warranty of any kind.

$iHSfile_name ="$ARGV[0]"; #iHS values
$outfile_name ="$ARGV[1]"; #normalized iHS values
$stat         ="$ARGV[2]"; #nautrality statistic

open($iHSfile,  "<", $iHSfile_name)   or die "cannot open < $iHSfile_name: $!";
open($outfile, ">", $outfile_name)  or die "cannot open < $outfile_name: $!";
print $outfile "snp\tdaf\tiHS_norm\n";	

#Expectation and sandard errors of iHS computed by bin of DAF from neutral simulations performed in Africa
open($treshodfile,  "<", "AFR_normalization_values_$stat.txt")   or die "cannot open < AFR_normalization_values_$stat.txt: $!";
$line=<$treshodfile>; #skip header
$ibin=0;
while(  $line=<$treshodfile>  ){
	chomp($line); @temp=split(/\s+/,$line);	
	$minbin[$ibin]     = $temp[0];  $maxbin[$ibin]     = $temp[1];
	
	$E_iHS[$ibin]      = $temp[2];
	$SD_iHS[$ibin]     = $temp[3];
	
	$ibin++;
}
close $treshodfile;

$line=<$iHSfile>;
while(  $line=<$iHSfile>  ){
	chomp($line); @temp=split(/\s+/,$line);
	
	$daf=$temp[1];
	$tiHS=$temp[2];
	
	for(my $i=0; $i<@minbin; $i++){
		if( $daf < $maxbin[$i] ){			
			$tiHSnorm= ( $tiHS - $E_iHS[$i] ) / $SD_iHS[$i];							
			$i=@minbin+1;
		}
	}
	
	print $outfile "$temp[0]\t$temp[1]\t$tiHSnorm\n";
}

close($iHSfile);
close($outfile);


