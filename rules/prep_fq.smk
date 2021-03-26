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


rule trimmomatic:
    input:
        fwd="analysis_output/{sample}/combine_fq/R1.fq.gz",
        rev="analysis_output/{sample}/combine_fq/R2.fq.gz",
        adapter=config["reference"]["adapter"]["fasta"],
    output:
        fwd="analysis_output/{sample}/trimmomatic/R1.fq.gz",
        rev="analysis_output/{sample}/trimmomatic/R2.fq.gz",
        fwd_up="analysis_output/{sample}/trimmomatic/R1_up.fq.gz",
        rev_up="analysis_output/{sample}/trimmomatic/R2_up.fq.gz",
        summary="analysis_output/{sample}/trimmomatic/summary.txt",
    log:
        "analysis_output/{sample}/trimmomatic/{sample}.log",
    benchmark:
        "analysis_output/{sample}/trimmomatic/{sample}.tsv"
    container:
        config["tools"]["trimmomatic"]
    threads: 4
    message:
        "{rule}: Trim adapter sequences in {wildcards.sample}"
    shell:
        "java -jar /opt/trimmomatic-0.39.jar PE "
        "-phred33 "
        "-threads {threads} "
        "-summary {output.summary} "
        "{input.fwd} "
        "{input.rev} "
        "{output.fwd} "
        "{output.fwd_up} "
        "{output.rev} "
        "{output.rev_up} "
        "ILLUMINACLIP:{input.adapter}:2:30:10:2:keepBothReads "
        "LEADING:3 "
        "TRAILING:3 "
        "MINLEN:36 &> {log}"


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
    benchmark:
        "analysis_output/{sample}/cutadapt/{sample}.tsv"
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
