include: "rules/common.smk"
include: "rules/bwa.smk"
include: "rules/collect_multiple_metrics.smk"
include: "rules/fastqc.smk"
include: "rules/mark_duplicates.smk"
include: "rules/merge_bam.smk"
include: "rules/mosdepth.smk"
include: "rules/prep_fq.smk"
include: "rules/split_bam.smk"

rule all:
  input:
    "analysis_output/NA12878/fastqc/1_1",
    "analysis_output/NA12878/trimmomatic/R1.fq.gz",
    "analysis_output/NA12878/collect_multiple_metrics/NA12878.insert_size_histogram.pdf",
    expand("analysis_output/NA12878/mark_duplicates/NA12878_{locus}.bam", locus=get_loci()),
    "analysis_output/NA12878/merge_bam/NA12878.bam",
    "analysis_output/NA12878/mark_duplicates/NA12878.bam",
    "analysis_output/NA12878/mosdepth/NA12878.mosdepth.global.dist.txt",
