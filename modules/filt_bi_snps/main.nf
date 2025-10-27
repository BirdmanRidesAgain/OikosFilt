process GET_BI_SNPS {
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf

    output:
    path "${vcf.baseName}_filt.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_variants.count"), emit: variant_counts

    script:
    """
    # Filter for biallelic SNPs
    bcftools view -m2 -M2 -v snps ${vcf} -Ov -o ${vcf.baseName}_filt.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_filt.vcf | wc -l > ${vcf.baseName}_variants.count
    """
}