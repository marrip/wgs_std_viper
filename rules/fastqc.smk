rule fastqc:
    input:
        unpack(get_fastq),
    output:
        directory("analysis_output/{sample}/fastqc/{run}_{lane}"),
    log:
        "analysis_output/{sample}/fastqc/{run}_{lane}.log",
    container:
        config["tools"]["fastqc"]
    threads: 2
    message:
        "{rule}: Generate fastq statistics for {wildcards.sample}_{wildcards.run}_{wildcards.lane}"
    shell:
        "mkdir {output} && "
        "fastqc "
        "-t {threads} "
        "--outdir {output} "
        "{input} &> {log}"
