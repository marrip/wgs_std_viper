rule mark_duplicates:
    input:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.bam",
    output:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
        bai="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bai",
        metrics="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.metrics",
    log:
        "analysis_output/{sample}/mark_duplicates/{sample}_{locus}.log",
    container:
        config["tools"]["bwa"]
    shell:
        "gatk MarkDuplicates "
        "-I {input} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--CREATE_INDEX "
        "--TMP_DIR analysis_output/{wildcards.sample}/mark_duplicates &> {log}"
