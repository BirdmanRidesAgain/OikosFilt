process COMPRESS_VCF {
    tag "$vcf"

    input:
    path vcf

    output:
    path "${vcf.baseName}.vcf.gz", emit: filt_vcf

    script:
    """
    # Compress all VCF files in parallel
    bgzip ${vcf}
    """
}