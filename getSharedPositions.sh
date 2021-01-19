#!/bin/bash
# A sample Bash script by Sherwin to get the shared positons of two VCF files

cp shapeit2/shapeit2.chr10.hg38.NA12873.NA12874.NA12878.vcf snv/
cd snv

# make sure both files are indexed and in bgzip format 
bgzip shapeit2.chr10.hg38.NA12873.NA12874.NA12878.vcf; bgzip bcftools.chr10.hg38.NA12873.NA12874.NA12878.vcf;
../bcftools index shapeit2.chr10.hg38.NA12873.NA12874.NA12878.vcf.gz; ../bcftools index bcftools.chr10.hg38.NA12873.NA12874.NA12878.vcf.gz;  

# bcftools isec manual -n found in both files -c match chrom,pos,ref,alt
# https://samtools.github.io/bcftools/bcftools.html#isec

../bcftools isec -n=2 -c all shapeit2.chr10.hg38.NA12873.NA12874.NA12878.vcf.gz bcftools.chr10.hg38.NA12873.NA12874.NA12878.vcf.gz > sharedPositions.txt

# filter vcf files for the overlapping positions
../bcftools view -T sharedPositions.txt shapeit2.chr10.hg38.NA12873.NA12874.NA12878.vcf.gz > sharedPositions.shapeit2.chr10.hg38.3sample.vcf;
../bcftools view -T sharedPositions.txt bcftools.chr10.hg38.NA12873.NA12874.NA12878.vcf.gz > sharedPositions.bcftools.chr10.hg38.3sample.vcf;

mkdir haplotypes

# Shapit2: Split each sample to columns POS REF ALT HAP
grep -ve '#' sharedPositions.shapeit2.chr10.hg38.3sample.vcf | cut -f 2,4,5,10| sed s/:/\\t/g | awk '{print $1"\t"$4"\t"$2"\t"$3}' | sed s/,/\\t/g | awk '{print $1"\t"$3"\t"$4"\t"$2}'  > binary.sample1.chr10.shapeit2.txt
grep -ve '#' sharedPositions.shapeit2.chr10.hg38.3sample.vcf | cut -f 2,4,5,11| sed s/:/\\t/g | awk '{print $1"\t"$4"\t"$2"\t"$3}' | sed s/,/\\t/g | awk '{print $1"\t"$3"\t"$4"\t"$2}'  > binary.sample2.chr10.shapeit2.txt
grep -ve '#' sharedPositions.shapeit2.chr10.hg38.3sample.vcf | cut -f 2,4,5,12| sed s/:/\\t/g | awk '{print $1"\t"$4"\t"$2"\t"$3}' | sed s/,/\\t/g | awk '{print $1"\t"$3"\t"$4"\t"$2}'  > binary.sample3.chr10.shapeit2.txt

# Several positions had 2 alternate alleles 
# I handled this using the last 2 pipes to select the first alt

perl /home/s_m774/genome-phasing/getHaplotype.pl binary.sample1.chr10.shapeit2.txt haplotypes/shapeit2.haplotype.sample1.chr10.txt
perl /home/s_m774/genome-phasing/getHaplotype.pl binary.sample2.chr10.shapeit2.txt haplotypes/shapeit2.haplotype.sample2.chr10.txt
perl /home/s_m774/genome-phasing/getHaplotype.pl binary.sample3.chr10.shapeit2.txt haplotypes/shapeit2.haplotype.sample3.chr10.txt

echo Intersect of both VCF files created!
