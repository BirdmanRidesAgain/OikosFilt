include { FILT_MIN_QUAL } from './filt_min_qual'
include { FILT_MIN_GQ } from './filt_min_gq'

workflow QUALITY_FILTER {
    take:
    vcf_ch
    min_qual
    min_gq

    main:
    FILT_MIN_QUAL(vcf_ch, min_qual)
    FILT_MIN_GQ(FILT_MIN_QUAL.out.filt_vcf, min_gq)

    emit:
    filt_vcf = FILT_MIN_QUAL.out.filt_vcf
    variant_counts_min_qual = FILT_MIN_QUAL.out.variant_counts
    variant_counts_min_gq = FILT_MIN_GQ.out.variant_counts
}
