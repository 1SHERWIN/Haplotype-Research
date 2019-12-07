# 2019 November
# Author: Sherwin Massoudian
# This script sorts SIHA results of 2 packages to match their positions

# perl ../getSortedSIHA.pl peath.4col.txt hapcut.4col.txt

 
# 1st argument should have 4 columns: position hap1 hap2 BlockID
# 69071   0       1       1
# 69083   0       1       1
# 76210   0       1       2
# 76294   0       1       2
# 77582   0       1       3

# 2nd argument should have 4 columns: position hap1 hap2 BlockID
# 69071   0       1       1
# 69083   0       1       1
# 76210   0       1       2
# 76294   0       1       2
# 77582   0       1       3

# Output will have the intersect of the inputs at the start of the file and uniques at the end
# Block	Agreement	Matches		SNPs
# 1       3       PeathHapcutMix  3
# 2       3       PeathHapcutMix  2
# 3       3       PeathHapcutMix  2
# 4       3       PeathHapcutMix  2
# 5       3       PeathHapcutMix  2

use strict; use warnings;

# Start timer
my $start = time();

# Sort file on key

# Open IO files
# open(IN1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
# open(IN2, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
# open(my $out, ">$ARGV[2]") or die "Error creating $ARGV[2]\n";


# first HA results
open my $fileA, '<', $ARGV[0] or die "Error reading $ARGV[0]\n";

# second HA results
open my $fileB, '<', $ARGV[1] or die "Error reading $ARGV[1]\n";

# output sorted file
open my $outA, '>', 'package1.txt' or die $!;
open my $outB, '>', 'package2.txt' or die $!;

# maps
my (%snpsA, %snpsB);
	
# map file A
while (!eof($fileA)) {
    my $line = <$fileA>;
	chomp($line);
	
	my @snp = split(/	/, $line);
	$snpsA{$snp[0]} = $line;
}

# map file B
while (!eof($fileB)) {
    my $line = <$fileB>;
	chomp($line);
	
	my @snp = split(/	/, $line);
	$snpsB{$snp[0]} = $line;
}

# output the intersect to both files
my @intersect = grep { exists $snpsB{$_} } keys %snpsA;
foreach(sort { $a <=> $b } @intersect) {
	print $outA "$snpsA{$_}\n";
	delete $snpsA{$_};
	print $outB "$snpsB{$_}\n";
	delete $snpsB{$_};
}

# output the unique positions file A
foreach(sort { $a <=> $b } keys %snpsA) {
	print $outA "$snpsA{$_}\n";
}

# output the unique positions file B
foreach(sort { $a <=> $b } keys %snpsB) {
	print $outB "$snpsB{$_}\n";
}


# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
