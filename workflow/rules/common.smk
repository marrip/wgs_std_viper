from os.path import dirname
import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("5.32.0")

### Set and validate config file


configfile: "config.yaml"


validate(config, schema="../schemas/config.schema.yaml")


### Read and validate samples file

samples = pd.read_table(config["samples"], dtype=str).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = pd.read_table(config["units"], dtype=str).sort_values(
    ["sample", "unit"], ascending=False
)
units["run"].replace("_", "-", regex=True, inplace=True)
units = units.set_index(["sample", "unit", "run", "lane"], drop=False).sort_index()

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),


### Functions


def get_fastq(wildcards):
    fastqs = units.loc[
        (wildcards.sample, wildcards.unit, wildcards.run, wildcards.lane),
        ["fq1", "fq2"],
    ].dropna()
    return {"fwd": fastqs.fq1, "rev": fastqs.fq2}


def get_sample_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    return {"fwd": fastqs["fq1"].tolist(), "rev": fastqs["fq2"].tolist()}


def get_loci():
    with open(config["reference"]["loci"]) as f:
        return [line.rstrip() for line in f]


def get_all_bam(wildcards):
    return expand(
        "analysis_output/{sample}/apply_bqsr/{sample}_{unit}_{locus}.bam",
        sample=wildcards.sample,
        unit=wildcards.unit,
        locus=get_loci(),
    )


def get_all_bam_fmt(wildcards):
    return " -I ".join(list(get_all_bam(wildcards)))


def get_multiqc_files(wildcards):
    input_list = []
    files = {
        "collect_multiple_metrics": [
            "alignment_summary_metrics",
            "base_distribution_by_cycle_metrics",
            "base_distribution_by_cycle.pdf",
            "insert_size_metrics",
            "insert_size_histogram.pdf",
            "quality_by_cycle_metrics",
            "quality_by_cycle.pdf",
            "quality_distribution_metrics",
            "quality_distribution.pdf",
        ],
        "collect_alignment_summary_metrics": [
            "alignment_summary_metrics",
            "base_distribution_by_cycle_metrics",
            "base_distribution_by_cycle.pdf",
            "gc_bias.detail_metrics",
            "gc_bias.summary_metrics",
            "gc_bias.pdf",
            "insert_size_metrics",
            "insert_size_histogram.pdf",
            "quality_by_cycle_metrics",
            "quality_by_cycle.pdf",
            "quality_distribution_metrics",
            "quality_distribution.pdf",
        ],
        "collect_duplicate_metrics": [
            "metrics",
        ],
        "collect_wgs_metrics": [
            "txt",
        ],
        "gather_bam_files": [
            "bam",
        ],
        "mosdepth": [
            "mosdepth.global.dist.txt",
            "mosdepth.region.dist.txt",
            "mosdepth.summary.txt",
            "regions.bed.gz",
            "regions.bed.gz.csi",
        ],
        "samtools_stats": [
            "txt",
        ],
    }
    #for row in units.loc[
    #    wildcards.sample, ["sample", "unit", "run", "lane"]
    #].iterrows():
    #    input_list.append(
    #        "analysis_output/%s/fastqc/%s_%s_%s_%s"
    #        % (
    #            row[1]["sample"],
    #            row[1]["sample"],
    #            row[1]["unit"],
    #            row[1]["run"],
    #            row[1]["lane"],
    #        )
    #    )
    for row in (
        units.loc[wildcards.sample, ["sample", "unit"]].drop_duplicates().iterrows()
    ):
        for key in files.keys():
            input_list = input_list + expand(
                "analysis_output/{sample}/{tool}/{sample}_{unit}.{ext}",
                sample=row[1]["sample"],
                tool=key,
                unit=row[1]["unit"],
                ext=files[key],
            )
    return input_list
