# 2019 November
# Author: Sherwin Massoudian
# This script compares theSIHA results of 2 packages 

# perl ./compare2HA.pl peath.4col.txt hapcut.4col.txt 1 results.txt

 
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

# 3rd argument decides to use 1st or 2nd package block ID
# 1 or 2

# 4th argument will be the output

use strict; use warnings;

# Start timer
# my $start = time();

# first HA results
open my $fileA, '<', $ARGV[0] or die "Error reading $ARGV[0]\n";

# second HA results
open my $fileB, '<', $ARGV[1] or die "Error reading $ARGV[1]\n";

# output sorted file
open my $outA, '>', 'package1.txt' or die $!;
open my $outB, '>', 'package2.txt' or die $!;

# hash maps
my (%snpsA, %snpsB);
	
# Transfer file A into a map
while (!eof($fileA)) {
    my $line = <$fileA>;
	chomp($line);
	
	my @snp = split(/	/, $line);
	$snpsA{$snp[0]} = $line;
}

# Transfer file B into a map
while (!eof($fileB)) {
    my $line = <$fileB>;
	chomp($line);
	
	my @snp = split(/	/, $line);
	$snpsB{$snp[0]} = $line;
}

# output the intersect of both results
my @intersect = grep { exists $snpsB{$_} } keys %snpsA;
foreach(sort { $a <=> $b } @intersect) {
	print $outA "$snpsA{$_}\n";
	delete $snpsA{$_};
	print $outB "$snpsB{$_}\n";
	delete $snpsB{$_};
}

# output unique variants 
foreach(sort { $a <=> $b } keys %snpsA) {
	print $outA "$snpsA{$_}\n";
	print $outB "-\t-\t-\t10000\n";
	delete $snpsA{$_};
}
foreach(sort { $a <=> $b } keys %snpsB) {
	print $outB "$snpsB{$_}\n";
	print $outA "-\t-\t-\t10000\n";
	delete $snpsB{$_};
}


# Paste sorted files side by side
system("paste package1.txt package2.txt > 8col.txt");

# Sort file on key
my $key = $ARGV[2] * 4;
system("sort -n -k $key 8col.txt > sorted8col.txt");

open(IN1, "<sorted8col.txt") or die "Error opening sorted8col.txt\n";
open my $out, '>', $ARGV[3] or die $!;


# index of each haplotype
my $A1 = 1;
my $A2 = 2;
my $B1 = 5;
my $B2 = 6;


# String to record Haplotype blocks
my $aHap1 = "";
my $aHap2 = "";
my $bHap1 = "";
my $bHap2 = "";
my $block = 0;
my $agree = 0;
my $snvinblock = 0;
my $agreeString = "";
my $blockCount = 0;
my $snvCount = 0;
$key--;


sub getAgreement(){
	if ($aHap1 eq $bHap1 and $aHap2 eq $bHap2) {
		$agreeString = "match";
		$snvCount += $snvinblock;
		$blockCount++;
	}
	elsif ($aHap1 eq $bHap2 and $aHap2 eq $bHap1) {
		$agreeString = "match";
		$snvCount += $snvinblock;
		$blockCount++;
	}
	else {
		$agreeString = "-";
	}
}
sub printAgreement(){
	print $out "$block\t$agreeString\t$snvinblock\n";

}
print $out "Block\tAgreement\tSNP count\n";
while (!eof(IN1)) {
	my $line = <IN1>;
	chomp $line;
	
	my @position = split(/	/, $line);
	if ($block == 0) {
		$block = $position[$key];
	}
	
	# Count the SNPs in each block
	$snvinblock++;
	
	# Print package agreement at the end of a block
	if ($block != $position[$key]) {
		getAgreement();
		printAgreement();
		$block = $position[$key];
		$aHap1 = "";
		$aHap2 = "";
		$bHap1 = "";
		$bHap2 = "";
		$agreeString = "-";
		$snvinblock = 0;
		# print "$blockCount\t$snvCount\n";
	}
	
	
	# Add genotype in current line
	$aHap1 .= $position[$A1];
	$aHap2 .= $position[$A2];
	$bHap1 .= $position[$B1];
	$bHap2 .= $position[$B2];
}

# Print the last block
getAgreement();
printAgreement();

close $out;

# Display runtime
# my $endTime = time();
# my $runTime = $endTime - $start;
# print "Job took $runTime seconds \n";

# Print agreement
print "$ARGV[0] and $ARGV[1] agreement: $blockCount blocks and $snvCount SNVs\n";
