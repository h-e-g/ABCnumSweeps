#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to extract the iHS values from selink output files
### This script is provided *as is* without warranty of any kind.

   
$selink_name  ="$ARGV[0]"; #Selink output
$outfile_name ="$ARGV[1]"; #iHS values

open($selink,  "<", $selink_name)   or die "cannot open < $selink_name: $!";
open($outfile, ">", $outfile_name)  or die "cannot open < $outfile_name: $!";
print $outfile "snp\tdaf\tiHS\n";	
	

		$line=<$selink>; chomp($line); @temp=split(/\t/,$line); #header
		for(my $i=0; $i<@temp; $i++){
			if($temp[$i] eq "core_pos" ){
				$i_pos=$i;
			}
			if($temp[$i] eq "daf" ){
				$i_daf=$i;
			}
			if($temp[$i] eq "ihs" ){
				$i_iHS=$i;
			}
		}
		
		while ( $line=<$selink> ) {				
			chomp($line);
			if( $line ){
				@temp=split(/\t/,$line);
				print $outfile "$temp[$i_pos]\t$temp[$i_daf]\t$temp[$i_iHS]\n";	
			}
		}

close($selink);
close($outfile);