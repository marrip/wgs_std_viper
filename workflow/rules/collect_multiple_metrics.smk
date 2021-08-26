rule collect_multiple_metrics:
    input:
        bam="analysis_output/{sample}/bwa/{sample}_{unit}.bam",
    output:
        expand(
            "analysis_output/{{sample}}/collect_multiple_metrics/{{sample}}_{{unit}}.{ext}",
            ext=[
                "alignment_summary_metrics",
                "base_distribution_by_cycle_metrics",
                "base_distribution_by_cycle.pdf",
                "insert_size_metrics",
                "insert_size_histogram.pdf",
                "quality_by_cycle_metrics",
                "quality_by_cycle.pdf",
                "quality_distribution_metrics",
                "quality_distribution.pdf",
            ],
        ),
    log:
        "analysis_output/{sample}/collect_multiple_metrics/{sample}_{unit}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Collect metrics on {wildcards.sample}_{wildcards.unit}"
    shell:
        "gatk CollectMultipleMetrics "
        "-I {input.bam} "
        "-O analysis_output/{wildcards.sample}/collect_multiple_metrics/{wildcards.sample}_{wildcards.unit} "
        "--ASSUME_SORTED "
        "--PROGRAM CollectBaseDistributionByCycle "
        "--PROGRAM CollectInsertSizeMetrics "
        "--PROGRAM MeanQualityByCycle "
        "--PROGRAM QualityScoreDistribution "
        "--METRIC_ACCUMULATION_LEVEL ALL_READS &> {log}"


rule collect_alignment_summary_metrics:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}_{unit}.bam",
        ref=config["reference"]["fasta"],
    output:
        expand(
            "analysis_output/{{sample}}/collect_alignment_summary_metrics/{{sample}}_{{unit}}.{ext}",
            ext=[
                "alignment_summary_metrics",
                "base_distribution_by_cycle_metrics",
                "base_distribution_by_cycle.pdf",
                "gc_bias.detail_metrics",
                "gc_bias.pdf",
                "gc_bias.summary_metrics",
                "insert_size_metrics",
                "insert_size_histogram.pdf",
                "quality_by_cycle_metrics",
                "quality_by_cycle.pdf",
                "quality_distribution_metrics",
                "quality_distribution.pdf",
            ],
        ),
    log:
        "analysis_output/{sample}/collect_alignment_summary_metrics/{sample}_{unit}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Collect alignment summary on {wildcards.sample}_{wildcards.unit}"
    shell:
        "gatk CollectMultipleMetrics "
        "-I {input.bam} "
        "-R {input.ref} "
        "-O analysis_output/{wildcards.sample}/collect_alignment_summary_metrics/{wildcards.sample}_{wildcards.unit} "
        "--ASSUME_SORTED "
        "--PROGRAM CollectAlignmentSummaryMetrics "
        "--PROGRAM CollectGcBiasMetrics "
        "--METRIC_ACCUMULATION_LEVEL READ_GROUP &> {log}"


rule collect_wgs_metrics:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}_{unit}.bam",
        ref=config["reference"]["fasta"],
        int=config["reference"]["intervals"],
    output:
        "analysis_output/{sample}/collect_wgs_metrics/{sample}_{unit}.txt",
    log:
        "analysis_output/{sample}/collect_wgs_metrics/{sample}_{unit}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Collect WGS metrics on {wildcards.sample}_{wildcards.unit}"
    shell:
        "gatk CollectWgsMetrics "
        "-I {input.bam} "
        "-R {input.ref} "
        "-O {output} "
        "--INTERVALS {input.int} "
        "--VALIDATION_STRINGENCY SILENT "
        "--INCLUDE_BQ_HISTOGRAM "
        "--USE_FAST_ALGORITHM &> {log}"


rule collect_duplicate_metrics:
    input:
        bam="analysis_output/{sample}/gather_bam_files/{sample}_{unit}.bam",
        ref=config["reference"]["fasta"],
        int=config["reference"]["intervals"],
    output:
        "analysis_output/{sample}/collect_duplicate_metrics/{sample}_{unit}.metrics",
    log:
        "analysis_output/{sample}/collect_duplicate_metrics/{sample}_{unit}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Collect Duplicate metrics on {wildcards.sample}_{wildcards.unit}"
    shell:
        """
        gatk CollectDuplicateMetrics \
        -I {input.bam} \
        -M {output} &> {log}
        """
