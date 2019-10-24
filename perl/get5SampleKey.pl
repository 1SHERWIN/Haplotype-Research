# 2019 Fall
# Name: Sherwin Massoudian. NetID: s_m774 
# This program produces DBM input SNP file
# perl /home/s_m774/software/DBM/perl/get5SampleKey.pl 826chr10.pos 827chr10.pos 832chr10.pos 847chr10.pos 850chr10.pos 1

# testing folder: /home/s_m774/project/data/dbm
 
# input file 826.pos with chr, pos, ref.count, alter.count, ref.allele, alt.allele, quality
# chr10   1166555 0       2       T       C       30.768
# chr10   1182970 0       5       A       G       117.264
# chr10   1183608 1       1       C       T       4.76933

# output file test.snps has fields ID, CHR, POS, Quality, Ref, Alt
# 1       chr10   1183608 100
# 2       chr10   1185028 100
# 3       chr10   1199953 100
# 4       chr10   1233561 100
# 5       chr10   1737155 100

use strict; use warnings;

# Start timer
my $start = time();

# Open IO files
open(my $in1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $in2, "<$ARGV[1]") or die "Error reading $ARGV[1]\n";
open(my $in3, "<$ARGV[2]") or die "Error reading $ARGV[2]\n";
open(my $in4, "<$ARGV[3]") or die "Error reading $ARGV[3]\n";
open(my $in5, "<$ARGV[4]") or die "Error reading $ARGV[4]\n";
open(my $snps, ">sample.snps") or die "Error creating $2sample.snps\n";
my $MinNumSample = $ARGV[5];

if (not defined $MinNumSample) {
  die "Need minimum number of samples\n";
}

# Create hash tables
my (%hash1, %hash2, %hash3, %hash4, %hash5, %union);
my($key, $data);

# Convert each input to a hash table, the key will be positon on chrom , union will have every SNP
while (<$in1>) {
	
	# Remove \n
	chomp();
	
	# Split each row into array with fields chr, pos, ref.count, alter.count, ref.allele, alt.allele, quality
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash1{$key} = 0;
	$union{$key} = [@fields];
}

while (<$in2>) {

	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash2{$key} = 0;
	if (exists $union{$key}) {
		$union{$key}[6] += $fields[6];
	}
	else {
		$union{$key} = [@fields];
	}
	
}

while (<$in3>) {

	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash3{$key} = 0;
	if (exists $union{$key}) {
		$union{$key}[6] += $fields[6];
	}
	else {
		$union{$key} = [@fields];
	}
	
}

while (<$in4>) {

	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash4{$key} = 0;
	if (exists $union{$key}) {
		$union{$key}[6] += $fields[6];
	}
	else {
		$union{$key} = [@fields];
	}
	
}

while (<$in5>) {

	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash5{$key} = 0;
	if (exists $union{$key}) {
		$union{$key}[6] += $fields[6];
	}
	else {
		$union{$key} = [@fields];
	}
	
}

# Print SNPs
my $id = 0;
my $counter = 0;

foreach (sort {$a<=>$b} keys %union) {
	if (exists $hash1{$_}) {
		$counter++;
	}
	if (exists $hash2{$_}) {
		$counter++;
	}
	if (exists $hash3{$_}) {
		$counter++;
	}
	if (exists $hash4{$_}) {
		$counter++;
	}
	if (exists $hash5{$_}) {
		$counter++;
	}
	if ($counter >= $MinNumSample) {
		$id++;
		$union{$_}[6] /= $counter;
		print $snps "$id\t$union{$_}[0]\t$union{$_}[1]\t$union{$_}[6]\t$union{$_}[4]\t$union{$_}[5]\n";
	}
	$counter = 0;
}	


# Close IO files
close $in1;
close $in2;
close $in3;
close $in4;
close $in5;
close $snps;



# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
