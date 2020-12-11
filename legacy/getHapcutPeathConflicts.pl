# 2019 Fall
# Name: Sherwin Massoudian. NetID: s_m774 
# This program points the intersection of two haplotype packages
# perl /home/s_m774/software/perl/getHapcutPeathConflicts.pl hapcut2peath.txt output.txt
 
# hapcut2peath.txt has the columns hapcut.h1, hapcut.h2, peath.h1, peath.h2, peath.blk, chr, pos
# 0       1       1       0       1       chr10   69071
# 0       1       1       0       1       chr10   69083
# 0       1       1       0       2       chr10   76210
# 0       1       1       0       2       chr10   76294
# 0       1       1       0       3       chr10   77582
# 0       1       1       0       3       chr10   77585
# 0       1       1       0       4       chr10   80119
# 0       1       1       0       4       chr10   80124
# 0       1       1       0       5       chr10   82105
# 0       1       1       0       5       chr10   82115
# 1       0       1       0       6       chr10   94026
# 1       0       1       0       6       chr10   94083
# 1       0       1       0       6       chr10   94136
# 1       0       1       0       7       chr10   94870
# 1       0       1       0       7       chr10   94872
# 1       0       1       0       8       chr10   95226
# 1       0       1       0       8       chr10   95229
# 0       1       1       0       9       chr10   98407
# 0       1       1       0       9       chr10   99101

# Output will take each line that conflicts with its haplotype block
# -       -       1       0       65      chr10   368618
# 1       0       0       1       67      chr10   393257
# 1       0       0       1       67      chr10   393282
# -       -       0       1       67      chr10   393501
# 0       1       1       0       67      chr10   393577
# 1       0       0       1       67      chr10   393629
# 0       1       1       0       67      chr10   393669
# 0       1       1       0       67      chr10   393674
# 0       1       1       0       67      chr10   393824
# 0       1       1       0       67      chr10   393825
# 1       0       0       1       67      chr10   393831
# 0       1       1       0       67      chr10   393926
# 0       1       1       0       67      chr10   393992
# -       -       1       0       71      chr10   421182
# -       -       1       0       71      chr10   421231
# 0       1       1       0       89      chr10   463749
# 0       1       1       0       89      chr10   463750
# 0       1       1       0       89      chr10   463767
# -       -       1       0       114     chr10   570172



use strict; use warnings;

# Start timer
my $start = time();
my ($match, $halfmatch, $snps) = (0,0,0);


# Open IO files
open(IN1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $out, ">$ARGV[1]") or die "Error making $ARGV[1]\n";

my $block = 0;
my %map;

while (<IN1>) {
	
	chomp $_;
	
	my @line = split(/	/, $_);
	
	# Update map with each new block
	if ($block != $line[4] && $line[0] ne "-") {
		$block = $line[4];
		if ($line[0] == $line[2]) {
			$map{0} = 0;
			$map{1} = 1;
		}
		else {
			$map{0} = 1;
			$map{1} = 0;
		}		
	}
	
	
	# Get lines with missing haplotypes
	if ($line[0] eq "-") {
		print $out "$_\n";
	}
	
	else {
		if ($line[0] == 0 && $line[2] != $map{0}) {
			# print $out "0 is mapped to $map{0} on block $block\n";
			print $out "$_\n";
		}
		if ($line[0] == 1 && $line[2] != $map{1}) {
			# print $out "1 is mapped to $map{1} on block $block\n";
			print $out "$_\n";
		}
	}
}
	
# Display runtime
my $endTime = time();
my $runTime = $endTime - $start;
print "Job took $runTime seconds \n";
