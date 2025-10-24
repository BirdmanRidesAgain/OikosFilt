process FILT_MIN_DP {
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf
    val min_dp

    output:
    path "${vcf.baseName}_filt.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_variants.count"), emit: variant_counts

    script:
    """
    # Filter for minimum depth
    bcftools filter -i "FORMAT/DP>=${min_dp}" ${vcf} -Ov -o ${vcf.baseName}_filt.vcf
    # Count variants and save to file
    bcftools view -H ${vcf} | wc -l > ${vcf.baseName}_variants.count
    """
}