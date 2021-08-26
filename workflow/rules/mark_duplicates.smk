rule mark_duplicates:
    input:
        "analysis_output/{sample}/split_bam/{sample}_{unit}_{locus}.bam",
    output:
        bam=temp("analysis_output/{sample}/mark_duplicates/{sample}_{unit}_{locus}.bam"),
        bai=temp("analysis_output/{sample}/mark_duplicates/{sample}_{unit}_{locus}.bai"),
        metrics=temp(
            "analysis_output/{sample}/mark_duplicates/{sample}_{unit}_{locus}.metrics"
        ),
    log:
        "analysis_output/{sample}/mark_duplicates/{sample}_{unit}_{locus}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Mark duplicates in {wildcards.sample}_{wildcards.unit}"
    shell:
        "gatk MarkDuplicates "
        "-I {input} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--CREATE_INDEX "
        "--TMP_DIR analysis_output/{wildcards.sample}/mark_duplicates &> {log}"
