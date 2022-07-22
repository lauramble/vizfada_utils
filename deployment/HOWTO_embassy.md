# How to deploy VizFaDa on Embassy

### Requirements
- kubectl
- access to Embassy k8s cluster

### Step 1: Organize your processed data

VizFaDa's back-end relies on a specific data structure to fetch relevant data. This guide assumes that the [vizfada_rnaseq](https://github.com/GenEpi-GenPhySE/vizfada_rnaseq)  and/or the [vizfada_chipseq](https://github.com/GenEpi-GenPhySE/vizfada_chipseq) has been used to process FAANG's data. The inital data structure is assumed to be as such:

```
 data
  └─ species
      ├── species1
      |    ├── rnaseq
      |    |    └── results from vizfada_rnaseq pipeline
      |    └── chipseq
      |         └── results from vizfada_chipseq pipeline
      ├── species2
      :
  
```

Then, run the script `vizfada_data_links.sh` in the directory containing your `species` directory 

### Step 2: create a PVC and transfer the data



## Step 3: deploy VizFaDa
