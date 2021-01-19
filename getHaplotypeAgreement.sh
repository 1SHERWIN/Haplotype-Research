#!/bin/bash
# Bash script by Sherwin to calcuate pairwise agreement between phasing two packages

# copy haplotypes of shapeit2, whatshap, hapseq2, and dbm
cp snv/haplotypes/* compare/
cp whatshap/results/haplotypes/* compare/
cp hapseq2/results/individuals/* compare/
cp dbm/individuals/* compare/  
cd compare

# Paste each package into a single file 
paste dbm.genotype.sample1.chr10.txt hapseq2.genotype.sample1.chr10.txt whatshap.haplotype.sample1.chr10.txt shapeit2.haplotype.sample1.chr10.txt > R/sample1.dbm.hapseq2.whatshap.shapeit2.8col.txt
paste dbm.genotype.sample2.chr10.txt hapseq2.genotype.sample2.chr10.txt whatshap.haplotype.sample2.chr10.txt shapeit2.haplotype.sample2.chr10.txt > R/sample2.dbm.hapseq2.whatshap.shapeit2.8col.txt
paste dbm.genotype.sample3.chr10.txt hapseq2.genotype.sample3.chr10.txt whatshap.haplotype.sample3.chr10.txt shapeit2.haplotype.sample3.chr10.txt > R/sample3.dbm.hapseq2.whatshap.shapeit2.8col.txt

cd R
module load R/3.6.0  
time Rscript /home/s_m774/genome-phasing/getHaplotypeAgreement.r > output-R.txt

echo Pairwise agreement of Haplotype calculated for each package!
