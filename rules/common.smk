import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("5.22.0")

### Set and validate config file


configfile: "config.yaml"


validate(config, schema="../schemas/config.schema.yaml")

### Read and validate samples file

samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = pd.read_table(config["units"], dtype=str).set_index(
    ["sample", "run", "lane"], drop=False
)
validate(units, schema="../schemas/units.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),


### Functions


def get_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample, wildcards.run, wildcards.lane), ["fq1", "fq2"]].dropna()
    return {"fwd": fastqs.fq1, "rev": fastqs.fq2}


def get_sample_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample), ["fq1", "fq2"]].dropna()
    return {"fwd": fastqs["fq1"].tolist(), "rev": fastqs["fq2"].tolist()}


def get_loci():
    with open(config["reference"]["loci"]) as f:
        return [line.rstrip() for line in f]


def get_all_bam(wildcards):
    return expand("analysis_output/{sample}/mark_duplicates/{sample}_{locus}.bam",
               sample=wildcards.sample,
               locus=get_loci(),
               )


def get_all_bam_fmt(wildcards):
    return " -I ".join(list(get_all_bam(wildcards)))
