process convert {
  conda 'ngff_env.yml'
  publishDir '/tmp/zarrs'

  maxForks params.maxConvJobs
  disk params.maxConvJobDisk

  input:
  path imgfile
  output:
  path "${imgfile.baseName}.zarr"

  script:
  def outfile = "${imgfile.baseName}.zarr"
  """
  bioformats2raw ${imgfile}  \"${outfile}\"
  """
}

process upload {
  input:
  path zarr
  output:
  path zarr

  script:
  """
  aws --profile ${params.awsProfile} s3 sync ${zarr} s3://${params.bucket}/${zarr}
  """
}

process remove {
  input:
  path to_remove

  script:
  """
  fullpath=`readlink -z /tmp/zarrs/${to_remove}`
  rm -rf \"\$fullpath\"
  rm /tmp/zarrs//${to_remove}
  """
}

workflow {
    image_paths = Channel
    .fromPath(params.input)
    .splitCsv(header:false, sep:"\t")
    .map { file(it[params.column]) }

    convert(image_paths)
    upload(convert.out)
    if ( params.removeZarrs ) {
      remove(upload.out)
    }
}
