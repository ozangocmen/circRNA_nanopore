# Head and Neck Cancer circRNAs bioinformatics analysis
**Project Report:** Investigation of Potential Biomarker circular RNA Molecules in Head and Neck Squamous Cell Carcinoma Cell Culture

**Analysis/Writing : Ozan GÖÇMEN**, *Bioinformatics Intern*

**Corrections/Validations : Yasin KAYMAZ**, Ph.D, *Principal Investigator of BMGLab*

## Project Description

The primary objective of this research attempt was to systematically assess circular RNAs derived from human healthy oral tissue and oral squamous carcinoma cell cultures, encompassing a total of six distinct samples separated by unique barcodes employing the high-throughput sequencing technology provided by Oxford Nanopore Technologies. The focus was on employing bioinformatics analyses to identify and characterize these circular RNA molecules across six unique samples with distinct barcodes. The analytical framework applied in this study involved state-of-the-art bioinformatics methods, which were meticulously employed to discriminate, categorize, and characterize circular RNAs from the vast and complex sequencing data.

This process was carried out in the following stages:

- First, a quality check of the raw data was performed after concatenate all fastq files in their barcode.(It is expressed with `barcode**_cat`in figure 3.)
- Following the quality control, a bwa index for reference genome generated with human genome of hg38 (Homo_sapiens.GRCh38)
- Circular RNA identification (1) and isoform collapsing (2) operations for long-reads nanopore sequencing data done with using CIRI-long.
- CIRI-long provided additional circRNA annotations in BED/GTF format for BSJ correction. circRNA annotations downloaded from circAtlas 3.0
- Finally; healthy(1-4), carcinoma(2-5) and radioresistant carcinoma(3-6) samples were processed through the pipeline group by group in order to be compared with each other. It was stored in BED (Browser Extensible Data) format for visualization on IGV (integrative genomics viewer).

Below is a representation of the key points from the bioinformatics pipeline use to obtain potential circRNA biomarkers.
![pipeline](/pipeline.png "pipeline")
