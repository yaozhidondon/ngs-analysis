
/bin/bwa mem -Y -M -t 8 -R '@RG\tID:1\tSM:samplename\tPL:ILLUMINA\tLB:samplename\tPU:samplename' /resources/public/databases/genome/hs37d5.fa\                      
Results/samplename/TEMP/MAP/samplename_clean_R1.fastq.gz Results/samplename/TEMP/MAP/samplename_clean_R2.fastq.gz | \
/bin/pigz > Results/samplename/TEMP/MAP/samplename.sam.gz
