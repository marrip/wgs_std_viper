rule samtools_stats:
    input:
        "analysis_output/{sample}/gather_bam_files/{sample}_{unit}.bam",
    output:
        "analysis_output/{sample}/samtools_stats/{sample}_{unit}.txt",
    log:
        "analysis_output/{sample}/samtools_stats/{sample}_{unit}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Produce comprehensive statistics on {wildcards.sample}_{wildcards.unit}"
    threads: 8
    shell:
        "(samtools stats "
        "-@ {threads} "
        "{input} > {output}) &> {log}"
