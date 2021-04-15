rule apply_bqsr:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
        recal="analysis_output/{sample}/base_recalibrator/{sample}_{locus}.txt",
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/apply_bqsr/{sample}_{locus}.bam",
    log:
        "analysis_output/{sample}/apply_bqsr/{sample}_{locus}.log",
    container:
        config["tools"]["gatk"]
    shell:
        "gatk ApplyBQSR "
        "-R {input.ref} "
        "-I {input.bam} "
        "--bqsr-recal-file {input.recal} "
        "-O {output} &> {log}"
