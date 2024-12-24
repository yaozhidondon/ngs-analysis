
                        mkdir -p Results/samplename/TEMP/CleanFastq/
                        /bin/fastp -i Results/samplename/TEMP/RawFastq/samplename_R1.fastq.gz -I \
                        Results/samplename/TEMP/RawFastq/samplename_R2.fastq.gz -o \
                        Results/samplename/TEMP/CleanFastq/samplename_R1.fastq.gz -O \
                        Results/samplename/TEMP/CleanFastq/samplename_R2.fastq.gz                         \
                        --unpaired1 Results/samplename/TEMP/CleanFastq/samplename_unpaired_R1.fastq.gz \
                        --unpaired2 Results/samplename/TEMP/CleanFastq/samplename_unpaired_R2.fastq.gz \
                        --failed_out Results/samplename/TEMP/CleanFastq/samplename_failed.fastq.gz                         \
                        --detect_adapter_for_pe --json Results/samplename/TEMP/CleanFastq/samplename.fastp.json \
                        --html Results/samplename/TEMP/CleanFastq/samplename.fastp.html                          \
                        -w 10 --cut_tail --cut_tail_window_size 1 --cut_tail_mean_quality 15                         \
                        --cut_right --cut_right_window_size 5 --cut_right_mean_quality 20  --average_qual 20                         \
                        --length_required 30  --trim_poly_g  --poly_g_min_len 50
                        python /scripts/umi_cutter.py Results/samplename/TEMP/CleanFastq/samplename_R1.fastq.gz \
                        Results/samplename/TEMP/CleanFastq/samplename_R2.fastq.gz \
                        Results/samplename/03Fastq/samplename_clean_R1.fastq.gz \
                        Results/samplename/03Fastq/samplename_clean_R2.fastq.gz /resources/public/softwares/bin/pigz /resources/public/softwares/bin/unpigz
                        ln -sf ../../../../Results/samplename/03Fastq/samplename_clean_R1.fastq.gz Results/samplename/TEMP/MAP/samplename_clean_R1.fastq.gz
                        ln -sf ../../../../Results/samplename/03Fastq/samplename_clean_R2.fastq.gz Results/samplename/TEMP/MAP/samplename_clean_R2.fastq.gz
