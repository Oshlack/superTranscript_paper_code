############################################################################
# This bash script was used to construct a superTranscriptome for human
# using a genome and a genome annotation.
###########################################################################

# annotation (gtf file)
in_gtf_prefix="GencodeVM4mm10"
# genome (fasta)
in_genome="/group/bioi1/shared/genomes/mm10/fasta/mm10.fa"
# output name
out_name_prefix="mm10_super_reference"

# First flatten the genome annotation into a set of block positions
#R CMD BATCH --no-restore --no-save "--args input_gtf='${in_gtf_prefix}.gtf' output_gtf='${in_gtf_prefix}.flattened.gtf'" ./generate_flattened_gtf.R generate_flattened_genome_annotation.log

# Paste together the blocks from the genome to get the superTranscripts
# gffread is a command from the cufflinks package
#/group/bioi1/anthonyh/cufflinks-2.2.1.Linux_x86_64/gffread ${in_gtf_prefix}.flattened.gtf -g $in_genome -w ${out_name_prefix}.fasta -W

## Tranform the transcript coordinates to the super transcripts
R --vanilla --args ${in_gtf_prefix}.gtf ${out_name_prefix}.fasta ${out_name_prefix}.transcripts.gtf < ./make_super_reference_annotation.R

# Flatten the gtf annotation of the superTranscripts to get blocks 
R CMD BATCH --no-restore --no-save "--args input_gtf='${out_name_prefix}.transcripts.gtf' output_gtf='${out_name_prefix}.blocks.gtf'" ./generate_flattened_gtf.R generate_flattened_ST.log


