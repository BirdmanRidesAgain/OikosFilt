def PRINT_HELP() {
    def message='''
    Basic Usage:
    OikosMap --vcf path/to/variants.vcf --prefix output_name [options]
    For full parameter list, see README.md
    '''
    log.info message.stripIndent()
}