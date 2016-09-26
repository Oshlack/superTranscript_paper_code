#First get counts table
counts <- read.table("counts.txt",sep="\t",header=TRUE)

#Convert to integer
cc <- data.matrix(counts[,c(7:12)])
cc = round(cc)

exon_ids = row.names(counts)
library(DEXSeq)
sample_table <- data.frame(sample = 1:6, condition = c('c1','c1','c1','c2','c2','c2'))
dxd <- DEXSeqDataSet(cc,design=~sample + exon + condition:exon, featureID=as.factor(exon_ids),
                     groupID=as.factor(counts[,1]),sampleData=sample_table)
##Estimate size factors and dispersions
dxd <- estimateSizeFactors(dxd)
dxd <- estimateDispersions(dxd)
dxd <- testForDEU(dxd)
res <- DEXSeqResults(dxd)
pgq <- perGeneQValue(res, p = "pvalue")

## Save results
save(dxd, res, pgq, file = "DEXY.Rdata")
tmp <- cbind(gene = names(pgq), "adjP" = pgq)
write.table(tmp, file = "DEXY.txt", col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t")
