
trinity="/mnt/storage/nadiad/work_area/20160601_superTranscript/chicken/fasta/Trinity.fasta"

## blat to the reference genome
blat /mnt/storage/shared/genomes/galGal4/fasta/galGal4.fa SuperDuper.fasta -minScore=100 -minIdentity=98 SuperDuper.genome.gal4.psl
blat /mnt/storage/shared/genomes/galGal5/fasta/galGal5.fa SuperDuper.fasta -minScore=100 -minIdentity=98 SuperDuper.genome.gal5.psl

## blat to the constituent transcripts
blat SuperDuper.fasta $trinity -minScore=200 -minIdentity=98 trinity.psl &
blat SuperDuper.fasta ../analysis/ensGene.fasta -minScore=200 -minIdentity=98 ensembl.psl &
blat SuperDuper.fasta ../analysis/reGene.fasta -minScore=200 -minIdentity=98 refseq.psl &
blat SuperDuper.fasta ../analysis/cuff_GF1.fasta -minScore=200 -minIdentity=98 cuff_GF1.psl &
blat SuperDuper.fasta ../analysis/cuff_GF2.fasta -minScore=200 -minIdentity=98 cuff_GF2.psl &
blat SuperDuper.fasta ../analysis/cuff_GM1.fasta -minScore=200 -minIdentity=98 cuff_GM1.psl &
blat SuperDuper.fasta ../analysis/cuff_GM2.fasta -minScore=200 -minIdentity=98 cuff_GM2.psl &

