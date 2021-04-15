# wgs_std_viper

Simple workflow to map WGS data to reference genome according to GATK best practices

## :speech_balloon: Introduction

This snakemake workflow produces `.bam` files from Illumina NGS `.fastq` files. It is
designed to align WGS data from paired end sequencing runs. In addition,
a coverage analysis is performed and several alignment statistics are generated. The
pipeline can be run as is or may be included in another workflow.

## :heavy_exclamation_mark: Dependencies

To run this workflow, the following tools need to be available:

1. python ≥ 3.8
2. [snakemake](https://snakemake.readthedocs.io/en/stable/) ≥ 5.32.0
3. [Singularity](https://sylabs.io/docs/) ≥ 3.7

## :school_satchel: Preparations

### Sample data

1. Add all sample ids to `samples.tsv` in the column `sample`.
2. Add all sample data information to `units.tsv`. Each row represents a `fastq` file pair with
corresponding forward and reverse reads. Also indicate the sample id, run id and lane number
3. Ref
