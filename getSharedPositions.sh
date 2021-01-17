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

echo Intersect of both VCF files created!
