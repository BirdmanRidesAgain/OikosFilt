process GET_95ILE_DP{
    tag "$vcf"

    input:
    path vcf

    output:
    path "${vcf.baseName}_${filt_name}.vcf", emit: filt_vcf
    tuple val("${vcf.baseName}"), path("${vcf.baseName}_${filt_name}_variants.count"), emit: variant_counts

    script:
    filt_name = "95ile_dp"
    """
    # Calculate 95% percentile for DP
    ind_cov=\$(grep -v '^#' ${vcf} | awk '{print \$10}' FS='\t' OFS='\n' | cut -d: -f3 | grep -oE '[0-9]+')
    lower_bound=\$(echo "\$ind_cov" | tr ' ' '\n' | sort -n | awk 'BEGIN{q=0.025} {a[NR]=\$1} END {print a[int(NR*q)];}')
    upper_bound=\$(echo "\$ind_cov" | tr ' ' '\n' | sort -n | awk 'BEGIN{q=0.975} {a[NR]=\$1} END {print a[int(NR*q)];}')

    # Filter variants based on DP 95% CI
    bcftools filter -e "FORMAT/DP<\$lower_bound || FORMAT/DP>\$upper_bound" ${vcf} -Ov -o ${vcf.baseName}_${filt_name}.vcf

    # Count variants and save to file
    bcftools view -H ${vcf.baseName}_${filt_name}.vcf | wc -l > ${vcf.baseName}_${filt_name}_variants.count

    # Clean up intermediate vcfs
    rm ${vcf}
    """
}