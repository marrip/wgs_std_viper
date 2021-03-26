include: "rules/common.smk"
include: "rules/apply_bqsr.smk"
include: "rules/base_recalibrator.smk"
include: "rules/bwa.smk"
include: "rules/collect_multiple_metrics.smk"
include: "rules/fastqc.smk"
include: "rules/gather_bam_files.smk"
include: "rules/mark_duplicates.smk"
include: "rules/mosdepth.smk"
include: "rules/prep_fq.smk"
include: "rules/split_bam.smk"

rule all:
  input:
    compile_output_list(),
