process FILT_MIN_QUAL {
    tag "$vcf"

    input:
    path vcf
    val min_qual

    output:
    path "${vcf.baseName}_${filt_name}.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_${filt_name}_variants.count"), emit: variant_counts

    script:
    filt_name = "min_qual_${min_qual}"
    """
    # Filter for minimum depth
    bcftools filter -i "MIN(QUAL)>${min_qual}" ${vcf} -Ov -o ${vcf.baseName}_${filt_name}.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_${filt_name}.vcf | wc -l > ${vcf.baseName}_${filt_name}_variants.count

    # Clean up intermediate vcfs
    rm ${vcf}
    """
}