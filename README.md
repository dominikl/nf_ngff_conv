# nf_ngff_conv
Nextflow NGFF/ome.zarr conversion pipeline

## Setup

(See [Nextflow - Installation](https://www.nextflow.io/docs/latest/install.html))

Install java:
```
curl -s https://get.sdkman.io | bash
sdk install java 17.0.10-tem
```

Install nextflow:
```
curl -s https://get.nextflow.io | bash
chmod +x nextflow
```

Additionally:

Install conda:
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

Setup aws (example: EBI Embassy object storage):
```
conda install awscli
aws configure --profile embassy
echo "endpoint_url = https://uk1s3.embassy.ebi.ac.uk" >> ~/.aws/config 
```

## Run

Just an example using specific nextflow work directory `/data/dlindner/nextflow` and the [sample_filepaths.tsv](https://raw.githubusercontent.com/dominikl/nf_ngff_conv/main/sample_filepaths.tsv) (taken from IDR0154) with previously set up `embassy` AWS profile:
```
./nextflow run -work-dir "/data/dlindner/nextflow" --input "https://raw.githubusercontent.com/dominikl/nf_ngff_conv/main/sample_filepaths.tsv" --column 1 --awsProfile "embassy" --bucket "dlindner" ngff_workflow.nf
```

```
--input [filpaths.tsv from IDR]
--column [which column has the image paths, zero based]
--awsProfile [name of the aws profile to use]
--bucket [name of the s3 bucket to upload to]

Optional parameters:
-work-dir [path which nextflow should use as working directory]
--removeZarrs [true|false] Remove generated zarrs after upload (default: true)
--maxConvJobs [number of conversion jobs that can run at the same time] (default: 2)
--maxConvJobDisk [number of disk space a conversion job can use] (default: 1500 GB) 
```
(Note: The generated zarrs are sym-linked into /tmp/zarrs/, if they're not deleted of course)
