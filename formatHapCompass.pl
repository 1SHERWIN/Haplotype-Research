# 2019 Fall
# Name: Sherwin Massoudian. NetID: s_m774 
# This program formats the HapCompass output
# perl /home/s_m774/software/perl/formatHapCompass.pl input.txt output.txt

# input file input.txt
# BLOCK   5073543 5073662 10      11      6.0     chr10
# VAR_POS_5073543 5073543 10      1       0
# VAR_POS_5073662 5073662 11      0       1

# BLOCK   11169665        11169807        19      21      2.0     chr10
# VAR_POS_11169665        11169665        19      1       0
# VAR_POS_11169710        11169710        20      0       1
# VAR_POS_11169807        11169807        21      0       1

# BLOCK   25466803        25466872        34      35      1.0     chr10
# VAR_POS_25466803        25466803        34      0       1
# VAR_POS_25466872        25466872        35      0       1

# BLOCK   29602531        29602536        41      42      3.0     chr10
# VAR_POS_29602531        29602531        41      0       1
# VAR_POS_29602536        29602536        42      0       1



# output file output.txt
# VAR_POS_5073543 5073543 10      1       0	BLOCK   5073543 5073662 10      11      6.0     chr10
# VAR_POS_5073662 5073662 11      0       1	BLOCK   5073543 5073662 10      11      6.0     chr10


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
	if (@fields){
		if ("BLOCK" eq substr($fields[0],0,5)){
		$block = $_;
		$blockCount++;
		}
		
		if ("VAR_POS" eq substr($fields[0],0,7)){
			print $out "$_\t$blockCount\t$block\n";
		}	
	}
}


# Close IO files
close $in1;
close $out;



# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
