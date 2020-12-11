# 2019 Fall	
# Name: Sherwin Massoudian. NetID: s_m774 
# This program extracts quality scores
# perl /home/s_m774/software/DBM/perl/get5SampleQuality.pl 826chr10.pos 827chr10.pos 832chr10.pos 847chr10.pos 850chr10.pos 1

# testing folder: /home/s_m774/project/data/dbm
 
# input file 826.pos with chr, pos, ref.count, alter.count, ref.allele, alt.allele, quality
# chr10   1166555 0       2       T       C       30.768
# chr10   1182970 0       5       A       G       117.264
# chr10   1183608 1       1       C       T       4.76933

# output file quality.txt has fields CHR, POS, Quality
# chr10   1233561 185.999 31.0104 109.008 NA      221.999
# chr10   3010999 180.999 180.999 212.999 163.003 194.999
# chr10   3011174 221.999 221.999 225.009 221.999 221.999
# chr10   5073699 221.999 221.999 221.999 221.999 225.009
# chr10   5073715 221.999 221.999 221.999 225.009 221.999


use strict; use warnings;

# Start timer
my $start = time();

# Open IO files
open(my $in1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $in2, "<$ARGV[1]") or die "Error reading $ARGV[1]\n";
open(my $in3, "<$ARGV[2]") or die "Error reading $ARGV[2]\n";
open(my $in4, "<$ARGV[3]") or die "Error reading $ARGV[3]\n";
open(my $in5, "<$ARGV[4]") or die "Error reading $ARGV[4]\n";
# open(my $snps, ">$ARGV[5]") or die "Error creating $ARGV[5]\n";
open(my $snps, '>', 'quality.txt');
my $MinNumSample = $ARGV[5];


# Create hash tables
my (%hash1, %hash2, %hash3, %hash4, %hash5, %union);
my($key, $data);

# Convert each input to a hash table, position is the key, union will have every position
while (<$in1>) {
	
	# Remove \n
	chomp();
	
	# Split each row into array with fields chr, pos, ref.count, alter.count, ref.allele, alt.allele, quality
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash1{$key} = $fields[6];
	$union{$key} = $chromosome;
}

while (<$in2>) {

	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash2{$key} = $fields[6];
	if (!(exists $union{$key})) {
		$union{$key} = $chromosome;
	}
	
}

while (<$in3>) {
	
	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash3{$key} = $fields[6];
	if (!(exists $union{$key})) {
		$union{$key} = $chromosome;
	}
}

while (<$in4>) {
	
	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash4{$key} = $fields[6];
	if (!(exists $union{$key})) {
		$union{$key} = $chromosome;
	}
}

while (<$in5>) {
	
	chomp();
	
	my @fields = split(/\t/, $_);
	my $chromosome = $fields[0];
	my $key = $fields[1];
	$hash5{$key} = $fields[6];
	if (!(exists $union{$key})) {
		$union{$key} = $chromosome;
	}
}

# Print Quality Scores
my ($q1,$q2,$q3,$q4,$q5);
my $chr = "chr10";
my $counter = 0;

foreach (sort {$a<=>$b} keys %union) {
	if (exists $hash1{$_}) {
		$counter++;
		$q1 = $hash1{$_};
	}
	else {
		$q1 = "NA";
	}
	if (exists $hash2{$_}) {
		$counter++;
		$q2 = $hash2{$_};
	}
	else {
		$q2 = "NA";
	}
	if (exists $hash3{$_}) {
		$counter++;
		$q3 = $hash3{$_};
	}
	else {
		$q3 = "NA";
	}
	if (exists $hash4{$_})  {
		$counter++;
		$q4 = $hash4{$_};
	}
	else {
		$q4 = "NA";
	}
	if (exists $hash5{$_})  {
		$counter++;
		$q5 = $hash5{$_};
	}
	else {
		$q5 = "NA";
	}
	if ($counter >= $MinNumSample) {
		print $snps "$union{$_}\t$_\t$q1\t$q2\t$q3\t$q4\t$q5\n";
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
# close $keyFile;
# close $input;



# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
