process FILT_MAX_FMISSING{
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf
    val max_fmissing

    output:
    path "${vcf.baseName}_${filt_name}.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_${filt_name}_variants.count"), emit: variant_counts

    script:
    filt_name = "max_fmissing_${max_fmissing}"
    """
    # Filter variants based on maximum amount of missing data
    bcftools view -i "F_MISSING < ${max_fmissing}" ${vcf} -Ov -o ${vcf.baseName}_${filt_name}.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_${filt_name}.vcf | wc -l > ${vcf.baseName}_${filt_name}_variants.count
    """
}