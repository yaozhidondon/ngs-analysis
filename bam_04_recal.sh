/bin/sambamba view -t 2  -h  Results/samplename/TEMP/MAP/samplename.sort.rmdup.bam | python /scripts/SC_misc_MaskBam.py samplename - 2> \
Results/samplename/TEMP/MAP/samplename.sort.rmdup.recal.log |                \
/bin/sambamba view -t 2 -f bam -S -o Results/samplename/TEMP/MAP/samplename.sort.rmdup.recal.bam /dev/stdin 
