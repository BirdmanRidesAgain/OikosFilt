include { FILT_MIN_MAF } from './filt_min_maf'
include { FILT_MAX_FMISSING } from './filt_max_fmissing'

workflow GROUP_FILTER {
    take:
    vcf_ch
    min_maf
    max_fmissing

    main:
    FILT_MIN_MAF(vcf_ch, min_maf)
    FILT_MAX_FMISSING(FILT_MIN_MAF.out.filt_vcf, max_fmissing)

    emit:
    filt_vcf = FILT_MAX_FMISSING.out.filt_vcf
    variant_counts_min_qual = FILT_MIN_MAF.out.variant_counts
    variant_counts_min_gq = FILT_MAX_FMISSING.out.variant_counts
}
