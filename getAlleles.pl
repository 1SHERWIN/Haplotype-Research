# getAlleles.pl
# Sherwin Massoudian
# converts 0|1 to alleles (ATCG)
# perl getAlleles.pl 

# 1st argument has the 4 columns pos, ref, alt, haplotype
# 11169710        A       G       1|0
# 12702337        C       G       0/1
# 12702503        A       G       1/1
# 12702514        A       T       1/1
# 14436463        A       G       0/1

# 2nd argument is the output

# output has 2 columns allele 1 and allele 2
# A   G
# G   C


# Open IO files
use strict; use warnings;
open(my $in1, "<$ARGV[0]") or die "Error reading $ARGV[0]\n";
open(my $out, ">$ARGV[1]") or die "Error creating $ARGV[1]\n";

# Create keys.txt
my $ref = "";
my $alt = "";
my $haplotype = "";
	
sub printAllele() {
	if ($haplotype eq "0|0" || $haplotype eq "0/0") {
		print $out "$ref\t$ref\n";
	}
	elsif ($haplotype eq "1|1" || $haplotype eq "1/1") {
		print $out "$alt\t$alt\n";
	}
	elsif ($haplotype eq "0|1") {
		print $out "$ref\t$alt\n";
	}
	elsif ($haplotype eq "1|0") {
		print $out "$alt\t$ref\n";
	}
	else {
		print $out "-\t-\n";
	}
}
while (<$in1>) {
	
	# Remove \n
	chomp();
	
	# Split each sample.key row into array with fields ID, CHR, POS, QUALITY
	my @snv = split(/\t/, $_);
	$ref = $snv[1];
	$alt = $snv[2];
	$haplotype = $snv[3];
	printAllele;
}

# Close IO files
close $in1;
close $out;