params.outdir = 'results'

process GET_BI_SNPS {
    tag "$vcf"
    publishDir "${params.outdir}/bi_snps", mode: 'copy'

    input:
    path vcf

    output:
    path "${vcf.baseName}_bi.vcf", emit: bi_vcf

    script:
    """
    # Filter for biallelic SNPs
    bcftools view -m2 -M2 -v snps ${vcf} > ${vcf.baseName}_bi.vcf
    """
}