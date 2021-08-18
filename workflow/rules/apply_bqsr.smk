rule apply_bqsr:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{unit}_{locus}.bam",
        recal="analysis_output/{sample}/base_recalibrator/{sample}_{unit}_{locus}.txt",
        ref=config["reference"]["fasta"],
    output:
        temp("analysis_output/{sample}/apply_bqsr/{sample}_{unit}_{locus}.bam"),
    log:
        "analysis_output/{sample}/apply_bqsr/{sample}_{unit}_{locus}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Apply recalibrated base quality score to {wildcards.sample}_{wildcards.unit}"
    shell:
        "gatk ApplyBQSR "
        "-R {input.ref} "
        "-I {input.bam} "
        "--bqsr-recal-file {input.recal} "
        "-O {output} &> {log}"
