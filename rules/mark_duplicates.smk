rule mark_duplicates_locus:
    input:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.bam",
    output:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
        bai="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bai",
        metrics="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.metrics",
    log:
        "analysis_output/{sample}/mark_duplicates/{sample}_{locus}.log",
    benchmark:
        "analysis_output/{sample}/mark_duplicates/{sample}_{locus}.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk MarkDuplicates "
        "-I {input} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--CREATE_INDEX "
        "--TMP_DIR analysis_output/{wildcards.sample}/mark_duplicates &> {log}"


rule mark_duplicates:
    input:
        bam="analysis_output/{sample}/bwa/{sample}.bam",
        bai="analysis_output/{sample}/bwa/{sample}.bai",
    output:
        bam="analysis_output/{sample}/mark_duplicates/{sample}.bam",
        bai="analysis_output/{sample}/mark_duplicates/{sample}.bai",
        metrics="analysis_output/{sample}/mark_duplicates/{sample}.metrics",
    log:
        "analysis_output/{sample}/mark_duplicates/{sample}.log",
    benchmark:
        "analysis_output/{sample}/mark_duplicates/{sample}.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk MarkDuplicates "
        "-I {input.bam} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--CREATE_INDEX "
        "--TMP_DIR analysis_output/{wildcards.sample}/mark_duplicates &> {log}"
