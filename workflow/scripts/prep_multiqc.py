#!/usr/bin/env python
# -*- coding: utf-8 -*-

import csv
import logging
from os.path import basename
import yaml

def config(fp):
    config = {
        "show_analysis_paths": False,
        "extra_fn_clean_exts": [
            ".metrics",
            {
                "type":"regex",
                "pattern":"_R[12]",
            },
        ],
    }
    with open(fp, "wt") as yaml_file:
        yaml.dump(config, yaml_file, default_flow_style=False)
    return


def get_tsv_data(fp):
    tsv = open(fp)
    tsv_reader = csv.reader(tsv, delimiter="\t")
    i = 0
    tsv_dicts = []
    keys = []
    for row in tsv_reader:
        if i == 0:
            keys = row
        else:
            row_dict = {}
            for j in range(0, len(row)):
                row_dict[keys[j]] = row[j]
            tsv_dicts.append(row_dict)
        i=+1
    tsv.close()
    return tsv_dicts

def get_filename(fp):
    return basename(fp).replace(".fq.gz", "").replace(".fastq.gz", "")

def write_sample_name_file(data, fp):
    tsv = open(fp, "wt")
    tsv_writer = csv.writer(tsv, delimiter="\t")
    for row in data:
        fwd = get_filename(row["fq1"])
        tsv_writer.writerow([fwd, "_".join((row["sample"], row["unit"], fwd))])
        rev = get_filename(row["fq2"])
        tsv_writer.writerow([rev, "_".join((row["sample"], row["unit"], rev))])
    tsv.close()
    return

def replace_names(input_fp, output_fp):
    tsv_data = get_tsv_data(input_fp)
    write_sample_name_file(tsv_data, output_fp)
    return

logging.basicConfig(level=logging.INFO, filename=snakemake.log[0])
config(snakemake.output["config"])
replace_names(snakemake.input[0], snakemake.output["ids"])
