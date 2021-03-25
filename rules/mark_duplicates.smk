rule mark_duplicates:
    input:
        "analysis_output/{sample}/split_bam/{sample}_{locus}.bam",
    output:
        bam="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
        metrics="analysis_output/{sample}/mark_duplicates/{sample}_{locus}.metrics",
    log:
        "analysis_output/{sample}/mark_duplicates/{sample}_{locus}.log",
    benchmark:
        "analysis_output/{sample}/mark_duplicates/{sample}_{locus}.tsv"
    container:
        config["tools"]["bwa"]
    shell:
        "gatk MarkDuplicates "
        "-I {input} "
        "-O {output.bam} "
        "-M {output.metrics} "
        "--TMP_DIR analysis_output/{wildcards.sample}/mark_duplicates &> {log}"


#rule base_recalibrator:
#    input:
#        bam="{sample}/{unit}/mark_duplicates.bam",
#        ref=config["reference"]["fasta"],
#        sites=config["reference"]["sites"],
#    output:
#        "{sample}/{unit}/base_recalibrator.txt",
#    log:
#        "{sample}/{unit}/gatk_bp.base_recalibrator.log",
#    benchmark:
#        "{sample}/{unit}/gatk_bp.base_recalibrator.tsv"
#    container:
#        config["tools"]["bwa"]
#    shell:
#        "gatk BaseRecalibrator "
#        "--java-options "
#        "-Xmx30g "
#        "--input {input.bam} "
#        "--output {output} "
#        "--known-sites {input.sites} "
#        "--reference {input.ref} &> {log}"
