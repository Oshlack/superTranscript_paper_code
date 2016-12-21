
##### inputs
tc_psl_file="trinity.chicken.psl"
ch_psl_file="chicken.human.psl"
th_psl_file="trinity.human.psl"

##### output
out_file="clusters.txt"

####################################################
## Cluster the contigs with chicken reference genes
####################################################

tc_psl=unique(read.delim(tc_psl_file,skip=5,stringsAsFactors=F,header=F)[,c(10,14)])

#each gene starts as a cluster
gene_clusters<-1:length(unique(tc_psl$V14))
names(gene_clusters)<-unique(tc_psl$V14)

#work out when a contig matches two or more genes
c_split=split(tc_psl$V14,tc_psl$V10)
#remove contigs that match multiple genes (these are possible chimeras)
c_split=c_split[sapply(c_split,length)==1]

contig_clusters=gene_clusters[unlist(c_split)]
gene_clusters=gene_clusters[unique(names(contig_clusters))]
names(contig_clusters)<-names(unlist(c_split))

clusters=c(gene_clusters,contig_clusters)
clusters=sort(clusters)

#################################################################
## Cluster the rest of the contigs using alignment against human
#################################################################

### Now load in the blat results for human-chicken reference
ch_blat_tab=read.delim(ch_psl_file,stringsAsFactors=F,header=F,skip=5)
human_genes_in_chicken=unique(ch_blat_tab$V14)

### Now load in the blat results for human-trinity
th_blat_tab=read.delim(th_psl_file,stringsAsFactors=F,header=F,skip=5)
## Remove contigs that are already allocated to a gene
th_blat_tab=th_blat_tab[!th_blat_tab$V10 %in% unique(tc_psl$V10),]

## Split by contig
spsl=split(th_blat_tab,th_blat_tab$V10)

## Remove any that match a gene already in the chicken genome
in_genome=split(th_blat_tab$V14 %in% human_genes_in_chicken,th_blat_tab$V10)
novel_gene=!sapply(in_genome,any)
spsl=spsl[novel_gene]

#remove any that match more than one gene
best=sapply(spsl,function(x){unique(x$V14)})
best_unique=best[sapply(best,length)==1]

#sort and add to cluster list
clusters=c(clusters,sort(unlist(best_unique)))

###############################################################
# Add in clusters for reference genes with no trinity assembly
###############################################################

all_ref=read.delim("ref_list.txt",stringsAsFactors=F,header=F)[,1]
no_assembly=all_ref[!all_ref %in% names(clusters)]
names(no_assembly)=no_assembly
clusters=c(clusters,no_assembly)

write.table(clusters,out_file,quote=F,sep="\t",col.names=F)
