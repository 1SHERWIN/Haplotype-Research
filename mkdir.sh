#!/bin/bash
# A sample Bash script by Sherwin to create directory for three phasing packages

mkdir snv
mkdir whatshap
mkdir whatshap/results
mkdir whatshap/results/haplotypes
mkdir whatshap/results/individuals
mkdir hapseq2
mkdir hapseq2/parsed
mkdir hapseq2/bams
mkdir hapseq2/results
mkdir hapseq2/results/individuals
mkdir dbm
mkdir dbm/individuals
mkdir compare
mkdir compare/R

# Reference genome and index
cp /group/hon/hon3398o/0.course.files/Data/Reference/hg38/chroms/chr10.fa ./
cp /home/s_m774/1000GenomeData/chr10.fa.fai ./
cp chr10.fa whatshap
cp chr10.fa.fai whatshap

# bcftools version 1.9
cp /group/hon/hon3398o/0.course.files/software/bcftools-1.9/bcftools ./

# script to get haplotypes from vcf
cp /home/s_m774/Haplotype-Research/getHaplotype.pl ./whatshap/results/
cp /home/s_m774/Haplotype-Research/getAlleles.pl ./whatshap/results/

# script to prepare Hapseq2 input
cp /home/s_m774/software/HapSeq2/bam_parser ./hapseq2

# script to run a parwise comparison of haplotypes
cp /home/s_m774/Haplotype-Research/compareHaplotype.r ./compare/R 

echo Directories created for three phasing packages!
