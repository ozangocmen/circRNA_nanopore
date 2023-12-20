#!/usr/bin/env nextflow

// User-defined variables
params.input_fastq = "/path/to/your/input_fastq.fastq"
params.output_parent_dir = "/path/to/your/output_parent_dir"
params.reference_genome = "/path/to/your/reference_genome.fa"
params.annotation_gtf = "/path/to/your/annotation.gtf"
params.bed_file = "/path/to/your/bed_file.bed"
params.threads = 8

// List of barcodes (replace with your actual barcode list)
barcodes = ["barcode1", "barcode2", "barcode3", "barcode4", "barcode5", "barcode6"]
// Add more barcodes as needed

// Define the process for running CIRI-long call
process runCIRILongCall {
    input:
    val barcode from barcodes

    output:
    path "${params.output_parent_dir}/CRlong_${barcode}" into outputDir

    script:
    """
    CIRI-long call -i ${params.input_fastq} \
                   -o ${outputDir} \
                   -r ${params.reference_genome} \
                   -p ${barcode} \
                   -a ${params.annotation_gtf} \
                   -c ${params.bed_file} \
                   -t ${params.threads}
    """
}

// Define the process for creating the sample list file
process createSampleList {
    input:
    val barcode from barcodes

    output:
    path "${params.output_parent_dir}/CRlong_${barcode}/${barcode}.cand_circ.fa" into candCircDir

    script:
    """
    mv ${params.output_parent_dir}/CRlong_${barcode}/${barcode}.cand_circ.fa ${candCircDir}
    """
}

// Define the process for running CIRI-long collapse
process runCIRILongCollapse {
    input:
    path sampleListFile from candCircDir

    output:
    path "${params.output_parent_dir}/collapse" into collapseOutputDir

    script:
    """
    CIRI-long collapse -i ${sampleListFile} \
                      -o ${collapseOutputDir} \
                      -r ${params.reference_genome} \
                      -a ${params.annotation_gtf} \
                      -t ${params.threads}
    """
}

// Define the process for generating BED file from CIRI-long collapse output
process generateBedFile {
    input:
    path "${params.output_parent_dir}/collapse/collapsed_output.info" into infoFile
    path "${params.output_parent_dir}/collapse/collapsed_output.bed" into bedOutputDir

    script:
    """
    cat ${infoFile} | cut -d' ' -f2 > ${bedOutputDir}/collapsed_output.bed
    """
}

// Define the process for converting circRNA.info to bed format
process convertToBed {
    input:
    val barcode from barcodes
    path collapseOutputInfo from collapseOutputDir

    output:
    path "${params.output_parent_dir}/${barcode}_circ.bed" into bedOutputDir

    script:
    """
    python3 misc/convert_bed.py ${collapseOutputInfo}/${barcode}_collapse.info ${bedOutputDir}/${barcode}_circ.bed
    """
}

// Define the process for visualizing BED file in IGV
process visualizeInIGV {
    input:
    path bedFile from bedOutputDir

    script:
    """
    igv -g ${params.reference_genome} -b ${bedFile}
    """
}

// Run the workflow
workflow {
    // Run CIRI-long call for all barcodes in parallel
    runCIRILongCall

    // Move and create the sample list file for all barcodes in parallel
    createSampleList

    // Run CIRI-long collapse for the created sample list
    runCIRILongCollapse

    // Generate BED file from CIRI-long collapse output
    generateBedFile

    // Convert circRNA.info to BED format
    convertToBed

    // Visualize BED file in IGV
    visualizeInIGV
}
