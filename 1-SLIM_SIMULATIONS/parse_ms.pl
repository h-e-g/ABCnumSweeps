#!/usr/bin/perl

### Guillaume Laval (12 08 2021)
### Script used to parse the SLiM MS outputs 
### This script is provided *as is* without warranty of any kind.

use POSIX; ##arrondi
use FileHandle;
use Cwd;
use File::Copy;
   
#use IO::Compress::Gzip qw(gzip $GzipError);
#use IO::Uncompress::Gunzip qw(gunzip $GunzipError);

$SLiMfile_name  ="$ARGV[0]"; #SLiM MS output
$outfile_name   ="$ARGV[1]"; #formatted MS output

#extract all simulated SNPs (from relative position 0 to 1)
$beg=0; $end=1;

#Definition of the three simulated populations
$name[0]="AFR"; $simuorigin[0]="p1"; $samplesize[0]=200; 
$name[1]="EUR"; $simuorigin[1]="p2"; $samplesize[1]=200; 
$name[2]="ASI"; $simuorigin[2]="p3"; $samplesize[2]=200; 


open($simfile, "<", $SLiMfile_name) or die "cannot open < $SLiMfile_name: $!";
open($outfile, ">", $outfile_name)  or die "cannot open > $outfile_name: $!";

#print "$SLiMfile_name\t$outfile_name\n";
		
		@active=();@list_pos=();@haplo=();@Nhaplo=();
		
		$ipop=-1;
		while ( $line=<$simfile> ) {				
			chomp($line);
			if( $line eq "//" ){
				@temp=split(/\t/,$line);
				
				$ipop++;
				$line=<$simfile> ; #skip segsites
				
				#read position
				$line=<$simfile> ; $line=~s/positions: // ; chomp($line);@temp=split(/ /,$line);
				$isite=0; $prev=-1;
				for($cpt=0;$cpt<@temp;$cpt++){
					$active[$ipop][$cpt]=0;
					if( $temp[$cpt] >= $beg ){
						if( $temp[$cpt] <= $end ){								
							$active[$ipop][$cpt]=1;
							#to deal with SLiM mutations occured at the same position
							if( $temp[$cpt] == $prev ){
								if( $replicon == 1 ){
									$list_pos[$ipop][$isite]=$temp[$cpt]+0.0000002;
									$replicon=2;
								}elsif( $replicon == 2 ){
									$list_pos[$ipop][$isite]=$temp[$cpt]+0.0000003;
									$replicon=3;
								}else{
									$list_pos[$ipop][$isite]=$temp[$cpt]+0.0000001;
									$replicon=1;
								}				
							}else{
								$list_pos[$ipop][$isite]=$temp[$cpt];
								$replicon=0;
							}							
							$isite++;
							$prev=$temp[$cpt];						
						}
					}					
				}
				$ihaplo=0;
			}else{					
				@temp=split(//,$line);
				$isite=0;
				for($cpt=0;$cpt<@temp;$cpt++){
					if( $active[$ipop][$cpt] ){
						$haplo[$ipop][$ihaplo][$isite]=$temp[$cpt];
						$isite++;
					}					
				}
				$ihaplo++;
				$Nhaplo[$ipop]++;
			}
		}
		
		
		#combine haplo between different pops
		@temp_ref=(); @ref_doublon=(); @ref=();		
		$ref_isite=0;
		for($ipop=0;$ipop<@name;$ipop++){
			for($isite=0;$isite<@{$list_pos[$ipop]};$isite++){
				$temp_ref[$ref_isite]=$list_pos[$ipop][$isite];
				$ref_isite++;
			}
		}			
		@ref_doublon=sort { $a <=> $b } @temp_ref;
		$ref[0]=$ref_doublon[0];
		for($cpt=1,$cpt2=1;$cpt<@ref_doublon;$cpt++){
			if( $ref_doublon[$cpt]	== $ref_doublon[$cpt-1] ){
				
			}else{
				$ref[$cpt2]=$ref_doublon[$cpt];
				$cpt2++;
			}
		}
			
		#write haplotypes			
		for($ipop=0;$ipop<@name;$ipop++){				
			print $outfile "$simuorigin[$ipop]\t$samplesize[$ipop]\t$name[$ipop]\n";
			print $outfile "$list_pos[$ipop][0]";
			for($isite=1;$isite<@ref;$isite++){
				print $outfile "\t$ref[$isite]";	
			}
			print $outfile "\n";
			
			for( $ihaplo=0;$ihaplo<$Nhaplo[$ipop];$ihaplo++ ){					
				for($isite=0,$isite2=0;$isite<@ref;$isite++){						
					if( $ref[$isite] != $list_pos[$ipop][$isite2]   ){
						print $outfile "0";
					}else{
						print $outfile "$haplo[$ipop][$ihaplo][$isite2]";
						$isite2++;
					}								
				}
				print $outfile "\n";					
			}
		}		