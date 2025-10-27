#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Import modules
include { SPLIT_VCF } from './modules/split_vcf'
include { GET_BI_SNPS } from './modules/filt_bi_snps'
include { DEPTH_FILTER } from './modules/depth_filter'
include { QUALITY_FILTER } from './modules/qual_filter'
include { GROUP_FILTER } from './modules/group_filter'
include { MERGE_VCFS } from './modules/merge_vcf'


workflow {
    main:
    log.info """\
        O I K O S F I L T - N F   P I P E L I N E
        ===================================
        vcf: ${params.vcf}
        prefix: ${params.prefix}
        threads = ${params.threads}
        bi_snps: ${params.bi_snps}
        min_dp: ${params.min_dp}
        dp_95ile = ${params.dp_95ile}
        min_dp = ${params.min_dp}
        min_qual = ${params.min_qual}
        min_gq = ${params.min_gq}
        min_maf = ${params.min_maf}
        max_fmissing = ${params.max_fmissing}
    """.stripIndent()

    if (!params.vcf) {
        error "Please provide a VCF file with --vcf"
    }

    // Input channel
    ch_vcf = Channel.fromPath(params.vcf)

    // Split VCF into individual files
    SPLIT_VCF(ch_vcf)

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

    
    // Merge VCFs and apply group-level filters, if desired
    MERGE_VCFS(QUALITY_FILTER.out.filt_vcf.collect(), params.prefix)

    def ch_final_vcf
    if (params.min_maf || params.max_fmissing) {
        GROUP_FILTER(MERGE_VCFS.out.filt_vcf, params.min_maf, params.max_fmissing)
        ch_final_vcf = GROUP_FILTER.out.filt_vcf
    } else {
        ch_final_vcf = MERGE_VCFS.out.filt_vcf
    }

    publish:
    final_vcf = ch_final_vcf
}

output {
    final_vcf {}
}
