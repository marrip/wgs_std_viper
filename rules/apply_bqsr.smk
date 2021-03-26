rule apply_bqsr_locus:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
        recal="analysis_output/{sample}/base_recalibrator/{sample}_{locus}.txt",
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/apply_bqsr/{sample}_{locus}.bam",
    log:
        "analysis_output/{sample}/apply_bqsr/{sample}_{locus}.log",
    benchmark:
        "analysis_output/{sample}/apply_bqsr/{sample}_{locus}.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk ApplyBQSR "
        "-R {input.ref} "
        "-I {input.bam} "
        "--bqsr-recal-file {input.recal} "
        "-O {output} &> {log}"


rule apply_bqsr:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}.bam",
        recal="analysis_output/{sample}/base_recalibrator/{sample}.txt",
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/apply_bqsr/{sample}.bam",
    log:
        "analysis_output/{sample}/apply_bqsr/{sample}.log",
    benchmark:
        "analysis_output/{sample}/apply_bqsr/{sample}.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk ApplyBQSR "
        "-R {input.ref} "
        "-I {input.bam} "
        "--bqsr-recal-file {input.recal} "
        "-O {output} &> {log}"
