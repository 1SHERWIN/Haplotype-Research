# 2019 November
# Author: Sherwin Massoudian
# This script compares the SIHA results of 3 packages 

# perl ./compare2HA.pl peath.4col.txt hapcut.4col.txt whatshap.4col.txt 1 results.txt

 
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

# 3rd argument should have 4 columns: position hap1 hap2 BlockID
# 69071   0       1       1
# 69083   0       1       1
# 76210   0       1       2
# 76294   0       1       2
# 77582   0       1       3

# 4th argument decides to use 1st or 2nd package block ID
# 1 or 2

# 5th argument will be the output

use strict; use warnings;

# Start timer
my $start = time();

# first HA results
open my $fileA, '<', $ARGV[0] or die "Error reading $ARGV[0]\n";

# second HA results
open my $fileB, '<', $ARGV[1] or die "Error reading $ARGV[1]\n";

# third HA results
open my $fileC, '<', $ARGV[2] or die "Error reading $ARGV[2]\n";

# output sorted file
open my $outA, '>', 'package1.txt' or die $!;
open my $outB, '>', 'package2.txt' or die $!;
open my $outC, '>', 'package3.txt' or die $!;

# hash maps
my (%snpsA, %snpsB, %snpsC);
	
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

# Transfer file C into a map
while (!eof($fileC)) {
    my $line = <$fileC>;
	chomp($line);
	
	my @snp = split(/	/, $line);
	$snpsC{$snp[0]} = $line;
}

# output the intersect of three results
my @intersect = grep { exists $snpsB{$_} and exists $snpsC{$_} } keys %snpsA;
foreach(sort { $a <=> $b } @intersect) {
	print $outA "$snpsA{$_}\n";
	delete $snpsA{$_};
	print $outB "$snpsB{$_}\n";
	delete $snpsB{$_};
	print $outC "$snpsC{$_}\n";
	delete $snpsC{$_};
}
@intersect  = ();



# output the intersects of two results
@intersect = grep { exists $snpsB{$_} } keys %snpsA;
foreach(sort { $a <=> $b } @intersect) {
	print $outA "$snpsA{$_}\n";
	delete $snpsA{$_};
	print $outB "$snpsB{$_}\n";
	delete $snpsB{$_};
	print $outC "-\t-\t-\t10000\n";
}
@intersect  = ();
@intersect = grep { exists $snpsC{$_} } keys %snpsA;
foreach(sort { $a <=> $b } @intersect) {
	print $outA "$snpsA{$_}\n";
	delete $snpsA{$_};
	print $outC "$snpsC{$_}\n";
	delete $snpsC{$_};
	print $outB "-\t-\t-\t10000\n";
}
@intersect  = ();
@intersect = grep { exists $snpsC{$_} } keys %snpsB;
foreach(sort { $a <=> $b } @intersect) {
	print $outB "$snpsB{$_}\n";
	delete $snpsB{$_};
	print $outC "$snpsC{$_}\n";
	delete $snpsC{$_};
	print $outA "-\t-\t-\t10000\n";
}
@intersect  = ();




# output the unique results
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
foreach(sort { $a <=> $b } keys %snpsC) {
	print $outB "$snpsC{$_}\n";
	print $outA "-\t-\t-\t10000\n";
	delete $snpsB{$_};
}



# Paste sorted files side by side
system("paste package1.txt package2.txt > 8col.txt");
system("paste 8col.txt package3.txt > 12col.txt");

# Sort file on key
my $key = $ARGV[2] * 4;
system("sort -n -k $key 12col.txt > sorted12col.txt");

open(IN1, "<sorted12col.txt") or die "Error opening sorted12col.txt\n";
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
my $snvinblock;
my $snvCountA;
my $snvCountB;
my $posMatch = "";
my $hapMatch = "";
my $block = 0;
my $totalMatchedBlock = 0;
my $totalMatchedSNV = 0;
$key--;


sub getAgreement(){
	$snvCountA = length($aHap1);
	$snvCountB = length($bHap1);
	$posMatch = $snvCountA == $snvCountB ? "match" : "-";
	if ($aHap1 eq $bHap1 and $aHap2 eq $bHap2) {
		$hapMatch = "match";
		$totalMatchedSNV += $snvinblock;
		$totalMatchedBlock++;
	}
	elsif ($aHap1 eq $bHap2 and $aHap2 eq $bHap1) {
		$hapMatch = "match";
		$totalMatchedSNV += $snvinblock;
		$totalMatchedBlock++;
	}
	else {
		$hapMatch = "-";
	}
}
print $out "Block\tCountA\tCountB\tSNVs\tHaplotype\n";
sub printAgreement(){
	print $out "$block\t$snvCountA\t$snvCountB\t$posMatch\t$hapMatch\n";

}
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
		$hapMatch = "-";
		$snvinblock = 0;
	}
	
	
	# Add genotype in current line
	$aHap1 .= $position[$A1];
	$aHap2 .= $position[$A2];
	if ($bHap1 ne '-'){
		$bHap1 .= $position[$B1];
		$bHap2 .= $position[$B2];
	}
}

# Print the last block
getAgreement();
printAgreement();

close $out;

# Display runtime
my $runTime = $endTime - $start;
my $endTime = time();
print "Job took $runTime seconds \n";

# Print agreement
print "$ARGV[0] and $ARGV[1] agreement: $totalMatchedBlock blocks and $totalMatchedSNV SNVs\n";
