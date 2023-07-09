#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/**
 * Clara Parabricks NextFlow
 * deepvariant.nf
*/


/**
* Inputs
*/
params.inputBam = null
params.inputRef = null
params.mode = "shortread"
params.outputName = null
params.deepvariant_args = null

params.inputSampleName = null
params.readGroupName = null
params.platformName = null

params.pbPATH = "pbrun"


// Show help message
//if (params.help) {
//}

process deepVariant {
    label 'localGPU'

    publishDir "${params.outdir}", mode: 'copy' , pattern: "*"

    input:
    path inputBam
    path inputRef
    val mode
    val pbPATH
    val tmpDir

    output:
      path "${inputBam.baseName}.vcf"

    script:
    def deepvariant_args = params.deepvariant_args ?: ''
    """
    mkdir -p ${tmpDir} && \
    time ${pbPATH} deepvariant \
    --tmp-dir ${tmpDir} \
    --in-bam ${inputBam} \
    --ref ${inputRef} \
    ${deepvariant_args} \
    --out-variants ${inputBam.baseName}.vcf \
    --mode ${mode}
    """

}

workflow ClaraParabricks_deepVariant {

    deepVariant( inputBam=params.inputBam,
            inputRef=params.inputRef,
	    mode=params.mode,
            pbPATH=params.pbPATH,
            tmpDir=params.tmpDir
	)
}

workflow {
    ClaraParabricks_deepVariant()
}

workflow.onComplete {
	println "\nDone"
}

