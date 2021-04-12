rule combine_fq:
    input:
        unpack(get_sample_fastq),
    output:
        fwd="analysis_output/{sample}/combine_fq/R1.fq.gz",
        rev="analysis_output/{sample}/combine_fq/R2.fq.gz",
    log:
        "analysis_output/{sample}/combine_fq/{sample}.log",
    container:
        config["tools"]["ubuntu"]
    message:
        "{rule}: Combine fastq files of sample {wildcards.sample}"
    shell:
        "cat {input.fwd} > {output.fwd} && "
        "cat {input.rev} > {output.rev} | tee {log}"


rule cutadapt:
    input:
        fwd="analysis_output/{sample}/combine_fq/R1.fq.gz",
        rev="analysis_output/{sample}/combine_fq/R2.fq.gz",
    output:
        fwd="analysis_output/{sample}/cutadapt/R1.fq.gz",
        rev="analysis_output/{sample}/cutadapt/R2.fq.gz",
    params:
        fwd=config["reference"]["adapter"]["fwd"],
        rev=config["reference"]["adapter"]["rev"],
    log:
        "analysis_output/{sample}/cutadapt/{sample}.log",
    container:
        config["tools"]["cutadapt"]
    threads: 4
    message:
        "{rule}: Trim adapter sequences in {wildcards.sample}"
    shell:
        "cutadapt "
        "-j {threads} "
        "-a {params.fwd} "
        "-A {params.rev} "
        "-o {output.fwd} "
        "-p {output.rev} "
        "{input.fwd} "
        "{input.rev} &> {log}"
