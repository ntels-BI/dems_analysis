#!/bin/bash

cd /home/hjsong/DEMS/03_dev/sh
# Rscript -e 'rmarkdown::pandoc_available()'

## Step 1)

cd ../preprocessing

Rscript -e 'knitr::purl("preprocessing.rmd")'
# Rscript -e 'rmarkdown::render("preprocessing.rmd")'
echo running.. preprocessing.R \(`date "+%Y-%m-%d %H-%M-%S"`\)
R CMD BATCH --no-save preprocessing.R

## Step 2)

cd ../modeling

Rscript -e 'knitr::purl("modeling.rmd")'
# Rscript -e 'rmarkdown::render("modeling.rmd")'
echo running.. modeling.R \(`date "+%Y-%m-%d %H-%M-%S"`\)
R CMD BATCH --no-save modeling.R

## Step 3)

cd ../predict

Rscript -e 'knitr::purl("predict.rmd")'
# Rscript -e 'rmarkdown::render("predict.rmd")'
echo running.. predict.R \(`date "+%Y-%m-%d %H-%M-%S"`\)
R CMD BATCH --no-save predict.R