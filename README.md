Parabricks-NextFlow
-------------------
August 2023

# Overview
This repo contains experimental code for running Nvidia Clara Parabricks in NextFlow.


# Getting Started
After cloning this repository, you'll need to download the Parabricks container from [NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/clara/containers/clara-parabricks), and update the local.nf.conf with the correct container TAG, as well as a Parabricks cloud-compatible docker container to run. In addition, you should have at least one Parabricks compatible GPU, 12 CPU cores, and 64 GB of RAM to expect to be able to test. Two GPUs are required
for running Parabricks in production.

## Set up and environment
Parabricks-nextflow requires the following dependencies:
- Docker
- nvidia-docker
- NextFlow

After installing these tools, you will need a cloud-compatible Parabricks container from [NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/clara/containers/clara-parabricks).


## Running fq2bam locally

The Parabricks fq2bam tool is an accelerated BWA mem implementation. The tool also includes BAM sorting, duplicate marking, and optionally Base Quality Score Recalibration (BQSR). The `fq2bam.nf` script in this repository demonstrates how to run this tool with a set of input reads, producing a BAM file, its BAI index and a BQSR report for use with HaplotypeCaller.

Below is an example command line for running the fq2bam.nf script:

```bash
~/nextflow run \
    -c config/local.nf.conf \
    -params-file example_inputs/test.fq2bam.json \
    -with-docker 'gcr.io/clara-lifesci/parabricks-cloud:4.0.0-1.beta4' \
    nexflow/fq2bam.nf
```

Note the following:
- The config/local.nf.conf configuration file defines the GPU-enabled local label and should be passed for local runs.
- The `-with-docker` command is required and should point to a valid Parabricks cloud-compatible Docker container. It must have no Entrypoint (i.e., `ENTRYPOINT bash`) and one should note the path to Parabricks within the container.
- The `-params-file` argument allows using a JSON stub for program arguments (rather than the command line). We recommend this way of invoking nextflow as it is easier to debug and more amenable to batch processing.

### Running the germline example

```bash
~/nextflow run \
    -c config/local.nf.conf \
    -params-file example_inputs/test.germline.json \
    -with-docker 'gcr.io/clara-lifesci/parabricks-cloud:4.0.0-1.beta4' \
    nextflow/germline_calling.nf
```
### Running the DeepVariant example

```nextflow run \
    -c config/local.nf.conf \
    -params-file example_inputs/test.deepvariant.json \
    nextflow/deepvariant.nf \
    --mode 'shortread' \
    --deepvariant_args "-L chr1 -L chr2:10000"
```
The `--deepvariant_args` helps you use come of DeepVariant options. In this example we added `-L` with the interval within which to call the variants from the BAM/CRAM file. 


