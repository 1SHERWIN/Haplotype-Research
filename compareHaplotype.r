sample1<-read.table("10837.dbm.hapseq2.whatshap.6col.txt")
sample2<-read.table("10855.dbm.hapseq2.whatshap.6col.txt")
sample3<-read.table("12329.dbm.hapseq2.whatshap.6col.txt")
sample4<-read.table("12752.dbm.hapseq2.whatshap.6col.txt")
sample5<-read.table("12878.dbm.hapseq2.whatshap.6col.txt")

## DBM vs. HapSeq2
(sum(sample1[,1]==sample1[,3])+ sum(sample1[,2]==sample1[,4]))/2
(sum(sample1[,1]==sample1[,4])+ sum(sample1[,2]==sample1[,3]))/2

(sum(sample2[,1]==sample2[,3])+ sum(sample2[,2]==sample2[,4]))/2
(sum(sample2[,1]==sample2[,4])+ sum(sample2[,2]==sample2[,3]))/2

(sum(sample3[,1]==sample3[,3])+ sum(sample3[,2]==sample3[,4]))/2
(sum(sample3[,1]==sample3[,4])+ sum(sample3[,2]==sample3[,3]))/2

(sum(sample4[,1]==sample4[,3])+ sum(sample4[,2]==sample4[,4]))/2
(sum(sample4[,1]==sample4[,4])+ sum(sample4[,2]==sample4[,3]))/2

(sum(sample5[,1]==sample5[,3])+ sum(sample5[,2]==sample5[,4]))/2
(sum(sample5[,1]==sample5[,4])+ sum(sample5[,2]==sample5[,3]))/2


## DBM vs. Whatshap
(sum(as.character(sample1[,1])==as.character(sample1[,5]))+ sum(as.character(sample1[,2])== as.character(sample1[,6])))/2
(sum(as.character(sample1[,1])==as.character(sample1[,6]))+ sum(as.character(sample1[,2])== as.character(sample1[,5] )))/2

(sum(as.character(sample2[,1])==as.character(sample2[,5]))+ sum(as.character(sample2[,2])== as.character(sample2[,6])))/2
(sum(as.character(sample2[,1])==as.character(sample2[,6]))+ sum(as.character(sample2[,2])== as.character(sample2[,5] )))/2

(sum(as.character(sample3[,1])==as.character(sample3[,5]))+ sum(as.character(sample3[,2])== as.character(sample3[,6])))/2
(sum(as.character(sample3[,1])==as.character(sample3[,6]))+ sum(as.character(sample3[,2])== as.character(sample3[,5] )))/2

(sum(as.character(sample4[,1])==as.character(sample4[,5]))+ sum(as.character(sample4[,2])== as.character(sample4[,6])))/2
(sum(as.character(sample4[,1])==as.character(sample4[,6]))+ sum(as.character(sample4[,2])== as.character(sample4[,5] )))/2

(sum(as.character(sample5[,1])==as.character(sample5[,5]))+ sum(as.character(sample5[,2])== as.character(sample5[,6])))/2
(sum(as.character(sample5[,1])==as.character(sample5[,6]))+ sum(as.character(sample5[,2])== as.character(sample5[,5] )))/2


## HapSeq2 vs. Whatshap
(sum(as.character(sample1[,3])==as.character(sample1[,5]))+ sum(as.character(sample1[,4])== as.character(sample1[,6])))/2
(sum(as.character(sample1[,3])==as.character(sample1[,6]))+ sum(as.character(sample1[,4])== as.character(sample1[,5] )))/2

(sum(as.character(sample2[,3])==as.character(sample2[,5]))+ sum(as.character(sample2[,4])== as.character(sample2[,6])))/2
(sum(as.character(sample2[,3])==as.character(sample2[,6]))+ sum(as.character(sample2[,4])== as.character(sample2[,5] )))/2

(sum(as.character(sample3[,3])==as.character(sample3[,5]))+ sum(as.character(sample3[,4])== as.character(sample3[,6])))/2
(sum(as.character(sample3[,3])==as.character(sample3[,6]))+ sum(as.character(sample3[,4])== as.character(sample3[,5] )))/2

(sum(as.character(sample4[,3])==as.character(sample4[,5]))+ sum(as.character(sample4[,4])== as.character(sample4[,6])))/2
(sum(as.character(sample4[,3])==as.character(sample4[,6]))+ sum(as.character(sample4[,4])== as.character(sample4[,5] )))/2

(sum(as.character(sample5[,3])==as.character(sample5[,5]))+ sum(as.character(sample5[,4])== as.character(sample5[,6])))/2
(sum(as.character(sample5[,3])==as.character(sample5[,6]))+ sum(as.character(sample5[,4])== as.character(sample5[,5] )))/2


