process SPLIT_VCF {
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf
    path index

    output:
    path "*.vcf", emit: individual_vcfs

    script:
    """
    # Get list of samples
    bcftools query -l ${vcf} > samples.txt

    # Split VCF by sample
    while read sample; do
        bcftools view -c1 -s \$sample -Ov ${vcf} > \${sample}.vcf
    done < samples.txt
    """
}