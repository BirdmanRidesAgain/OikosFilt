include { FILT_95ILE_DP } from './filt_95ile_dp'
include { FILT_MIN_DP } from './filt_min_dp'

workflow DEPTH_FILTER {
    take:
    vcf_ch
    min_dp

    main:
    FILT_95ILE_DP(vcf_ch)
    //FILT_95ILE_DP.out.variant_counts.view { sample_name, count_file ->
    //"Sample: ${sample_name}, Variants: ${count_file.text.trim()}"
    //}
    FILT_MIN_DP(FILT_95ILE_DP.out.filt_vcf, min_dp)
    FILT_MIN_DP.out.variant_counts.view { sample_name, count_file ->
    "Sample: ${sample_name}, Variants: ${count_file.text.trim()}"
    }
    emit:
    filt_vcf = FILT_MIN_DP.out.filt_vcf
    variant_counts_95ile = FILT_95ILE_DP.out.variant_counts
    variant_counts_min_dp = FILT_MIN_DP.out.variant_counts
}