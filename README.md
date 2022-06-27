
<!-- README.md is generated from README.Rmd. Please edit that file -->

# calcPCBrainAge

<!-- badges: start -->
<!-- badges: end -->

The goal of calcPCBrainAge is to provide an efficient method for
interested users to calculate PCBrainAge according to its original
publication.

## Installation

You can install calcPCBrainAge from github with:

``` r
devtools::install_github("MorganLevineLab/calcPCBrainAge")
```

## Main Functions

Calculating PCBrainAge is very simple to do using our function. You can
either output it to your own vector, or you can append a column to an
existing phenotype dataframe. We assume that: 1. your methylation data
is in the form of samples as rows, CpGs as columns 2. the sample DNAm
dataframe rows match the sample order in the pheno dataframe, if you
have such a dataframe available.

The commands are shown below:

``` r
library(calcPCBrainAge)
## basic example code
myPCBrainAges <- calcPCBrainAge(DNAm = sampleDNAm) #This gives you a vector
samplePheno <- calcPCBrainAge(DNAm = sampleDNAm, pheno = samplePheno) #This will append a column called `PCBrainAge` onto your existing pheno DF
```

## Missing Values

According to the original publication, this measure is built off of the
“PC-Clocks” method for low noise, highly robust epigenetic clocks. The
function is projecting your data onto pre-trained principal components
necessary for the model, and then performing weighted linear averaging
of the PC scores for each sample to calculate an age.

To run PCA, it is essential that you do not have NA values. If you do,
then imputation is necessary to fill in the missing values. It is a good
idea to first check the following 2 commands:

``` r
reportMissingCpGs <- function(x) all(is.na)
missingCpGs <- apply(sampleDNAm, 2, reportMissingCpGs)

missingValues <- sum(is.na(myDNAm))
```

If `sum(missingCpGs)` is greater than 0, this means that after
methylation processing, there are are CpGs which were set to NA across
all samples. If this is the case then please run
`sampleDNAm <- sampleDNAm[,!missingCpGs]` to remove those columns.

For sporadic missing values, such as CpGs missing in one or few samples
(if missingValues \> 0), there are many ways to fill in these values.
The simplest such method is mean imputation. Simply perform the
following code, after the all NA columns have been removed:

``` r
meanimpute <- function(x){
  apply(x,2,function(z)ifelse(is.na(z),mean(z,na.rm=T),z))
}
sampleDNAm <- apply(sampleDNAm, 2, meanimpute)
```

There is a chance that not all of the CpGs necessary to compute
PCBrainAge are going to be present in your data, in which case, the
function `calcPCBrainAge` will result in an error. Therefore, we have
provided a vector of mean CpG values to fill in the missing CpGs, which
was derived from brain data (age \> 20; GSE74193). You can also replace
it with your own vector of values for the missing CpGs. In this case,
you simply use the following version of the function instead:

``` r
calcPCBrainAge(DNAm = sampleDNAm, pheno = samplePheno, CpGImputation = imputeMissingBrainCpGs)
```
