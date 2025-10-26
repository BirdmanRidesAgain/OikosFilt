process FILT_95CI_DP{
    tag "$vcf"
    conda 'bioconda::bcftools'

    input:
    path vcf

    output:
    path "${vcf.baseName}_dp95ci.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_variants.count"), emit: variant_counts

    script:
    """
    # Calculate 95% confidence interval for DP
    dp_stats=\$(bcftools query -f '%DP\n' ${vcf} | awk '{sum+=\$1; sumsq+=\$1*\$1} END {mean=sum/NR; sd=sqrt(sumsq/NR - mean*mean); ci95=1.96*sd/sqrt(NR); print mean-ci95, mean+ci95}')
    echo \$dp_stats
    lower_bound=\$(echo \$dp_stats | cut -d' ' -f1 | awk '{if (\$1<0) print 0; else print \$1}')
    upper_bound=\$(echo \$dp_stats | cut -d' ' -f2)

    # Filter variants based on DP 95% CI
    bcftools filter -e "FORMAT/DP<\$lower_bound || FORMAT/DP>\$upper_bound" ${vcf} -Ov -o ${vcf.baseName}_dp95ci.vcf
    # Count variants and save to file
    bcftools view -H ${vcf} | wc -l > ${vcf.baseName}_variants.count
    """
}