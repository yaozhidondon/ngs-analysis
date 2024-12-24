/bin  -Djava.io.tmpdir=TMP -XX:ParallelGCThreads=8 -jar  \
                   /bin/picard_2.9.4.jar MarkDuplicates INPUT=Results/samplename/TEMP/MAP/samplename.sort.bam \
                   OUTPUT=Results/samplename/TEMP/MAP/samplename.sort.rmdup.bam                     \
                   METRICS_FILE=Results/samplename/TEMP/MAP/samplename.sort.rmdup.metrics REMOVE_DUPLICATES=true \
                   ASSUME_SORTED=true CREATE_INDEX=true 
