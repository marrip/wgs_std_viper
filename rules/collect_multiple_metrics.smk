rule collect_multiple_metrics:
    input:
        bam="analysis_output/{sample}/bwa/{sample}.bam",
        ref=config["reference"]["fasta"],
    output:
        expand("analysis_output/{{sample}}/collect_multiple_metrics/{{sample}}.{ext}",
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
              ])
    log:
        "analysis_output/{sample}/collect_multiple_metrics/{sample}.log",
    container:
        config["tools"]["bwa"]
    threads: 32
    message:
        "{rule}: Collect metrics on {wildcards.sample}"
    shell:
        "gatk CollectMultipleMetrics "
        "-I {input.bam} "
        "-O analysis_output/{wildcards.sample}/collect_multiple_metrics/{wildcards.sample} "
        "--ASSUME_SORTED "
        "--PROGRAM CollectBaseDistributionByCycle "
        "--PROGRAM CollectInsertSizeMetrics "
        "--PROGRAM MeanQualityByCycle "
        "--PROGRAM QualityScoreDistribution "
        "--METRIC_ACCUMULATION_LEVEL ALL_READS &> {log}"
