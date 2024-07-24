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

Setup aws:
```
conda install awscli
aws configure --profile uk1s3
echo "endpoint_url = https://uk1s3.embassy.ebi.ac.uk" >> ~/.aws/config 
```

## Run

Create the work directory for NextFlow and adjust path in https://github.com/dominikl/nf_ngff_conv/blob/main/nextflow.config#L2

Create the directory where (links to) the generated zarrs will be stored (temporarily) and adjust path in https://github.com/dominikl/nf_ngff_conv/blob/main/ngff_workflow.nf#L1 

Then run:
```
./nextflow run  --input "https://raw.githubusercontent.com/dominikl/nf_ngff_conv/main/sample_filepaths.tsv" --column 1 --bucket "dlindner" ngff_workflow.nf
```

```
-- input [filpaths.tsv from IDR]
-- column [which column has the image paths, zero based]
-- bucket [name of the s3 bucket to upload to]
```

Note: If you want to keep the zarrs locally then just comment out the remove() step https://github.com/dominikl/nf_ngff_conv/blob/main/ngff_workflow.nf#L52 .
