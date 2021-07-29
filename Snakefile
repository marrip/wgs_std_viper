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
        expand(
            "analysis_output/{sample}/wgs_std_viper.ok",
            sample=samples.index,
            )


rule workflow_complete:
    input:
        unpack(compile_output_list),
    output:
        "analysis_output/{sample}/wgs_std_viper.ok",
    log:
        "analysis_output/{sample}/wgs_std_viper.workflow_complete.log",
    container:
        config["tools"]["common"]
    shell:
        "touch {output} &> {log}"
