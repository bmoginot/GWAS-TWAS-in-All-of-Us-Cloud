# Project 5: GWAS, TWAS, and Data Viz in the All of Us Cloud (Ben, Claudia, Angelina, Drew)
***
## Using All of Us Cloud Environment
### Get Approved
In order to access sensitive All of Us GWAS data, you must create and account, verify your identity, and complete the requisite training. The steps to do this can be found in the wiki at [Registering for All of Us](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/1.-Registering-for-All-of-Us).

### Navigating and Creating a Workspace
The next step is to create a workspace at your Research Workbench. The [Using All of Us Website and Cloud](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/2.-Using-All-of-Us-Website-and-Cloud) page on the wiki will walk you through the website. 
Your workspace will house any GWAS data you pull along with all scripts from this repository and their output.
***
## Using the Pipeline
### Clone Repo
To access these scripts, clone this repository in your workspace. Information on how to do this and how to run scripts from this repo in your workspace is in [Using This Repository](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/3.-Using-This-Repository).

### Analysis 
Once these scripts are in your workspace, you will be able to run them to pull and analyze All of Us GWAS data. This can be done most easily by using the two wrapper scripts. The first wrapper script obtains, analyzes, and plots GWAS data from All of Us. The second wrapper script generates and plots TWAS data. The wrappers call a number of other scripts which can be run on their own if you only need to use one of the tools. Each tool is detailed in its respective wiki page; the wrappers are detailed below.

### 00Wrapper
Prior to running the 00wrapper.sh script, run
```
chmod +x ~/GWAS-TWAS-in-All-of-Us-Cloud/00wrapper.sh
```

Running the 00Wrapper.sh will execute scripts 1 through 4, which include pulling GWAS summary statistics, formatting them, plotting a Manhattan plot, and running LocusZoom on one locus of interest.

To run the wrapper use the following command within the All of Us terminal under the Hail Table Environment:
```
bash ~/GWAS-TWAS-in-All-of-Us-Cloud/00wrapper.sh --phecode <PHECODE> --pop <POP> --rsid <RSID> --token <TOKEN>
```

- Phecode and Population arguments are required - See Wiki 4. Retrieving Summary Statistics for phecode and population options
- rsid and token arguments are optional
> To view a locus with locuszoomr other than the locus with the lowest P-value SNP, specify the rsID of a SNP within the locus of interest. This SNP will also serve as the reference SNP for linkage disequilibrium disply

> Token represents the LDlink personal access code needed to display linkage disequilibrium when plotting with locuszoomr. To make a one-time request for your personal access token follow the directions within the following web browser at https://ldlink.nih.gov/?tab=apiaccess.

### 00twas-wrapper
This second wrapper performs the TWAS part of this tool. It executes setting up S-PrediXcan and scripts 5 & 6, which imputes TWAS summary statistics and generates a Manhattan plot of those data.

**MUST BE PERFORMED AT LEAST ONCE PRIOR TO RUNNING S-PREDIXCAN:**
1. Run in AoU terminal: `chmod +x ~/GWAS-TWAS-in-All-of-Us-Cloud/00twas-wrapper.sh`
2. Run in AoU terminal: `gsutil ls` to find bucket name -> ex. `gs://fc-secure-915a27e9-c961-4aa0-b53f-09825278579c`
3. Run in AoU terminal: `gcloud config get-value project` to find project Terra ID
4. Run in lab server terminal: `gcloud auth login`, then follow prompts to log into AoU account
5. Run in lab server terminal: `gcloud config set project {PASTE_YOUR_TERRA_ID_HERE}`
6. Run in lab server terminal: `gsutil -m cp -v /home/wheelerlab3/Data/predictdb_models/elastic-net-with-phi.tar {PASTE_YOUR_BUCKET_HERE}/data/` -> ex. `gsutil -m cp -v /home/wheelerlab3/Data/predictdb_models/elastic-net-with-phi.tar gs://fc-secure-915a27e9-c961-4aa0-b53f-09825278579c/data/`

Run the wrapper via
```
bash ~/GWAS-TWAS-in-All-of-Us-Cloud/00twas-wrapper.sh --phecode <PHECODE> --pop <POP> --ref <REF> --gwas_h2 <H2> --gwas_N <N>
```

`<PHECODE>` is the phenotype code of interest  
`<POP>` is the population the sample originates from  
`<REF>` is the reference database to use  
`<H2>` (optional flag) is the hertiability of the GWAS phenotype  
`<N>` (optional flag) is the sample size of the GWAS summary statistics

***Important***: Inclusion of H2 and N optional flags determines whether or not the newer elastic net models (if both are included) or older mashr models (if either one is not included). 

- H2 and N will be printed by the 00wrapper.sh script if they are available within the hail table global statistics; use these values or researched values for input
- Possible reference databases can be displayed by running `bash ~/GWAS-TWAS-in-All-of-Us-Cloud/00twas-wrapper.sh --databases` 
  - Choose a database that corresponds to the phenotype of interest. For example, we used Muscle_Skeletal with a rheumatoid arthrithis dataset.
***
## Pipeline Outline: 
### The [First Wrapper](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/00wrapper.sh) will run the following scripts:
  ### 1. [Pulling Data](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/01pull_data.py)
  - retrieves hail tables of GWAS summary statistics from the AoU cloud based on a user-defined ancestral population abbreviation and phecode that corresponds to a phenotype of interest
  - [Documentation](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/4.-Retrieve-Summary-Statistics#pulling-all-of-us-gwas-summary-statistics-from-the-cloud)
  ### 2. [Table Formatting](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/02table_format.R)
  - accommodates various input formatting requirements by subsequent tools
  - [Documentation](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/4.-Retrieve-Summary-Statistics#formatting-all-of-us-gwas-summary-statistics-for-qqman-locuszoomr-and-s-predixcan-input)
  ### 3. [GWAS qqman](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/03gwas_qqman.R)
  - visualizes GWAS summary statistics results via Manhattan Plot
  - [Documentation](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/5.-qqman-for-GWAS-summary-statistic-data)
  ### 4. [locuszoomR](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/04locuszoom.R)
  -  visualize all of the SNPs in a specific locus
  -  [Documentation](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/6.-Locuszoomr)


### The [Second Wrapper](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/00twas-wrapper.sh) will run S-PrediXcan, then plot the results using biomaRt and qqman.
  ### 5. [S-PrediXcan](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/05run-predixcan.py)
  - imputes TWAS summary statistics from GWAS summary statistics
  - [Documentation](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/7.-S%E2%80%90PrediXcan)
  ### 6. [TWAS qqman (and biomaRt)](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/blob/main/06twas_qqman.R)
  - visualizes TWAS summary statistics results via Manhattan Plot
  - [Documentation](https://github.com/bmoginot/GWAS-TWAS-in-All-of-Us-Cloud/wiki/8.-biomaRt-and-qqman-for-TWAS-summary-statistics)
***
## Output
Files generated by the wrappers (or any other scripts) are saved to this repo folder in addition to your workspace's Google Bucket  
The name of your bucket is stored as the bash variable `$WORKSPACE_BUCKET`  
You can look at folders and files in your bucket by running
```
gsutil ls $WORKSPACE_BUCKET
```

Files can be copied from the bucket to the current directory via
```
gustil cp $WORKSPACE_BUCKET/<filename> .
```
