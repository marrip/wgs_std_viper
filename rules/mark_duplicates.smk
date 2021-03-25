rule mark_duplicates:
    input:
        "{sample}/{unit}/bwa_mem.bam",
    output:
        bam="{sample}/{unit}/mark_duplicates.bam",
        metrics="{sample}/{unit}/mark_duplicates.metrics",
    log:
        "{sample}/{unit}/gatk_bp.mark_duplicates.log",
    benchmark:
        "{sample}/{unit}/gatk_bp.mark_duplicates.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk MarkDuplicates "
        "--java-options "
        "-Xmx30g "
        "-I {input} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--TMP_DIR {wildcards.sample}/{wildcards.unit} &> {log}"


rule base_recalibrator:
    input:
        bam="{sample}/{unit}/mark_duplicates.bam",
        ref=config["reference"]["fasta"],
        sites=config["reference"]["sites"],
    output:
        "{sample}/{unit}/base_recalibrator.txt",
    log:
        "{sample}/{unit}/gatk_bp.base_recalibrator.log",
    benchmark:
        "{sample}/{unit}/gatk_bp.base_recalibrator.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk BaseRecalibrator "
        "--java-options "
        "-Xmx30g "
        "--input {input.bam} "
        "--output {output} "
        "--known-sites {input.sites} "
        "--reference {input.ref} &> {log}"
