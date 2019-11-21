# 2019 Fall
# Name: Sherwin Massoudian. NetID: s_m774 
# This script scores the intersection of three haplotype packages
# perl /home/s_m774/software/perl/getAgreement12Col.pl peath.hapcut2.mixSIH.12col.txt 4 sampleResult.txt
 
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
# Block	Agreement
# 1		3
# 2		2
# 3		3
# 4		0

use strict; use warnings;

# Start timer
my $start = time();

# Open IO files
open(IN1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $out, ">$ARGV[2]") or die "Error creating $ARGV[2]\n";

# index of each haplotype
my $ph1 = 1;
my $ph2 = 2;
my $hh1 = 5;
my $hh2 = 6;
my $mh1 = 9;
my $mh2 = 10;

my $peathHap1 = "";
my $peathHap2 = "";
my $hapcutHap1 = "";
my $hapcutHap2 = "";
my $mixHap1 = "";
my $mixHap2 = "";
my $block = 0;
my $agree = 0;
my $line;
my $key = $ARGV[1];
$key--;


sub peathHapcutAgree(){
	if ($peathHap1 eq $hapcutHap1 and $peathHap2 eq $hapcutHap2) {
		return(1);
	}
	if ($peathHap1 eq $hapcutHap2 and $peathHap2 eq $hapcutHap1) {
		return 1;
	}
	return 0;
}
sub peathMixAgree(){
	if ($peathHap1 eq $mixHap1 and $peathHap2 eq $mixHap2) {
		return 1;
	}
	if ($peathHap1 eq $mixHap2 and $peathHap2 eq $mixHap1) {
		return 1;
	}
	return 0;
}
sub hapcutMixAgree(){
	if ($hapcutHap1 eq $mixHap1 and $hapcutHap2 eq $mixHap2) {
		return 1;
	}
	if ($hapcutHap1 eq $mixHap2 and $hapcutHap2 eq $mixHap1) {
		return 1;
	}
	return 0;
}
sub getBlockAgree(){
	$agree = 0;
	if (peathHapcutAgree()){
		$agree += 2;
	}
	if (peathMixAgree()){
		$agree += 2;
	}
	if (hapcutMixAgree()){
		$agree += 2;
	}
	if ($agree > 2){
		$agree = 3;
	}
}
sub printAgreement(){
	print $out "$block\t$agree\n";

}
print $out "Block\tAgreement\n";
while (!eof(IN1)) {
	$line = <IN1>;
	chomp $line;
	
	my @position = split(/	/, $line);
	if ($block == 0) {
		$block = $position[$key];
	}
	
	# Print package agreement at the end of a block
	if ($block != $position[$key]) {
		getBlockAgree();
		printAgreement();
		$block = $position[$key];
		$peathHap1 = "";
		$peathHap2 = "";
		$hapcutHap1 = "";
		$hapcutHap2 = "";
		$mixHap1 = "";
		$mixHap2 = "";
	}
	
	
	# Add genotype in current line
	$peathHap1 .= $position[$ph1];
	$peathHap2 .= $position[$ph2];
	$hapcutHap1 .= $position[$hh1];
	$hapcutHap2 .= $position[$hh2];
	$mixHap1 .= $position[$mh1];
	$mixHap2 .= $position[$mh2];
}

close $out;

# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
