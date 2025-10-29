process FILT_MIN_DP {
    tag "$vcf"

    input:
    path vcf
    val min_dp

    output:
    path "${vcf.baseName}_${filt_name}.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_${filt_name}_variants.count"), emit: variant_counts

    script:
    filt_name = "min_dp_${min_dp}"
    """
    # Filter for minimum depth
    bcftools filter -i "INFO/DP>=${min_dp}" ${vcf} -Ov -o ${vcf.baseName}_${filt_name}.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_${filt_name}.vcf | wc -l > ${vcf.baseName}_${filt_name}_variants.count

    # Clean up intermediate vcfs
    rm ${vcf}
    """
}