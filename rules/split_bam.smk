rule split_bam:
    input:
        bam="analysis_output/{sample}/bwa/{sample}.bam",
        bai="analysis_output/{sample}/bwa/{sample}.bai",
    output:
        temp("analysis_output/{sample}/split_bam/{sample}_{locus}.bam"),
    log:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Split {wildcards.sample} bam file"
    shell:
        "samtools view "
        "-b {input.bam} "
        "{wildcards.locus} &> {output} 2> {log}"
