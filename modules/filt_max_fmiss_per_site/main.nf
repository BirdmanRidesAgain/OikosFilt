process FILT_MAX_FMISS_PER_SITE{
    tag "$vcf"

    input:
    path vcf
    val max_fmiss_site

    output:
    path "${vcf.baseName}_${filt_name}.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_${filt_name}_variants.count"), emit: variant_counts

    script:
    filt_name = "max_fmiss_per_site_${max_fmiss_site}"
    """
    # Filter variants based on maximum amount of missing data
    bcftools view -i "F_MISSING < ${max_fmiss_site}" ${vcf} -Ov -o ${vcf.baseName}_${filt_name}.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_${filt_name}.vcf | wc -l > ${vcf.baseName}_${filt_name}_variants.count

    # Clean up intermediate vcfs
    rm ${vcf}
    """
}