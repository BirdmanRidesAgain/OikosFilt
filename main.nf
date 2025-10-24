#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Import modules
include { SPLIT_VCF } from './modules/split_vcf/main'
include { GET_BI_SNPS } from './modules/bi_snps/main'
include { MERGE_VCFS } from './modules/merge_vcf/main'

/* 
 * main script flow
 */

workflow {
    main:
    log.info """\
      O I K O S F I L T - N F   P I P E L I N E
      ===================================
      vcf: ${params.vcf}
      bi_snps: ${params.bi_snps}
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

    // Process each individual VCF to get biallelic SNPs
    GET_BI_SNPS(SPLIT_VCF.out.individual_vcfs.flatten())

    // Collect and merge filtered VCFs
    MERGE_VCFS(GET_BI_SNPS.out.bi_vcf.collect())

    publish:
    final_vcf= MERGE_VCFS.out.merged_vcf
}

output {
    final_vcf {
        
    }
}
