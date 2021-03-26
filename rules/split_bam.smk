rule split_bam:
    input:
        bam="analysis_output/{sample}/bwa/{sample}.bam",
        bai="analysis_output/{sample}/bwa/{sample}.bai",
    output:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.bam",
    log:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.log",
    benchmark:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.tsv"
    container:
        config["tools"]["common"]
    message:
        "{rule}: Split {wildcards.sample} bam file"
    shell:
        "samtools view "
        "-b {input.bam} "
        "{wildcards.locus} &> {output} 2> {log}"
