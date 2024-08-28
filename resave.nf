process convert {
  // ignore stdout and stderr
  // errorStrategy 'ignore'
  conda 'ngff-challenge_env.yml'

  publishDir params.pubDir

  maxForks params.maxConvJobs
  disk params.maxConvJobDisk

  input:
  tuple val(outputzarr), val(inputzarr)

  output:
  path(outputzarr)

  """
  ome2024-ngff-challenge resave --input-bucket=bia-integrator-data --input-endpoint=https://uk1s3.embassy.ebi.ac.uk --input-anon "${inputzarr}" "${outputzarr}" --log error --rocrate-modality=${params.modality} --rocrate-organism=${params.organism} --rocrate-name=${params.name} --cc-by --output-shards=${params.shards} --output-chunks=${params.chunks}
  """
}

process upload {
  conda 'ngff-challenge_env.yml'

  input:
  path(outputzarr)

  output:
  path(outputzarr)

  script:
  """
  aws --profile ${params.awsProfile} s3 sync ${outputzarr} s3://${params.bucket}/${params.idrId}/${outputzarr}
  """
}

process remove {
  input:
  path(outputzarr)

  script:
  def pubdir = "${params.pubDir}"
  """
  dspath=`readlink -z ${pubdir}/${outputzarr}`
  rm -rf \"\$dspath\"/
  """
}

workflow {
    image_paths = Channel
    .fromPath(params.input)
    .splitCsv(header:false, sep:"\t")
    .map { tuple( it[0], it[params.column] ) }

    convert(image_paths)

    upload(convert.out)

    if ( params.removeZarrs ) {
      remove(upload.out)
    }
}
