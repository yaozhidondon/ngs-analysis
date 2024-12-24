#!/bin/bash

bed=/home/panel.flank50.bed
hs37d5=/mnt/hs37d5/hs37d5.fa
outdir=/mnt/Vardict/
tbam=/mnt/Bams/samplename.sort.recal.bam
tid=TMB-H


VarDict -3 -C -c 1 -S 2 -E 3 -g 4 -Q 20 -q 30 -th 8 -r 4 -X 0 -z 0 -UN -U -v -f 0.004 -G $hs37d5 -N $tid -b "$tbam|$nbam" $bed | \
	strandbias.R | \
	var2vcf_validatted.pl -N "$tid|$nid" -f 0.004 -d 20 -v 4 > $outdir/$tid.pair.vardict.vcf 
