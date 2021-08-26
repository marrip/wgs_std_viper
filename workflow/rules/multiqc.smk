rule prep_multiqc:
    input:
        config["units"],
    output:
        config="analysis_output/{sample}/multiqc/{sample}.yaml",
        ids="analysis_output/{sample}/multiqc/{sample}.tsv",
    log:
        "analysis_output/{sample}/multiqc/prep_multiqc_{sample}.log",
    container:
        config["tools"]["python"]
    message:
        "{rule}: Prepare files for multiqc for {wildcards.sample}"
    script:
        "../scripts/prep_multiqc.py"


rule multiqc:
    input:
        unpack(get_multiqc_files),
        config=rules.prep_multiqc.output.config,
        ids=rules.prep_multiqc.output.ids,
    output:
        report="analysis_output/{sample}/multiqc/{sample}.html",
        data=directory("analysis_output/{sample}/multiqc/{sample}_data"),
    log:
        "analysis_output/{sample}/multiqc/multiqc_{sample}.log",
    container:
        config["tools"]["multiqc"]
    message:
        "{rule}: Compile multiqc report for {wildcards.sample}"
    shell:
        """
        multiqc \
        -n {output.report} \
        -c {input.config} \
        --replace-names {input.ids} \
        analysis_output/{wildcards.sample} &> {log}
        """
