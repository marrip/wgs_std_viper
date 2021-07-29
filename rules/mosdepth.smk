rule mosdepth:
    input:
        bam="analysis_output/{sample}/bwa/{sample}_{unit}.bam",
        bai="analysis_output/{sample}/bwa/{sample}_{unit}.bai",
    output:
        "analysis_output/{sample}/mosdepth/{sample}_{unit}.mosdepth.global.dist.txt",
        "analysis_output/{sample}/mosdepth/{sample}_{unit}.mosdepth.region.dist.txt",
        "analysis_output/{sample}/mosdepth/{sample}_{unit}.mosdepth.summary.txt",
        "analysis_output/{sample}/mosdepth/{sample}_{unit}.regions.bed.gz",
        "analysis_output/{sample}/mosdepth/{sample}_{unit}.regions.bed.gz.csi",
    log:
        "analysis_output/{sample}/mosdepth/{sample}_{unit}.log",
    container:
        config["tools"]["mosdepth"]
    threads: 4
    message:
        "{rule}: Calculating coverage for {wildcards.sample}_{wildcards.unit} using mosdepth"
    shell:
        "mosdepth "
        "-n "
        "-t {threads} "
        "--fast-mode "
        "--by 500 "
        "analysis_output/{wildcards.sample}/mosdepth/{wildcards.sample}_{wildcards.unit} "
        "{input.bam} &> {log}"
