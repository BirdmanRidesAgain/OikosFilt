process FILT_MIN_GQ {
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf
    val min_gq

    output:
    path "${vcf.baseName}_${filt_name}.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_${filt_name}_variants.count"), emit: variant_counts

    script:
    filt_name = "min_gq_${min_gq}"
    """
    # Filter for minimum depth
    bcftools filter -i "MIN(FORMAT/GQ)>${min_gq}" ${vcf} -Ov -o ${vcf.baseName}_${filt_name}.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_${filt_name}.vcf | wc -l > ${vcf.baseName}_${filt_name}_variants.count
    """
}