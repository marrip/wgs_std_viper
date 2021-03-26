rule base_recalibrator_locus:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
        bai="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bai",
        ref=config["reference"]["fasta"],
        sites=config["reference"]["sites"],
    output:
        "analysis_output/{sample}/base_recalibrator/{sample}_{locus}.txt",
    log:
        "analysis_output/{sample}/base_recalibrator/{sample}_{locus}.log",
    benchmark:
        "analysis_output/{sample}/base_recalibrator/{sample}_{locus}.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk BaseRecalibrator "
        "--input {input.bam} "
        "--output {output} "
        "--known-sites {input.sites} "
        "--reference {input.ref} &> {log}"


rule base_recalibrator:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}.bam",
        bai="analysis_output/{sample}/mark_duplicates/{sample}.bai",
        ref=config["reference"]["fasta"],
        sites=config["reference"]["sites"],
    output:
        "analysis_output/{sample}/base_recalibrator/{sample}.txt",
    log:
        "analysis_output/{sample}/base_recalibrator/{sample}.log",
    benchmark:
        "analysis_output/{sample}/base_recalibrator/{sample}.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk BaseRecalibrator "
        "--input {input.bam} "
        "--output {output} "
        "--known-sites {input.sites} "
        "--reference {input.ref} &> {log}"
