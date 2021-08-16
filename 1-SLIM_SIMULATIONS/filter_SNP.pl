#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to filter SNPs based on the derived allele frequency filters defined by users
### This script is provided *as is* without warranty of any kind.

   
$selink_name        ="$ARGV[0]"; #Selink output
$selink_name_xpehh  ="$ARGV[1]"; #Selink output
$outfile_name       ="$ARGV[2]"; #Filtered Selink output
$outfile_name_xpehh ="$ARGV[3]"; #Filtered Selink output

$min_daf=0.2;
$max_daf=0.95;

open($selink,        "<", $selink_name)         or die "cannot open < $selink_name: $!";
open($selink_xpehh,  "<", $selink_name_xpehh)   or die "cannot open < $selink_name_xpehh: $!";
open($outfile,       ">", $outfile_name)        or die "cannot open > $outfile_name: $!";
open($outfile_xpehh, ">", $outfile_name_xpehh)  or die "cannot open > $outfile_name_xpehh: $!";
	

		$line=<$selink>; chomp($line); @temp=split(/\t/,$line); #header
		for(my $i=0; $i<@temp; $i++){
			if($temp[$i] eq "daf" ){
				$i_daf=$i;
			}
		}
		print $outfile "$line\n";
		
		$line_xpehh=<$selink_xpehh>; chomp($line_xpehh); #header
		print $outfile_xpehh "$line_xpehh\n";
		
		$line=<$selink>;
		while ( $line=<$selink> ) {				
			chomp($line);
			if( $line ){
				@temp=split(/\t/,$line);
				$line_xpehh=<$selink_xpehh>;chomp($line_xpehh); 
				
				if( $temp[0] ne "NA" ){ #trim de genomic regions
					if( $temp[$i_daf] >= 0.2 ){
						if( $temp[$i_daf] <= 0.95 ){
							print $outfile "$line\n";	
							print $outfile_xpehh "$line_xpehh\n";	
						}
					}
				}
			}
		}

close($selink);
close($selink_xpehh);
close($outfile);
close($outfile_xpehh);