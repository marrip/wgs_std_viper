rule samtools_stats:
    input:
        "analysis_output/{sample}/gather_bam_files/{sample}.bam",
    output:
        "analysis_output/{sample}/samtools_stats/{sample}.txt",
    log:
        "analysis_output/{sample}/samtools_stats/{sample}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Produce comprehensive statistics on {wildcards.sample}"
    threads: 8
    shell:
        "(samtools stats "
        "-@ {threads} "
        "{input} > {output}) &> {log}"
