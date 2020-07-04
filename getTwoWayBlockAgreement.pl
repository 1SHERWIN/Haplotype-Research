# July 2020 renamed: getBlockAgreement.pl

# 2019 November
# Author: Sherwin Massoudian
# This script compares the SIHA results of 2 packages 

# perl ../compare2HA.pl peath.4col.txt hapcut.4col.txt result
 
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

# 3rd argument will be the output files prefix

# Deprecated: 4th argument decides to use 1st or 2nd package block ID
# 1 or 2

use strict; use warnings;

if (@ARGV != 3) {
	print "\nUsage: perl ./compare2HA.pl PhasedResultsA PhasedResultsB results\n\n";
	print "1st argument should have 4 columns: position hap1 hap2 BlockID\n";
	print "2nd argument should have 4 columns: position hap1 hap2 BlockID\n";
	print "3rd argument will be the output files prefix\n";
	die;
}

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

# get the intersect of both results
my @intersect = grep { exists $snpsB{$_} } keys %snpsA;
foreach(sort { $a <=> $b } @intersect) {
	print $outA "$snpsA{$_}\n";
	delete $snpsA{$_};
	print $outB "$snpsB{$_}\n";
	delete $snpsB{$_};
}

# get the positions unique to key file
foreach(sort { $a <=> $b } keys %snpsA) {
	print $outA "$snpsA{$_}\n";
	print $outB "-\t-\t-\t-\n";
	delete $snpsA{$_};
}
# my $key = $ARGV[2];
# if ($key == 1) {
# 	foreach(sort { $a <=> $b } keys %snpsA) {
# 		print $outA "$snpsA{$_}\n";
# 		print $outB "-\t-\t-\t-\n";
# 		delete $snpsA{$_};
# 	}
# }
# if ($key == 2) {
# 	foreach(sort { $a <=> $b } keys %snpsB) {
# 		print $outB "$snpsB{$_}\n";
# 		print $outA "-\t-\t-\t-\n";
# 		delete $snpsB{$_};
# 	}
# }


# Paste sorted files side by side
system("paste package1.txt package2.txt > 8col.txt");

# Sort file on key
system("sort -n -k 4 8col.txt > sorted8col.txt");
# $key *= 4;
# system("sort -n -k $key 8col.txt > sorted8col.txt");
open(IN1, "<sorted8col.txt") or die "Error opening sorted8col.txt\n";

# Results
my $outFile1 = $ARGV[2].".blocks.txt";
my $outFile2 = $ARGV[2].".agreementSummary.txt";
open my $out, '>', "$outFile1" or die $!;
open my $out2, '>', "$outFile2" or die $!;


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
my $posMatch = "-";
my $hapMatch = "-";
my $snvCountA = 0;
my $snvCountB = 0;
my $block = 0;
my $totalBlock = 0;
my $totalSNV = 0;
my $totalMatchedBlock = 0;
my $totalMatchedSNV = 0;
my $key = 3;


sub getPosAgreement(){
	$snvCountA = length($aHap1);
	$snvCountB = length($bHap1);
	if ($snvCountA == $snvCountB) {
		$posMatch = "match";
	}
}
sub getHapAgreement() {
	if ($aHap1 eq $bHap1 and $aHap2 eq $bHap2) {
		$hapMatch = "match";
		$totalMatchedSNV += $snvCountA;
		$totalMatchedBlock++;
	}
	elsif ($aHap1 eq $bHap2 and $aHap2 eq $bHap1) {
		$hapMatch = "match";
		$totalMatchedSNV += $snvCountA;
		$totalMatchedBlock++;
	}
	else {
		$hapMatch = "-";
	}
}
print $out "Block\tCountA\tCountB\tSNVs\tHaplotype\n";
sub printAgreement(){
	print $out "$totalBlock\t$snvCountA\t$snvCountB\t$posMatch\t$hapMatch\n";

}
sub resetCounts(){
	$aHap1 = "";
	$aHap2 = "";
	$bHap1 = "";
	$bHap2 = "";
	$posMatch = "-";
	$hapMatch = "-";
}
while (!eof(IN1)) {
	my $line = <IN1>;
	chomp $line;
	my @position = split(/	/, $line);
	$totalSNV++;
	
	# Get first block
	if ($block == 0) {
		$block = $position[$key];
		$totalBlock++;
	}
	
	# Print agreement at the end of a block
	if ($block != $position[$key]) {
		getPosAgreement();
		getHapAgreement();
		printAgreement();
		resetCounts();
		$block = $position[$key];
		$totalBlock++;
	}
	
	
	# Save the genotype of each package
	if ($position[$A1] ne '-'){
		$aHap1 .= $position[$A1];
		$aHap2 .= $position[$A2];
	}
	if ($position[$B1] ne '-'){
		$bHap1 .= $position[$B1];
		$bHap2 .= $position[$B2];
	}
}

# Print the last block
getPosAgreement();
getHapAgreement();
printAgreement();

# Print agreement
sub getAgreement() {
	my $disBlock = $totalBlock - $totalMatchedBlock;
	my $disSNV = $totalSNV - $totalMatchedSNV;
	my $matchBlockRatio = $totalMatchedBlock / $totalBlock;
	my $disBlockRatio = $disBlock  / $totalBlock;
	my $matchSNVRatio = $totalMatchedSNV / $totalSNV;
	my $disSNVRatio = $disSNV  / $totalSNV;
	
	print "Haplotype agreement is printed below and saved to file\n";
	print "Key\tagree\tdisag\ttotal\tagree%\tdisagree%\n";
	print "Block\t$totalMatchedBlock\t$disBlock\t$totalBlock\t$matchBlockRatio\t$disBlockRatio\n";
	print "SNV\t$totalMatchedSNV\t$disSNV\t$totalSNV\t$matchSNVRatio\t$disSNVRatio\n";
	
	print $out2 "Key\tagree\tdisag\ttotal\tagree%\tdisagree%\n";
	print $out2 "Block\t$totalMatchedBlock\t$disBlock\t$totalBlock\t$matchBlockRatio\t$disBlockRatio\n";
	print $out2 "SNV\t$totalMatchedSNV\t$disSNV\t$totalSNV\t$matchSNVRatio\t$disSNVRatio\n";
}
getAgreement;

close $out;
close $out2;
my $unlinked = unlink 'package1.txt', 'package2.txt', '8col.txt';

