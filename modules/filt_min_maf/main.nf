process FILT_MIN_MAF{
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf
    val min_maf

    output:
    path "${vcf.baseName}_filt.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_variants.count"), emit: variant_counts

    script:
    """
    # Filter variants based on minor allele frequency
    bcftools view -i "MAF > ${min_maf}" ${vcf} -Ov -o ${vcf.baseName}_filt.vcf
    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_filt.vcf | wc -l > ${vcf.baseName}_variants.count
    """
}