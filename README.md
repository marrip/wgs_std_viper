# wgs_std_viper

Simple workflow to map WGS data to reference genome according to GATK best practices

## :speech_balloon: Introduction

This snakemake workflow produces `.bam` files from Illumina NGS `.fastq` files. It is
designed to align WGS data from paired end sequencing runs. In addition, a coverage
analysis is performed and several alignment statistics as well as a FastQC report are
generated. The pipeline can be run as is or may be included in other workflows.

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

### Reference data

1. You need a reference `.fasta` file to map your reads to. For the different tools to work, you also
need to index the file like so:

```bash
bwa index /path/to/reference.fasta
samtools faidx /path/to/reference.fasta
gatk CreateSequenceDictionary -R /path/to/reference.fasta -O /path/to/reference.dict
```

is this still part of 1.?
2.
