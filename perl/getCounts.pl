# 7/14/2019
# Name: Sherwin Massoudian. NetID: s_m774 
# This program produces DBM input files
# perl getCounts.pl sample.snps 826.pos test.counts

# This perl code is used to generate a DBM input file from the following unix command
# Unix script:
# join -j1 -o1.2,2.4,2.5 <(<sample.snps awk '{print $3"\t"$0}' | sort -k1,1) <(<826.pos awk '{print $2"\t"$0}' | sort -k1,1) | sort -n | sed 's/^/M /' | sed "s/ /\t/g" > 826.counts


# testing folder: /home/s_m774/project/data/dbm/7.14

# Input file 1: 
# sample.snps is an input file with the "key" (ID, chr, pos, quality), that is the position 
# from ALL samples (e.g, 826, 827, 832), each of these the positions will show up in at least one sample.  
# more sample.snps
# 1 chr10
# 1233561 100
# 2 chr10
# 3010999 100


# Input file 2: 
# 826.pos is an input file with chr, pos, ref.count, alter.count, ref.allele, alt.allele, quality of this snp
# more 826.pos
# chr10 587617
# 0 1  C A 7.79993
# chr10 1101983
# 0 1  C T 7.79993
# chr10 1132778
# 0 1  C A 7.79993

# output file: test.counts with columns: M, ID, ref.count, altnative.count
# more test.counts
# M 1  0 15
# M 2  0 10

# Number of lines in each input and output files:
# 246 sample.snps
# 96 826.pos
# 246 test.counts


use strict; use warnings;

# Start timer
my $start = time();

# Open IO files
open(my $in1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $in2, "<$ARGV[1]") or die "Error reading $ARGV[1]\n";
open(my $counts, ">$ARGV[2]") or die "Error creating $ARGV[2]\n";
# open(my $keyFile, ">key.txt") or die "Error creating key.txt\n";
# open(my $input, ">input.txt") or die "Error creating input.txt\n";

# Create hash tables
my (%hash1, %hash2, %intersect);
my($key, $data);

# Create keys.txt
while (<$in1>) {
	
	# Remove \n
	chomp();
	
	# Split each sample.key row into array with fields ID, CHR, POS, QUALITY
	my @fields = split(/\t/, $_);
	my $key = $fields[2];
	$hash1{$key} = $_;
}

# foreach (sort {$a <=> $b} keys %hash1) {
	# print $keyFile "$_\t$hash1{$_}\n";
# }

# Create input.txt
while (<$in2>) {
	
	# Remove \n
	chomp();
	
	# Split each individual.pos row into an array with fields CHR, POS, REFERENCE #, ALTERNATE #, QUALITY, REFERENCE, ALTERNATE
	my @fields = split(/\t/, $_);
	my $key = $fields[1];
	$hash2{$key} = $_;
}

# foreach (sort {$a <=> $b} keys %hash2) {
	# print $input "$_\t$hash2{$_}\n";
# }

# Find intersect 
# Split to array to print ID, reference, alternate fields
foreach (keys %hash1) {
	my @fields = split(/\t/, $hash1{$_});
	my $key = $fields[0];
	if (exists $hash2{$_}) {
		my @fields2 = split(/\t/, $hash2{$_});
		$intersect{$key} = "$fields2[2]\t$fields2[3]";
	}
	else {
		$intersect{$key} = "0\t0";
	}
}	

# Need to sort keys numerically
foreach (sort {$a<=>$b} keys %intersect) {
	print $counts "M\t$_\t$intersect{$_}\n";
}


# Close IO files
close $in1;
close $in2;
close $counts;
# close $keyFile;
# close $input;



# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";