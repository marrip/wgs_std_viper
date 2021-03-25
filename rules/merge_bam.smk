rule merge_bam:
    input:
        get_all_bam,
    output:
        "analysis_output/{sample}/merge_bam/{sample}.bam",
    params:
        get_all_bam_fmt,
    log:
        "analysis_output/{sample}/merge_bam/{sample}.log",
    benchmark:
        "analysis_output/{sample}/merge_bam/{sample}.tsv",
    container:
        config["tools"]["bwa"]
    message:
        "{rule}: Merge {wildcards.sample} bam files"
    shell:
        "gatk MergeSamFiles "
        "-I {params} "
        "-O {output} "
        "--CREATE_INDEX &> {log}"
