########################################################################
############################# Author: Anthony Hawkins ##################
# Description: A script to produce Fig2.a(Top) the coverage of aligned #
# reads to the reference genome.				       #
########################################################################

library(Gviz)

#Create a GViz track for the STAR aligned reads to the genome using a sorted BAM file
alTrack <- AlignmentsTrack("Sorted/SRR493366Aligned.sortedByCoord.out.bam",isPaired=T,background.title ="#042E8A",col="#042E8A",fill="#042E8A",size=0.04,fontsize=16,showTitle=FALSE)

#Create a GViz track showing how the annotated transcripts sit in the genome
grtrack <- GeneRegionTrack("/group/bioi1/shared/genomes/hg19/star/hg19_gencodeV19_comp.gtf",chromsome="16",name="Transcripts",transcriptAnnotation="transcript",size=0.5,background.title ="#619CFF",fill="#619CFF",col="black",fontsize=16)

#Create a GenomeAxisTrack displaying the size of the genomic region porrayed in figure
gtrack <- GenomeAxisTrack()

#Open the R pdf saving functions
pdf('coverage_ref.pdf',width=15,height=6)

#Plot the various track created in order of list, zooming in on a specific genomic range for chromosome 16
plotTracks(list(gtrack,alTrack,grtrack),from=67062000,to=67135000,chromosome="16",type=c("coverage"))
dev.off() #Clost pdf after plotting
