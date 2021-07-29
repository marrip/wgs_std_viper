rule split_bam:
    input:
        bam="analysis_output/{sample}/bwa/{sample}_{unit}.bam",
        bai="analysis_output/{sample}/bwa/{sample}_{unit}.bai",
    output:
        temp("analysis_output/{sample}/split_bam/{sample}_{unit}_{locus}.bam"),
    log:
        "analysis_output/{sample}/split_bam/{sample}_{unit}_{locus}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Split {wildcards.sample}_{wildcards.unit} bam file"
    shell:
        "samtools view "
        "-b {input.bam} "
        "{wildcards.locus} &> {output} 2> {log}"
