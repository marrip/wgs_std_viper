rule gather_bam_files:
    input:
        get_all_bam,
    output:
        "analysis_output/{sample}/gather_bam_files/{sample}.bam",
    params:
        get_all_bam_fmt,
    log:
        "analysis_output/{sample}/gather_bam_files/{sample}.log",
    benchmark:
        "analysis_output/{sample}/gather_bam_files/{sample}.tsv"
    container:
        config["tools"]["bwa"]
    message:
        "{rule}: Concatenate {wildcards.sample} bam files"
    shell:
        "gatk GatherBamFiles "
        "-I {params} "
        "-O {output} "
        "--CREATE_INDEX &> {log}"
