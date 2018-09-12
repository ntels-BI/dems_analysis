#!/bin/bash

cd /home/hjsong/DEMS/03_dev/sh
# Rscript -e 'rmarkdown::pandoc_available()'

## Step 1)

cd ../preprocessing

Rscript -e 'knitr::purl("preprocessing.rmd")' # 원본코드인 Rmarkdown 문서에서 순수한 Rscript 으로 변환함
# Rscript -e 'rmarkdown::render("preprocessing.rmd")'
echo running.. preprocessing.R \(`date "+%Y-%m-%d %H-%M-%S"`\) # 변환한 순수 Rscript 를 실행시키기 전 실행시점과 함께 메세지 출력
R CMD BATCH --no-save preprocessing.R # 전처리단 스크립트 실행

## Step 2)

cd ../modeling

Rscript -e 'knitr::purl("modeling.rmd")' # 원본코드인 Rmarkdown 문서에서 순수한 Rscript 으로 변환함
# Rscript -e 'rmarkdown::render("modeling.rmd")'
echo running.. modeling.R \(`date "+%Y-%m-%d %H-%M-%S"`\) # 변환한 순수 Rscript 를 실행시키기 전 실행시점과 함께 메세지 출력
R CMD BATCH --no-save modeling.R # 모듈단 스크립트 실행

## Step 3)

cd ../predict

Rscript -e 'knitr::purl("predict.rmd")' # 원본코드인 Rmarkdown 문서에서 순수한 Rscript 으로 변환함
# Rscript -e 'rmarkdown::render("predict.rmd")'
echo running.. predict.R \(`date "+%Y-%m-%d %H-%M-%S"`\) # 변환한 순수 Rscript 를 실행시키기 전 실행시점과 함께 메세지 출력
R CMD BATCH --no-save predict.R # 예측단 스크립트 실행