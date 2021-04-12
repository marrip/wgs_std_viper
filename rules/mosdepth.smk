rule mosdepth:
    input:
        bam="analysis_output/{sample}/bwa/{sample}.bam",
        bai="analysis_output/{sample}/bwa/{sample}.bai",
    output:
        "analysis_output/{sample}/mosdepth/{sample}.mosdepth.global.dist.txt",
        "analysis_output/{sample}/mosdepth/{sample}.mosdepth.region.dist.txt",
        "analysis_output/{sample}/mosdepth/{sample}.mosdepth.summary.txt",
        "analysis_output/{sample}/mosdepth/{sample}.regions.bed.gz",
        "analysis_output/{sample}/mosdepth/{sample}.regions.bed.gz.csi",
    log:
        "analysis_output/{sample}/mosdepth/mosdepth.log",
    container:
        config["tools"]["mosdepth"]
    threads: 4
    message:
        "{rule}: Calculating coverage for {wildcards.sample} using mosdepth"
    shell:
        "mosdepth "
        "-n "
        "-t {threads} "
        "--fast-mode "
        "--by 500 "
        "analysis_output/{wildcards.sample}/mosdepth/{wildcards.sample} "
        "{input.bam} &> {log}"
