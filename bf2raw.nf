process convert {
  conda 'bf2raw_env.yml'

  publishDir params.pubDir

  maxForks params.maxConvJobs
  disk params.maxConvJobDisk

  input:
  tuple val(dataset), path(imgfile)

  output:
  tuple (path(dataset), path("${dataset}/${imgfile.baseName}.zarr"))
  script:
  def outfile = "${dataset}/${imgfile.baseName}.zarr"
  """
  mkdir \"${dataset}\"
  bioformats2raw --memo-directory /tmp ${imgfile}  \"${outfile}\"
  """
}

process upload {
  conda 'bf2raw_env.yml'

  input:
  tuple path(dataset), path(img)

  output:
  tuple(path(dataset), path(img))

  script:
  """
  aws --profile ${params.awsProfile} s3 sync ${img} s3://${params.bucket}/${dataset}/${img}
  """
}

process remove {
  input:
  tuple path(dataset), path(img)

  script:
  def pubdir = "${params.pubDir}"
  """
  fullpath=`readlink -z ${pubdir}/${dataset}/${img}`
  rm -rf \"\$fullpath\"
  """
}

workflow {
    image_paths = Channel
    .fromPath(params.input)
    .splitCsv(header:false, sep:"\t")
    .map { tuple( it[0].replaceAll('Dataset:name:',''), file(it[params.column]) ) }

    convert(image_paths)

    upload(convert.out)

    if ( params.removeZarrs ) {
      remove(upload.out)
    }
}
