#!/bin/bash

bed=/home/bin/panel.flank50.bed
hs37d5=/mnt/reference/hs37d5/hs37d5.fa
exac=/mnt/database/gatk_b37/small_exac_common_3_b37.vcf.gz
gnomad=/mnt/binf/rui/database/gatk_b37/af-only-gnomad.raw.sites.b37.vcf.gz
pon_panel=/mnt/gatk/.vcf.gz
outdir=/mn/Mutect2
tbam=/mnt/Bams/filename.sort.recal.bam
tid=TMB-H



gatk GetPileupSummaries	-R $hs37d5 -V $exac -L $bed \
	-I $nbam -O $outdir/$nid.01.getpileupsummaries.table
	
gatk GetPileupSummaries -R $hs37d5 -V $exac -L $bed \
	-I $tbam -O $outdir/$tid.01.getpileupsummaries.table

gatk CalculateContamination \
	-I $outdir/$tid.01.getpileupsummaries.table \
	-matched $outdir/$nid.01.getpileupsummaries.table \
	--tumor-segmentation $outdir/$tid.02.segments.table \
	-O $outdir/$tid.03.contamination.table

gatk Mutect2 -L $bed -R $hs37d5 --germline-resource $gnomad \
	-pon $pon_panel \
	-I $tbam -O $outdir/$tid.04.pair.raw.vcf.gz --f1r2-tar-gz $outdir/$tid.05.f1r2.tar.gz \
	-I $nbam -normal $nid

gatk LearnReadOrientationModel -I $outdir/$tid.05.f1r2.tar.gz -O $outdir/$tid.06.read-orientation-model.tar.gz

gatk FilterMutectCalls -R $hs37d5 \
	-V $outdir/$tid.04.pair.raw.vcf.gz \
	--tumor-segmentation $outdir/$tid.02.segments.table \
	--contamination-table $outdir/$tid.03.contamination.table \
	-ob-priors $outdir/$tid.06.read-orientation-model.tar.gz \
	-O $outdir/$tid.07.filtered.vcf.gz
