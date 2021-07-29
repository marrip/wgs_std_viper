rule gather_bam_files:
    input:
        get_all_bam,
    output:
        "analysis_output/{sample}/gather_bam_files/{sample}_{unit}.bam",
    params:
        get_all_bam_fmt,
    log:
        "analysis_output/{sample}/gather_bam_files/{sample}_{unit}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Concatenate {wildcards.sample}_{wildcards.unit} bam files"
    shell:
        "gatk GatherBamFiles "
        "-I {params} "
        "-O {output} "
        "--CREATE_INDEX &> {log}"
