# 2019 Fall
# Name: Sherwin Massoudian. NetID: s_m774 
# This program formats the PEATH output
# perl /home/s_m774/software/perl/formatPEATH.pl input.txt output.txt

# input file 826chr10peath.txt
# Block Number: 1  Block Length: 2  Phased Length: 2  Number of Reads: 6  Start position: 53  Weighted MEC: 0.00840427  MEC: 0
# 53       0       1
# 54       1       0
# ********
# Block Number: 2  Block Length: 3  Phased Length: 3  Number of Reads: 2  Start position: 84  Weighted MEC: 0.00104331  MEC: 0
# 84       0       1
# 85       1       0
# 86       1       0
# ********


# output file output.txt
# 53       0       1	Block Number: 1  Block Length: 2  Phased Length: 2  Number of Reads: 6  Start position: 53  Weighted MEC: 0.00840427  MEC: 0
# 54       1       0	Block Number: 1  Block Length: 2  Phased Length: 2  Number of Reads: 6  Start position: 53  Weighted MEC: 0.00840427  MEC: 0


use strict; use warnings;

# Start timer
my $start = time();

# Open IO files
open(my $in1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $out, ">$ARGV[1]") or die "Error creating >$ARGV[1]\n";

my $block;
my $blockCount = 0;

# Append block information to each haplotype row
while (<$in1>) {
	
	# Remove \n
	chomp();
	
	# Split each row into an array
	my @fields = split(/\t/, $_);
	if ("Block" eq substr($fields[0],0,5)){
		$block = $_;
		$blockCount++;
	}
	
	if (substr($fields[0],0,1) =~ m/[0-9.]/){
		print $out "$_\t$blockCount\t$block\n";
	}
	
}


# Close IO files
close $in1;
close $out;



# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
