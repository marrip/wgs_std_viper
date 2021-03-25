include: "rules/common.smk"
include: "rules/bwa.smk"
include: "rules/collect_multiple_metrics.smk"
include: "rules/fastqc.smk"
include: "rules/prep_fq.smk"

rule all:
  input:
    "analysis_output/NA12878/fastqc/1_1",
    "analysis_output/NA12878/trimmomatic/R1.fq.gz",
    "analysis_output/NA12878/collect_multiple_metrics/NA12878.insert_size_histogram.pdf"
