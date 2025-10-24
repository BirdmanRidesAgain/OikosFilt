process MERGE_VCFS {
    tag "merge_vcfs"
    publishDir "${params.outdir}", mode: 'copy'

    input:
    path vcfs

    output:
    path "merged_filtered.vcf", emit: merged_vcf

    script:
    """
    # Create list of VCF files
    ls *.vcf > vcf_list.txt

    # Merge VCF files
    bcftools merge -l vcf_list.txt -Ov > merged_filtered.vcf
    """
}