# This program calulates switch distance
# Sherwin Massoudian
# 2020 Fall
# perl getSwitchDistance.pl whatshap.genotype.826.chr10.txt hapseq2.genotype.826.chr10.txt
 
# Both input files have 2 column genotype data 
# T T
# T C
# T A
# T G
# G A
# C A
# A A

# Output is the number of switches
# Switch error = 1

use strict; use warnings;

# Open IO files
open(IN1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(IN2, "<$ARGV[1]") or die "Error reading $ARGV[1]\n";

my $switches = 0;
my $match = 1; my $first_comparison = 1;

while (!eof(IN1) and !eof(IN2)) {
	my $line1 = <IN1>; chomp $line1;  
	my $line2 = <IN2>; chomp $line2;	
	my @nucleotide1 = split(/ /, $line1); my @nucleotide2 = split(/ /, $line2);
	my $nucleotide1 = $nucleotide1[0]; my $nucleotide2 = $nucleotide2[0];

	# skip homozygous positions
	if($nucleotide1[0] ne $nucleotide1[1] && $nucleotide2[0] ne $nucleotide2[1]) {
		if($first_comparison) {
			if ($nucleotide1[0] eq $nucleotide2[0]) {
				$match = 1; # 1 = true
			}
			else {
				$match = 0; # 0 = false
			}
			$first_comparison = 0;
		}
		if($match) {  
			if ($nucleotide1[0] ne $nucleotide2[0]) {
				$match = 0; # 0 = false
				$switches++;
			}
		} 
		else
		{ 
			if ($nucleotide1[0] eq $nucleotide2[0]) {
				$match = 1; # 1 = true
				$switches++;
			}
		}
	}
}
print "Switch error =  $switches \n";

