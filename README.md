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

Check this is working:

```
aws s3 --profile embassy ls idr/zarr/v0.4/idr0157/
```

Adjust configuration in [nextflow.config](https://github.com/dominikl/nf_ngff_conv/blob/main/nextflow.config).

## Run

Run it with:

```
nextflow run --input idr0157_paths.tsv --column 1 bf2raw.nf
```

(Where `--column 1` means that the second column contains the paths the images. It is assumed that the first column is the dataset name)

Note: `idr0157_paths.tsv` is an example and only contains the first dataset of idr0157.


Running `resave` conversion:

```
../nextflow run --input idr0054_images.tsv --column 1 --idrId idr0054 --modality "NCIT_C182027" --organism NCBI:txid9606 --name "idr0054" --shards "1,1,1,3072,3072" --chunks "1,1,1,1024,1024" resave.nf
```