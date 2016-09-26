########################################################################
############################# Author: Anthony Hawkins ##################
# Description: A script to produce Fig2.a(Bot) the coverage of aligned #
# reads to the superTranscript.                                        #
########################################################################

library(Gviz)
#Turn off default chromsome names since we are utilising the superTranscript rather than reference
options(ucscChromosomeNames=FALSE)

#Create a GViz track for the STAR aligned reads to the superTranscript using a sorted BAM file
alTrack <- AlignmentsTrack("SRR493366Aligned.sortedByCoord.out.bam",isPaired=T,size=0.01,background.title ="#042E8A",col="#042E8A",fill="#042E8A",fontsize=16,showTitle=FALSE)

#Create a GViz track showing how the annotated transcripts sit on the superTranscript
grtrack <- GeneRegionTrack("/group/bioi1/shared/projects/superTranscript/reference_generation/human_super_reference.overlap_removed.gtf",chromsome="ENSG00000067955",name="Transcripts",transcriptAnnotation="transcript",size=0.5,background.title ="#619CFF",fill="#619CFF",col="black",fontsize=20)

#Create a GenomeAxisTrack displaying the size of the genomic region porrayed in figure
gtrack <- GenomeAxisTrack()

#Open the R pdf saving functions
pdf('coverage_st.pdf',width=15,height=6)
#Plot the various track created in order of list, zooming in on a specific genomic range for chromosome 16
plotTracks(list(gtrack,alTrack,grtrack),from=-500,to=4200,chromosome="ENSG00000067955",type=c("coverage"))
dev.off() #Clost pdf after plotting
