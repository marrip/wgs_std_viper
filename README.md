# wgs_std_viper

Simple workflow to map WGS data to reference genome according to GATK best practices

## :speech_balloon: Introduction

This snakemake workflow produces `.bam` files from Illumina NGS `.fastq` files. In addition,
a coverage analysis is performed and several alignment statistics are generated. The
pipeline can be run as is or may be included in another workflow.

## :heavy_exclamation_mark: Dependencies

To run this workflow, the following tools need to be available:

1. python ≥ 3.8
2. [snakemake](https://snakemake.readthedocs.io/en/stable/) ≥ 5.32.0
3. [Singularity](https://sylabs.io/docs/) ≥ 3.7

## :school_satchel: Preparations
