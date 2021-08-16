#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to annotate PSV/ENV SNPs (for simulated regions only)
### This script is provided *as is* without warranty of any kind.

   
$selink_name  ="$ARGV[0]"; #Selink output
$outfile_name ="$ARGV[1]"; #PSV MAP
$annotation   ="$ARGV[2]"; #PSV MAP

open($selink,  "<", $selink_name)   or die "cannot open < $selink_name: $!";
open($outfile, ">", $outfile_name)  or die "cannot open < $outfile_name: $!";
print $outfile "snp\tPSV\n";	
	

		$line=<$selink>; chomp($line); @temp=split(/\t/,$line); #header
		for(my $i=0; $i<@temp; $i++){
			if($temp[$i] eq "core_pos" ){
				$i_pos=$i;
			}
		}
		
		while ( $line=<$selink> ) {				
			chomp($line);
			if( $line ){
				@temp=split(/\t/,$line);
				if( $annotation  eq "PSV" ){
					print $outfile "$temp[$i_pos]\t1\n";
				}else{
					print $outfile "$temp[$i_pos]\t0\n";
				}
			}
		}

close($selink);
close($outfile);