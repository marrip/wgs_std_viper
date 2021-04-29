rule mark_duplicates:
    input:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.bam",
    output:
        bam=temp("analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam"),
        bai=temp("analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bai"),
        metrics="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.metrics",
    log:
        "analysis_output/{sample}/mark_duplicates/{sample}_{locus}.log",
    container:
        config["tools"]["gatk"]
    shell:
        "gatk MarkDuplicates "
        "-I {input} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--CREATE_INDEX "
        "--TMP_DIR analysis_output/{wildcards.sample}/mark_duplicates &> {log}"
