#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Import modules
include { SPLIT_VCF } from './modules/split_vcf'
include { GET_BI_SNPS } from './modules/bi_snps'
include { DEPTH_FILTER } from './modules/depth_filter'
include { QUALITY_FILTER } from './modules/qual_filter'
include { FILT_MIN_MAF } from './modules/filt_maf'
include { FILT_MAX_FMISSING } from './modules/filt_fmissing'
include { MERGE_VCFS } from './modules/merge_vcf'


workflow {
    main:
    log.info """\
      O I K O S F I L T - N F   P I P E L I N E
      ===================================
      vcf: ${params.vcf}
      bi_snps: ${params.bi_snps}
      min_dp: ${params.min_dp}
      prefix: ${params.prefix}
    """.stripIndent()

    if (!params.vcf) {
        error "Please provide a VCF file with --vcf"
    }

    // Input channel
    ch_vcf = Channel.fromPath(params.vcf)
    ch_vcf_index = Channel.fromPath("${params.vcf}.tbi").ifEmpty { null }

    // Split VCF into individual files
    SPLIT_VCF(ch_vcf, ch_vcf_index)

    // Determine input channel for depth filtering: use biallelic-filtered VCFs if requested,
    // otherwise use the split individual VCFs so DEPTH_FILTER always receives a valid channel.
    def ch_for_depth

    if (params.bi_snps) {
        GET_BI_SNPS(SPLIT_VCF.out.individual_vcfs.flatten())
        ch_for_depth = GET_BI_SNPS.out.filt_vcf.flatten()
    } else {
        ch_for_depth = SPLIT_VCF.out.individual_vcfs.flatten()
    }

    //workflow steps. Both depth and quality filtering are linked, conceptually
    DEPTH_FILTER(ch_for_depth, params.min_dp)
    QUALITY_FILTER(DEPTH_FILTER.out.filt_vcf, params.min_qual, params.min_gq)

    
    // Collect and merge filtered VCFs
    MERGE_VCFS(QUALITY_FILTER.out.filt_vcf.collect())
    FILT_MIN_MAF(MERGE_VCFS.out.filt_vcf, params.min_maf)
    FILT_MAX_FMISSING(FILT_MIN_MAF.out.filt_vcf, params.max_fmissing)

    publish:
    final_vcf = FILT_MAX_FMISSING.out.merged_vcf
}

output {
    final_vcf {}
}
