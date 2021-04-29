rule base_recalibrator:
    input:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
        bai="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bai",
        ref=config["reference"]["fasta"],
        sites=config["reference"]["sites"],
    output:
        temp("analysis_output/{sample}/base_recalibrator/{sample}_{locus}.txt"),
    log:
        "analysis_output/{sample}/base_recalibrator/{sample}_{locus}.log",
    container:
        config["tools"]["gatk"]
    shell:
        "gatk BaseRecalibrator "
        "--input {input.bam} "
        "--output {output} "
        "--known-sites {input.sites} "
        "--reference {input.ref} &> {log}"
