#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to determine the candidate SNPs of selection 
### This script is provided *as is* without warranty of any kind.

$iHSfile_name ="$ARGV[0]"; #normalized iHS values
$outfile_name ="$ARGV[1]"; #candidate/noncandidate statu [1/0] of each SNP for the iHS neutrality statistics
$stat         ="$ARGV[2]"; #nautrality statistic

open($iHSfile,  "<", $iHSfile_name)   or die "cannot open < $iHSfile_name: $!";
open($outfile, ">", $outfile_name)  or die "cannot open < $outfile_name: $!";
print $outfile "snp\tdaf\tcandidate\n";	

#Threshold (P(0.01)) of iHS computed from neutral simulations performed in Africa
open($treshodfile,  "<", "AFR_candidate_threshold_$stat.txt")   or die "cannot open < AFR_candidate_threshold_$stat.txt: $!";
$line=<$treshodfile>; #skip header
while(  $line=<$treshodfile>  ){
	chomp($line); @temp=split(/\s+/,$line);	
	$thresh= $temp[1];
}
close $treshodfile;

$line=<$iHSfile>;
while(  $line=<$iHSfile>  ){
	chomp($line); @temp=split(/\s+/,$line);
	
	$tiHS=$temp[2];
	if( $tiHS <= $thresh ){			
		print $outfile "$temp[0]\t$temp[1]\t1\n";
	}else{
		print $outfile "$temp[0]\t$temp[1]\t0\n";
	}	
}

close($iHSfile);
close($outfile);


