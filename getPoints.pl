# 2019 Fall
# Name: Sherwin Massoudian. NetID: s_m774 
# This program points the intersection of two haplotype packages
# perl /home/s_m774/software/perl/getPoints.pl 826dbmGenotype.txt 826hapseq2Genotype.txt
 
# Both input files will have the genotype data in 2 columns
# T T
# T C
# T A
# T G
# G A
# C A
# A A

# Output is a point system: perfect match or swap is 1 point
# Strict compare match count: 65/120
# Non-Strict compare match count: 82.5/120
# Job took 0 seconds






use strict; use warnings;

# Start timer
my $start = time();
my ($match, $halfmatch, $snps) = (0,0,0);


# Open IO files
open(IN1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(IN2, "<$ARGV[1]") or die "Error reading $ARGV[1]\n";

while (!eof(IN1) and !eof(IN2)) {
	my $line1 = <IN1>;
    my $line2 = <IN2>;
	
	chomp $line1;
	chomp $line2;
	
	my @nucleotide1 = split(/ /, $line1);
	my @nucleotide2 = split(/ /, $line2);
	my %nucleotide1;
	my $count = 0;
	
	# Count the intersection of software packages on each genotype 
	foreach (@nucleotide1) {
		if (exists $nucleotide1{$_}){
			$nucleotide1{$_}++;
		}
		else {
			$nucleotide1{$_} = 1;
		}
	}
	
	foreach (@nucleotide2){
		if (exists $nucleotide1{$_}){
			if ($nucleotide1{$_} > 0) {
				$nucleotide1{$_}--;
				$count++;
			}
		}
	}
	
	# Optional: Print both genotypes and their intersection count
	# print "$line1 $line2 $count \n";

	if ($count == 2) {
		$match += 1.0;
	}
	
	if ($count == 1) {
		$halfmatch += 0.5;
	}
	
	$snps++;
}

$halfmatch += $match;

print "Strict genotype agreement: $match/$snps \n";
print "Non-Strict genotype agreement: $halfmatch/$snps \n";



# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
