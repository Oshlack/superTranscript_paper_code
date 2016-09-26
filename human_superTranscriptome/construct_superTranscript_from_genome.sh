
############################################################################
# This bash script was used to construct a superTranscriptome for human
# using a genome and a genome annotation.
###########################################################################

## We used the genome and annotation from https://github.com/markrobinsonuzh/diff_splice_paper
# annotation (gtf file)
in_gtf_prefix="Homo_sapiens.GRCh37.71.primary_assembly.protein_coding.exongene"
# genome (fasta)
in_genome="Homo_sapiens.GRCh37.71.dna.primary_assembly.fa"
# output name
out_name_prefix="human_super_reference"

# First flatten the genome annotation into a set of block positions
R CMD BATCH --no-restore --no-save "--args input_gtf='${in_gtf_prefix}.gtf' output_gtf='${in_gtf_prefix}.flattened.gtf'" ./generate_flattened_gtf.R generate_flattened_genome_annotation.log

# Paste together the blocks from the genome to get the superTranscripts
# gffread is a command from the cufflinks package
gffread ${in_gtf_prefix}.flattened.gtf -g $in_genome -w ${out_name_prefix}.fasta -W

## Tranform the transcript coordinates to the super transcripts
R --vanilla --args ${in_gtf_prefix}.gtf ${out_name_prefix}.fasta ${out_name_prefix}.transcripts.gtf < ./make_super_reference_annotation.R

# Flatten the gtf annotation of the superTranscripts to get blocks 
R CMD BATCH --no-restore --no-save "--args input_gtf='${out_name_prefix}.transcripts.gtf' output_gtf='${out_name_prefix}.blocks.gtf'" ./generate_flattened_gtf.R generate_flattened_ST.log


