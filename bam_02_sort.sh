/bin/unpigz -c -p 8 Results/samplename/TEMP/MAP/samplename.sam.gz | /bin/sambamba view -t 8 -f bam -l 0 \
                        -S /dev/stdin | /bin/sambamba  sort --tmpdir /JavaTemp/   -t 8 -m 3G                     \
                        -o Results/samplename/TEMP/MAP/samplename.sort.bam /dev/stdin
