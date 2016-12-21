
psl2gtf="/group/bioi1/nadiad/work_area/20160203_ALL/new_new_code/psl2gtf"

#convert the psl to a gff and sort
for f in `ls *.psl` ; do    
    $psl2gtf $f | bedtools sort -i - > $f.gtf
done

#merge the cufflinks annotations
for c in `ls cuff_*.gtf` ; do 
    cat $c | sed "s/CUFF/$c/g" > $c.fixed
done
cat cuff_*.fixed | bedtools sort -i - > cuff.merged.psl.gtf

# work out which regions are covered by which annotations
bedtools multiinter -names E R T C -i ensembl.psl.gtf refseq.psl.gtf trinity.psl.gtf cuff.merged.psl.gtf | awk '{ print $1"-"$2"-"$3"-"$5"\t"$1"\t"$2"\t"$3 }' > block.summary

