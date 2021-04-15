# wgs_std_viper

![Snakefmt](https://github.com/marrip/wgs_std_viper/actions/workflows/main.yaml/badge.svg)

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
corresponding forward and reverse reads. Also indicate the sample id, run id and lane number.

### Reference data

1. You need a reference `.fasta` file to map your reads to. For the different tools to work, you also
need to prepare index files and a `.dict` file.
  - The required files for the human reference genome GRCh38 can be downloaded from
  [google cloud](https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0).
  The download can be manually done using the browser or using `gsutil` via the command line:
```
gsutil cp gs://genomics-public-data/resources/broad/hg38/v0/Homo_sapiens_assembly38.fasta /path/to/download/dir/
```
  - If those resources are not available for your reference you may generate them yourself:
```
bwa index /path/to/reference.fasta
samtools faidx /path/to/reference.fasta
gatk CreateSequenceDictionary -R /path/to/reference.fasta -O /path/to/reference.dict
```

2. For the task `BaseRecalibrator` we use a `.vcf` containing known indels. For GRCh38, this is
available at google as well.
3. To generate a WGS metrics report, the task `CollectWgsMetrics` requires a intervals file which is
also available at google cloud.
4. For parallel processing, the `.bam` file is split by chromosome depending on a `.txt` file containing
a list with chromosome ids. **Chromosome which are not included in this file will be excluded downstream!**
5. Add the paths of the different files to the `config.yaml`. Index files and the `.dict` file should be
in the same directory as the reference `.fasta`.
6. Make sure that adapter sequences and docker container versions are correct.

## :white_check_mark: Testing

The workflow repository contains a small test dataset `.tests/integration` which can be run like so:

```
cd .tests/integration
snakemake -s ../../Snakefile -j1 --use-singularity
```

## :rocket: Usage

The workflow is designed for WGS data meaning huge datasets which require a lot of compute power. For
HPC clusters, it is recommended to use a cluster profile and run something like:

```
snakemake -s /path/to/Snakefile --profile my-awesome-profile
```
