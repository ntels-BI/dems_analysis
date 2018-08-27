#!/bin/bash
# run_preprocessing.sh

# Step 1)

cd ../preprocessing
echo `pwd`

Rscript -e 'knitr::purl("preprocessing.rmd")'
R CMD BATCH --no-save preprocessing.R

# Step 2)

cd ../modeling
echo `pwd`

Rscript -e 'knitr::purl("model.rmd")'
R CMD BATCH --no-save model.R

# Step 3)

cd ../predict
echo `pwd`

Rscript -e 'knitr::purl("predict.rmd")'
R CMD BATCH --no-save predict.R
