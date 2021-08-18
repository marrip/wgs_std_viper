rule combine_fq:
    input:
        unpack(get_sample_fastq),
    output:
        fwd="analysis_output/{sample}/combine_fq/{sample}_{unit}_R1.fq.gz",
        rev="analysis_output/{sample}/combine_fq/{sample}_{unit}_R2.fq.gz",
    log:
        "analysis_output/{sample}/combine_fq/{sample}_{unit}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Combine fastq files of sample {wildcards.sample}_{wildcards.unit}"
    shell:
        "cat {input.fwd} > {output.fwd} && "
        "cat {input.rev} > {output.rev} | tee {log}"


rule cutadapt:
    input:
        fwd="analysis_output/{sample}/combine_fq/{sample}_{unit}_R1.fq.gz",
        rev="analysis_output/{sample}/combine_fq/{sample}_{unit}_R2.fq.gz",
    output:
        fwd=temp("analysis_output/{sample}/cutadapt/{sample}_{unit}_R1.fq.gz"),
        rev=temp("analysis_output/{sample}/cutadapt/{sample}_{unit}_R2.fq.gz"),
    params:
        fwd=config["reference"]["adapter"]["fwd"],
        rev=config["reference"]["adapter"]["rev"],
    log:
        "analysis_output/{sample}/cutadapt/{sample}_{unit}.log",
    container:
        config["tools"]["cutadapt"]
    threads: 10
    message:
        "{rule}: Trim adapter sequences in {wildcards.sample}_{wildcards.unit}"
    shell:
        "cutadapt "
        "-j {threads} "
        "-a {params.fwd} "
        "-A {params.rev} "
        "-o {output.fwd} "
        "-p {output.rev} "
        "--minimum-length 2 "
        "-q 20 "
        "{input.fwd} "
        "{input.rev} &> {log}"
