sample1<-read.table("sample1.dbm.hapseq2.whatshap.shapeit2.8col.txt")
sample2<-read.table("sample2.dbm.hapseq2.whatshap.shapeit2.8col.txt")
sample3<-read.table("sample3.dbm.hapseq2.whatshap.shapeit2.8col.txt")

print("Shapeit2 vs Whatshap")
A = (sum(as.character(sample1[,7])==as.character(sample1[,5]))+ sum(as.character(sample1[,8])== as.character(sample1[,6])))/2;
B = (sum(as.character(sample1[,7])==as.character(sample1[,6]))+ sum(as.character(sample1[,8])== as.character(sample1[,5])))/2;
print(paste("Sample 1:",max(A, B)));

A = (sum(as.character(sample2[,7])==as.character(sample2[,5]))+ sum(as.character(sample2[,8])== as.character(sample2[,6])))/2;
B = (sum(as.character(sample2[,7])==as.character(sample2[,6]))+ sum(as.character(sample2[,8])== as.character(sample2[,5])))/2;
print(paste("Sample 2:",max(A, B)));

A = (sum(as.character(sample3[,7])==as.character(sample3[,5]))+ sum(as.character(sample3[,8])== as.character(sample3[,6])))/2;
B = (sum(as.character(sample3[,7])==as.character(sample3[,6]))+ sum(as.character(sample3[,8])== as.character(sample3[,5])))/2;
print(paste("Sample 3:",max(A, B)));

print("Shapeit2 vs HapSeq2")
C = (sum(as.character(sample1[,3])==as.character(sample1[,7]))+ sum(as.character(sample1[,4])== as.character(sample1[,8])))/2;
D = (sum(as.character(sample1[,3])==as.character(sample1[,8]))+ sum(as.character(sample1[,4])== as.character(sample1[,7])))/2;
print(paste("Sample 1:",max(C, D)));

C = (sum(as.character(sample2[,3])==as.character(sample2[,7]))+ sum(as.character(sample2[,4])== as.character(sample2[,8])))/2;
D = (sum(as.character(sample2[,3])==as.character(sample2[,8]))+ sum(as.character(sample2[,4])== as.character(sample2[,7])))/2;
print(paste("Sample 2:",max(C, D)));

C = (sum(as.character(sample3[,3])==as.character(sample3[,7]))+ sum(as.character(sample3[,4])== as.character(sample3[,8])))/2;
D = (sum(as.character(sample3[,3])==as.character(sample3[,8]))+ sum(as.character(sample3[,4])== as.character(sample3[,7])))/2;
print(paste("Sample 3:",max(C, D)));

print("Shapeit2 vs DBM")
E = (sum(as.character(sample1[,1])==as.character(sample1[,7]))+ sum(as.character(sample1[,2])== as.character(sample1[,8])))/2;
F = (sum(as.character(sample1[,1])==as.character(sample1[,8]))+ sum(as.character(sample1[,2])== as.character(sample1[,7])))/2;
print(paste("Sample 1:",max(E, F)));

E = (sum(as.character(sample2[,1])==as.character(sample2[,7]))+ sum(as.character(sample2[,2])== as.character(sample2[,8])))/2;
F = (sum(as.character(sample2[,1])==as.character(sample2[,8]))+ sum(as.character(sample2[,2])== as.character(sample2[,7])))/2;
print(paste("Sample 2:",max(E, F)));

E = (sum(as.character(sample3[,1])==as.character(sample3[,7]))+ sum(as.character(sample3[,2])== as.character(sample3[,8])))/2;
F = (sum(as.character(sample3[,1])==as.character(sample3[,8]))+ sum(as.character(sample3[,2])== as.character(sample3[,7])))/2;
print(paste("Sample 3:",max(E, F)));
