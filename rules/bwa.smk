rule bwa_mem:
    input:
        fwd="analysis_output/{sample}/cutadapt/R1.fq.gz",
        rev="analysis_output/{sample}/cutadapt/R2.fq.gz",
        ref=config["reference"]["fasta"],
    output:
        "analysis_output/{sample}/bwa/{sample}.bam",
    log:
        "analysis_output/{sample}/bwa/{sample}.log",
    params:
        K=10000000,
        R="'@RG\\tID:{sample}_rg1\\tLB:lib1\\tPL:bar\\tSM:{sample}\\tPU:{sample}_rg1'",
        MaxRec=5000000,
        SortOrd="coordinate",
    container:
        config["tools"]["bwa"]
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
        "gatk SortSam "
        "--MAX_RECORDS_IN_RAM {params.MaxRec} "
        "-I /dev/stdin "
        "-O {output} "
        "--SORT_ORDER {params.SortOrd} "
        "--TMP_DIR analysis_output/{wildcards.sample}/bwa) &> {log}"
