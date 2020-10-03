# This program calulates switch distance
# Sherwin Massoudian
# 2020 Fall
# perl getSwitchDistance.pl whatshap.genotype.826.chr10.txt hapseq2.genotype.826.chr10.txt
 
# [s_m774@login2 ~]$ cp data/july2020.MIHA/compare/* Haplotype-Research/testSwitchDistance/

# Both input files will have the genotype data in 2 columns
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
my %nucleotide1;

while (!eof(IN1) and !eof(IN2)) {
	my $line1 = <IN1>;
    my $line2 = <IN2>;
	chomp $line1;
	chomp $line2;	
	my @nucleotide1 = split(/ /, $line1);
	my @nucleotide2 = split(/ /, $line2);
	my $nucleotide1 = $nucleotide1[0];
	my $nucleotide2 = $nucleotide2[0];
	
	if(exists($nucleotide1{$nucleotide1})) 
	{ 
		# print "Exists\n"; 
		if ($nucleotide1{$nucleotide1} ne $nucleotide2) {
			# print "Switch\n";
			$nucleotide1{$nucleotide1} = $nucleotide2;
			$nucleotide1{$nucleotide2} = $nucleotide1;
			$switches++;
		}
	} 
	else
	{ 
		# print "Not Exists\n";
		$nucleotide1{$nucleotide1} = $nucleotide2;
	} 

}
print "Switch error =  $switches \n";

