#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to make the logistic files
### This script is provided *as is* without warranty of any kind.

$candidate_name   ="$ARGV[0]"; #file storing candidate/noncandidate statu [1/0] of each SNP for the iHS neutrality statistics
$enrichment_name  ="$ARGV[1]"; #file storing significant/nonsignificant enrichment in candidate SNPs 100K arround each SNP
$PSVmap_name	  ="$ARGV[2]"; #file storing PSV/ENV statu for each SNP
$outfile_name     ="$ARGV[3]"; #Logistic file

open($candidate , "<", $candidate_name)   or die "cannot open < $candidate_name: $!";
open($enrichment, "<", $enrichment_name)  or die "cannot open < $enrichment_name: $!";
open($PSVmap,     "<", $PSVmap_name)  or die "cannot open < $PSVmap_name: $!";
open($outfile,    ">", $outfile_name)     or die "cannot open < $outfile_name: $!";
print $outfile "snp\tdaf\tPSV\tcandidate\tenrichment\n";


$line=<$candidate>;
$line_PSV=<$PSVmap>;
$line_enrich=<$enrichment>;
while(  $line=<$candidate>  ){
	chomp($line); @temp=split(/\s+/,$line);
	
	$line_PSV=<$PSVmap>;       chomp($line_PSV);    @temp_PSV=split(/\s+/,$line_PSV);
	$line_enrich=<$enrichment>;chomp($line_enrich); @temp_enrich=split(/\s+/,$line_enrich);
	
	print $outfile "$temp[0]\t$temp[1]\t$temp_PSV[1]\t$temp[2]\t$temp_enrich[2]\n";
}

close($candidate);
close($enrichment);
close($PSVmap);
close($outfile);


