rule fastqc:
    input:
        unpack(get_fastq),
    output:
        dir=directory("analysis_output/{sample}/fastqc/{sample}_{unit}_{run}_{lane}"),
    log:
        "analysis_output/{sample}/fastqc/{sample}_{unit}_{run}_{lane}.log",
    container:
        config["tools"]["fastqc"]
    threads: 2
    message:
        "{rule}: Generate fastq statistics for {wildcards.sample}_{wildcards.unit}_{wildcards.run}_{wildcards.lane}"
    shell:
        """
        mkdir {output.dir} && \
        fastqc \
        -t {threads} \
        --outdir {output} \
        {input} &> {log}
        """
