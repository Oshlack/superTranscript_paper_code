########################################################################
################ Author: Anthony Hawkins, Nadia Davidson ###############
# Description: A script to extract differential exon usage from 
# a counts matrix using DEXseq. 
########################################################################

#First get counts table
counts <- read.table("counts.txt",sep="\t",header=TRUE,stringsAsFactors=F,row.names=1)

if(dim(counts)[2]==11) # featureCounts methods
{
    clusters<-counts[,2]
    counts<-counts[,6:11]
} else { ## inference methods 
  ## Load the clusters
  clusters<-read.delim("genes.txt",header=F,stringsAsFactors=F)[,2]
  names(clusters)<-read.delim("genes.txt",header=F,stringsAsFactors=F)[,1]
  counts<-counts[row.names(counts) %in% names(clusters),]
  clusters=clusters[row.names(counts)]
}

#Convert to integer (since we use a fractinal counting in featureCounts)
cc <- data.matrix(counts)
cc = round(cc)

#each exon needs a unique name, may as well just use the row names as something generic
exon_ids = row.names(counts)

library(DEXSeq)

#DexSeq requires a table with information about the samples as well as the raw counts for each exon in each sample
#And grouping information for which exons belong to which genes/clusters
sample_table <- data.frame(sample = 1:6, condition = c('c1','c1','c1','c2','c2','c2'))
dxd <- DEXSeqDataSet(cc,design=~sample + exon + condition:exon, featureID=as.factor(exon_ids),
                     groupID=as.factor(clusters),sampleData=sample_table)
##Estimate size factors and dispersions (DEXseq does this based on a negative bionmial distribution
dxd <- estimateSizeFactors(dxd)
dxd <- estimateDispersions(dxd)


#Test for DEU
dxd <- testForDEU(dxd)

#Extract the results
res <- DEXSeqResults(dxd)

#Get p-value per gene based on the p-values for all exons in the gene/cluster
pgq <- perGeneQValue(res, p = "pvalue")

## Save results to a text file and R object
save(dxd, res, pgq, file = "DEXY.Rdata")
tmp <- cbind(gene = names(pgq), "adjP" = pgq)
write.table(tmp, file = "DEXY.txt", col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t")