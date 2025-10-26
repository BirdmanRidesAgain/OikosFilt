process FILT_MIN_QUAL {
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf
    val min_qual

    output:
    path "${vcf.baseName}_filt.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_variants.count"), emit: variant_counts

    script:
    """
    # Filter for minimum depth
    bcftools filter -i "MIN(QUAL)>${min_qual}" ${vcf} -Ov -o ${vcf.baseName}_filt.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_filt.vcf | wc -l > ${vcf.baseName}_variants.count
    """
}