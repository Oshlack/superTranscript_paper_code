


chicken_ref="../chicken_genome_super_transcript/chicken_genome_merged_ST.fasta"
human_ref="../../reference_generation/human_super_reference.fasta"
trinity="/mnt/storage/nadiad/work_area/20160601_superTranscript/chicken/fasta/Trinity.fasta"

## blat against the chicken reference
blat $chicken_ref $trinity -minScore=200 -minIdentity=98 trinity.chicken.psl &> trinity.chicken.log 

# blat against the human reference
echo "blat $human_ref $trinity -t=dnax -q=dnax -minScore=200 trinity.human.psl"
blat $human_ref $trinity -t=dnax -q=dnax -minScore=200 trinity.human.psl
echo "blat $human_ref $chicken_ref -t=dnax -q=dnax -minScore=200 chicken.human.psl"
blat $human_ref $chicken_ref -t=dnax -q=dnax -minScore=200 chicken.human.psl

# get a list of all reference super transcript IDs
grep "^>" ../chicken_genome_super_transcript/chicken_genome_merged_ST.fasta | cut -f1 -d" " | sed 's/>//g' > ref_list.txt

R --vanilla < ./make_clusters.R


