process MERGE_VCFS {
    tag "merge_vcfs"
    publishDir "${params.outdir}", mode: 'copy'
    conda 'bioconda::bcftools'

    input:
    path vcfs

    output:
    path "merged_filtered.vcf.gz", emit: merged_vcf

    script:
    """
    # Compress all VCF files in parallel
    parallel bgzip ::: *.vcf
    
    # Index all compressed VCF files in parallel
    parallel bcftools index ::: *.vcf.gz
    
    # Create list of VCF files
    ls *.vcf.gz > vcf_list.txt

    # Merge VCF files
    bcftools merge -l vcf_list.txt -Oz > merged_filtered.vcf.gz
    """
}