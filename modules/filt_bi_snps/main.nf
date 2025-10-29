process GET_BI_SNPS {
    tag "$vcf"

    input:
    path vcf

    output:
    path "${vcf.baseName}_${filt_name}.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_${filt_name}_variants.count"), emit: variant_counts

    script:
    filt_name = "bi_snps"
    """
    # Filter for biallelic SNPs
    bcftools view -m2 -M2 -v snps ${vcf} -Ov -o ${vcf.baseName}_${filt_name}.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_${filt_name}.vcf | wc -l > ${vcf.baseName}_${filt_name}_variants.count

    # Clean up intermediate vcfs
    rm ${vcf}
    """
}