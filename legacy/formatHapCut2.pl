# 2019 Fall
# Name: Sherwin Massoudian. NetID: s_m774 
# This program formats the PEATH output
# perl /home/s_m774/software/perl/formatHapCut2.pl input.txt output.txt

# input file input.txt
# BLOCK: offset: 53 len: 2 phased: 2 SPAN: 119 fragments 6
# 53      1       0       chr10   5073543 C       T       0/1:166,0,45    0       .       100.00
# 54      0       1       chr10   5073662 T       C       0/1:255,0,255   0       .       100.00
# ********
# BLOCK: offset: 84 len: 3 phased: 3 SPAN: 142 fragments 2
# 84      1       0       chr10   11169665        C       A       0/1:33,3,0      0       .       32.03
# 85      0       1       chr10   11169710        A       G       0/1:103,0,20    0       .       33.81
# 86      0       1       chr10   11169807        T       A       0/1:31,0,57     0       .       65.61
# ********
# BLOCK: offset: 177 len: 2 phased: 2 SPAN: 5 fragments 3
# 177     0       1       chr10   29602531        C       G       0/1:31,0,62     0       .       100.00
# 178     0       1       chr10   29602536        T       G       0/1:31,0,55     0       .       100.00
# ********
# BLOCK: offset: 180 len: 2 phased: 2 SPAN: 1 fragments 2
# 180     1       0       chr10   29919349        T       C       0/1:32,0,32     0       .       71.64
# 181     1       0       chr10   29919350        G       T       0/1:32,0,32     0       .       71.64
# ********



# output file output.txt
# 53      1       0       chr10   5073543 C       T       0/1:166,0,45    0       .       100.00	BLOCK: offset: 53 len: 2 phased: 2 SPAN: 119 fragments 6
# 54      0       1       chr10   5073662 T       C       0/1:255,0,255   0       .       100.00	BLOCK: offset: 53 len: 2 phased: 2 SPAN: 119 fragments 6


use strict; use warnings;

# Start timer
my $start = time();

# Open IO files
open(my $in1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $out, ">$ARGV[1]") or die "Error creating >$ARGV[1]\n";

my $block;
my $blockCount;

# Append block information to each haplotype row
while (<$in1>) {
	
	# Remove \n
	chomp();
	
	# Split each row into an array
	my @fields = split(/\t/, $_);
	if ("BLOCK" eq substr($fields[0],0,5)){
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
