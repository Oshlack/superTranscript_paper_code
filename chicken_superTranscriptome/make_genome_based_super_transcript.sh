
## Script to merge all the genome based transcriptome and build a super transcript

CUFFLINKS="/mnt/storage/nadiad/software/cufflinks-2.2.1.Linux_x86_64"
### switch to python2 or cuffmerge doesn't work
PATH=/usr/bin:$CUFFLINKS:$PATH

#merge the reference annotation with the genome-guided cufflinks assembly
cuffmerge -o genome_merged_gft -p 8 cuffmerge_list.txt

#create a flattened annotation for the genome 
## ignore strand in this instance because we don't know the strand for the genome-guided assembly
R CMD BATCH --no-restore --no-save "--args input_gtf='genome_merged_gft/merged.gtf' output_gtf='genome_merged.flattened.gtf' ignore_strand=TRUE" ../../reference_generation/generate_flattened_gtf.R generate_flattened_gtf.Rout

cat genome_merged.flattened.gtf | sed 's/*/+/g' > temp ; mv temp genome_merged.flattened.gtf

## Make a super transcript for the genome
gffread genome_merged.flattened.gtf -g /mnt/storage/shared/genomes/galGal4/fasta/galGal4.fa -w chicken_genome_merged_ST.fasta -W

