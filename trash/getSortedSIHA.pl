# 2019 November
# Author: Sherwin Massoudian
# This script sorts SIHA results of 2 packages to match their positions

# perl getSrotedSIHA.pl 
 
# 1st argument should have 12 columns: peath.pos       pea.h1  pea.h2  pea.blk hapcut.pos      cut.h1  cut.h2  cut.blk mixSIH.pos      mix.h1  mix.h2  mix.blk
# 3       1       0       1       3       0       1       1       3       0       1       1
# 4       1       0       1       4       0       1       1       4       0       1       1
# 10      1       0       2       10      0       1       2       10      0       1       2
# 11      1       0       2       11      0       1       2       11      0       1       2
# 12      1       0       3       12      0       1       3       12      0       1       3
# 13      1       0       3       13      0       1       3       13      0       1       3

# 2nd argument is the column number with Block ID that will be used as a key
# Package	Column
# Peath		4
# HapCut	8
# MixSIH	12

# 3rd argument will be the output file
# results.txt

# Output is a point system: 0 2 or 3 agreements on Block _
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
foreach(keys %snpsA) {
	print $outA "$snpsA{$_}\n";
}

# output the unique positions file B
foreach(keys %snpsB) {
	print $outB "$snpsB{$_}\n";
}


# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
