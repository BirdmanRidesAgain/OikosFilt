#!/bin/bash

# Create the expected output directory if it doesn't exist
mkdir -p tests/data/expected

# Generate the expected output using bcftools
bcftools view -m2 -M2 -v snps tests/data/small_subset.vcf.gz -Oz -o tests/data/expected/small_subset_bi_snps.vcf.gz

# Index the output file
bcftools index tests/data/expected/small_subset_bi_snps.vcf.gz