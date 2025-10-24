# `OikosFilt`
A [NextFlow](https://www.nextflow.io/docs/latest/index.html)-enabled pipeline intended to streamline SNP discovery for `.vcf` files, with a focus on population genetics analysis.
Takes a single `.vcf` file as input (zipped or unzipped), along with user-designated filtering parameters, and outputs a single `.vcf` file, with a `csv` reporting variants removed after every step.

## Quickstart

The pipeline can be run on default filter parameters with the following command:

```
nextflow run OikosFilt.nf --vcf <input.vcf.gz> --prefix <output_prefix> -with_trace <output_prefix> -with-report <output_prefix>
```

- `--vcf` is the path to your variant file.
  - Mandatory
  - Can be compressed or uncompressed.
- `--prefix` is the name of the output files.
  - Optional
  - Defaults to `out`

## Options

All native options in `NextFlow` are usable in `OikosFilt` - their documentation can be found [here](https://www.nextflow.io/docs/latest/cli.html).
`-with-trace` and `-with-report` are useful for providing usage stats, and the author recommends enabling them.
The following table documents all options specific to `OikosMap`:

| Option | Default | Data type | Description |
| -- | -- | -- | -- |
| `--help`  | `FALSE` | Flag | Set to print a help message and exit. |
| `--vcf` | `null` | String | The path to the variant file to be filtered. |
| `--threads` | `nproc/2` | Int | The number of threads available to the program. Defaults to $\frac{1}{2}$ the number on the host machine. |
| `--bi_snps` | `TRUE` | Flag | Whether or not remove indels and multiallelic SNPs. Defaults to TRUE. |
| `--prefix` | `out` | String | The name of the output directory and vcf file. |


## High-level Description
`OikosFilt` initially removes indels and multiallelic SNPs using [`bcftools`](https://github.com/samtools/bcftools?tab=readme-ov-file.
It then writes results to a final output directory (`${prefix}_results/`) for the end-user to consume.

### Default filtering parameters

Coming soon.

### Outputs
OikosFilt produces two main outputs - a filtered `.vcf` and a `csv` summary file.
All outputs are written to `${prefix}_results/` in your working directory.

| Name | Description | Path |
| -- | -- | -- |
| Filtered VCF | VCF filtered according to your filtering parameters. | `${prefix}_results/${prefix}.vcf.gz` |
| Summary file | `csv` containing the number of variants removed by each filter step. | `${prefix}_results/${prefix}_variants_removed.csv` |

### Flowchart

<img title="OikosMap flowchart" alt="A graphic indicating the filtering process." src="images/OikosFilt_flowchart.png">


## Known limitations

## Installation and requirements

### Installation

The pipeline includes two dependencies: [NextFlow](https://www.nextflow.io/docs/latest/getstarted.html), and [Conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html).
You will need to install both of these for the pipeline to run.
[Docker](https://docs.docker.com/engine/install/) and [Singularity](https://docs.sylabs.io/guides/3.5/user-guide/introduction.html) are not currently supported.

### Testing

Testing behavior is contained within the `test` directory, and uses a combination of bash and the `nf-test` framework.
To set up, use the following code:
```
./tests/generate_expected.sh
nf-test test tests/main.nf.test
```

### Requirements

The `OikosMap` pipeline is undemanding, and will run on effectively any Linux environment.
It does not require GPU support.

## Runtime

Overall runtime scales roughly linearly with input data volume.
