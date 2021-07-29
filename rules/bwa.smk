rule bwa:
    input:
        fwd="analysis_output/{sample}/cutadapt/{sample}_{unit}_R1.fq.gz",
        rev="analysis_output/{sample}/cutadapt/{sample}_{unit}_R2.fq.gz",
        ref=config["reference"]["fasta"],
    output:
        temp("analysis_output/{sample}/bwa/{sample}_{unit}.bam"),
    log:
        "analysis_output/{sample}/bwa/{sample}_{unit}.log",
    params:
        K=10000000,
        R="'@RG\\tID:{sample}_{unit}_rg1\\tLB:lib1\\tPL:bar\\tSM:{sample}_{unit}\\tPU:{sample}_{unit}_rg1'",
    container:
        config["tools"]["common"]
    threads: 32
    message:
        "{rule}: Align {wildcards.sample}_{wildcards.unit} to {input.ref} and sort records"
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
        "analysis_output/{sample}/bwa/{sample}_{unit}.bam",
    output:
        temp("analysis_output/{sample}/bwa/{sample}_{unit}.bai"),
    log:
        "analysis_output/{sample}/bwa/{sample}_{unit}_index_bam.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Index {wildcards.sample}_{wildcards.unit} bam file"
    shell:
        "samtools index "
        "-b {input} "
        "{output} &> {log}"
