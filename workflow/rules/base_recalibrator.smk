rule base_recalibrator:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{unit}_{locus}.bam",
        bai="analysis_output/{sample}/mark_duplicates/{sample}_{unit}_{locus}.bai",
        ref=config["reference"]["fasta"],
        sites=config["reference"]["sites"],
    output:
        temp("analysis_output/{sample}/base_recalibrator/{sample}_{unit}_{locus}.txt"),
    log:
        "analysis_output/{sample}/base_recalibrator/{sample}_{unit}_{locus}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Recalibrate base quality score of {wildcards.sample}_{wildcards.unit}"
    shell:
        "gatk BaseRecalibrator "
        "--input {input.bam} "
        "--output {output} "
        "--known-sites {input.sites} "
        "--reference {input.ref} &> {log}"
