process FILT_MAX_FMISSING{
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf
    val max_fmissing

    output:
    path "${vcf.baseName}_filt.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_variants.count"), emit: variant_counts

    script:
    """
    # Filter variants based on maximum amount of missing data
    bcftools view -i "F_MISSING < ${max_fmissing}" ${vcf} -Ov -o ${vcf.baseName}_filt.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_filt.vcf | wc -l > ${vcf.baseName}_variants.count
    """
}