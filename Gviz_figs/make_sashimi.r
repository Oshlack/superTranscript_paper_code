########################################################################
############################# Author: Anthony Hawkins ##################
# Description: A script to produce Fig1.c(Top), sashimi plot based on  #
# reads mapped to both the reference and superTranscript with the      #
# alternate block annotations below                                    #
########################################################################

library(Gviz)
#Turn off default chromsome names since we are utilising the superTranscript rather than reference
options(ucscChromosomeNames=FALSE)

#Create a GViz track for the STAR aligned reads to the superTranscript using a sorted BAM file
alTrack <- AlignmentsTrack("SRR493366Aligned.sortedByCoord.out.bam",isPaired=T,size=0.05,background.title ="#042E8A",col="#042E8A",fill="#042E8A",fontsize=16)

#Create a GViz track showing how the annotated transcripts sit on the superTranscript
grtrack <- GeneRegionTrack("/group/bioi1/shared/projects/superTranscript/reference_generation/human_super_reference.overlap_removed.gtf",chromsome="ENSG00000160072",name="Annotated Transcripts",transcriptAnnotation="transcript",size=0.4,col="black",fontsize=16)

#Create a GViz track showing how the annotated blocks look like on the superTranscript
grttrack2 <- GeneRegionTrack("human_super_reference.overlap_removed.flattened.gtf",chromsome="ENSG00000160072",name="Annotated Blocks",background.title="#00BA38",fill="#00BA38",col="black",fontsize=13)

#Create a GViz track showing how the dynamic blocks look like on the superTranscript
splicetrack <- GeneRegionTrack("Spliced.gtf",chromsome="ENSG00000160072",name="Dynamic Blocks",col="black",background.title ="#619CFF",fill="#619CFF",fontsize=13)

#Create a GenomeAxisTrack displaying the size of the genomic region porrayed in figure
gtrack <- GenomeAxisTrack()

#Open the R pdf saving functions
pdf('sashimi.pdf',width=15,height=6)

#Plot the various track created in order of list, zooming in on a specific genomic for gene ENSG00000160072, plotting both the coverage and sashimi plot
plotTracks(list(gtrack,alTrack,grtrack,grttrack2,splicetrack),from=3000,to=6500,chromosome="ENSG00000160072",type=c("coverage","sashimi"))
dev.off() #Clost pdf after plotting
