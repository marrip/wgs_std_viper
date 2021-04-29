rule bwa:
    input:
        fwd="analysis_output/{sample}/cutadapt/R1.fq.gz",
        rev="analysis_output/{sample}/cutadapt/R2.fq.gz",
        ref=config["reference"]["fasta"],
    output:
        temp("analysis_output/{sample}/bwa/{sample}.bam"),
    log:
        "analysis_output/{sample}/bwa/{sample}.log",
    params:
        K=10000000,
        R="'@RG\\tID:{sample}_rg1\\tLB:lib1\\tPL:bar\\tSM:{sample}\\tPU:{sample}_rg1'",
    container:
        config["tools"]["common"]
    threads: 32
    message:
        "{rule}: Align {wildcards.sample} to {input.ref} and sort records"
    shell:
        "(bwa mem "
        "-t {threads} "
        "-K {params.K} "
        "-R {params.R} "
        "{input.ref} "
        "{input.fwd} "
        "{input.rev} | "
        "samtools sort "
        "-@ {threads} "
        "-o {output} -) &> {log}"


rule index_bam:
    input:
        "analysis_output/{sample}/bwa/{sample}.bam",
    output:
        temp("analysis_output/{sample}/bwa/{sample}.bai"),
    log:
        "analysis_output/{sample}/bwa/index_bam.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Index {wildcards.sample} bam file"
    shell:
        "samtools index "
        "-b {input} "
        "{output} &> {log}"
