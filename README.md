# nf_ngff_conv
Nextflow NGFF/ome.zarr conversion pipeline

## Installation

###  Prerequisite

#### Install Nextflow:
(For details see [Nextflow - Installation](https://www.nextflow.io/docs/latest/install.html))

Install java:
```
curl -s https://get.sdkman.io | bash
sdk install java 17.0.10-tem
```

Get nextflow binary:
```
curl -s https://get.nextflow.io | bash
chmod +x nextflow
```

Additionally:

#### Install conda:
(For details see [Installing Miniconda](https://docs.anaconda.com/miniconda/miniconda-install/))
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

#### Install AWS cli
(For details see [conda-forge / packages / awscli](https://anaconda.org/conda-forge/awscli))
```
conda install awscli
```

### Clone repository

```
git clone https://github.com/dominikl/nf_ngff_conv.git
cd nf_ngff_conv
```

## Setup

Setup AWS access (example: EBI Embassy object storage):
```
aws configure --profile embassy
echo "endpoint_url = https://uk1s3.embassy.ebi.ac.uk" >> ~/.aws/config 
```

Adjust configuration in [nextflow.config](https://github.com/dominikl/nf_ngff_conv/blob/main/nextflow.config).

## Run

Example using the [sample_filepaths.tsv](https://raw.githubusercontent.com/dominikl/nf_ngff_conv/main/sample_filepaths.tsv) (taken from IDR0154) with the previously set up `embassy` AWS profile:
```
nextflow run --input "https://raw.githubusercontent.com/dominikl/nf_ngff_conv/main/sample_filepaths.tsv" --column 1 ngff_workflow.nf
```

```
--input [filpaths.tsv from IDR]
--column [which column has the image paths, zero based]
```
(Note: The generated zarrs are sym-linked into /tmp/zarrs/, if they're not deleted of course)
