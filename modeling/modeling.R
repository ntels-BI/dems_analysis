## ----env, echo = F, warning = F, message = F-----------------------------
pacman::p_load(knitr, tidyverse, ggplot2, lubridate, tidyr, dplyr, data.table, caret, zoo, RMySQL, magrittr, MLmetrics, scales)
opts_chunk$set(fig.path = "output/figure/", fig.align = "center", out.width = "85%", warning = F, message = F)
theme_set(theme_bw(base_family = "FreeMono")); scriptEcho = T; prectime <- Sys.time()

## ----eval = T, echo = scriptEcho-----------------------------------------
d <- readRDS("../preprocessing/output/preprocessing.rds")
d

## ----eval = T, echo = scriptEcho-----------------------------------------
trainset_full <- d

partitionRate = .9 # 학습셋에 대한 층별로 충분한 데이터가 초기엔 없어 상당히 높은 비율로 trainset Partition Rate 을 잡음
trainIndex <- trainset_full %>% nrow %>% multiply_by(partitionRate) %>% round %>% seq # 데이터 중 과거데이터의 90%를 모델학습에 사용하기 위한 인덱스 설정
testIndex <- trainset_full %>% nrow %>% multiply_by(partitionRate) %>% round %>% add(1) %>% seq(nrow(trainset_full)) # 데이터 중 과거 최근데이터의 10%를 모델 예측성능 테스트에 사용하기 위한 인덱스 설정

trainset <- trainset_full %>% extract(trainIndex, ) # 학습셋 할당
trainset
testset <- trainset_full %>% extract(testIndex, ) # 테스트셋 할당
testset

## ----eval = T, echo = scriptEcho-----------------------------------------
evaluate <- function(model, testset, class){
  stopifnot(is.character(class))
  
  tt <- tbl_df(testset)
  pd <- data.frame(real = pull(tt, class), pred = predict(model, newdata = tt)) %>% 
    arrange(real) %>% 
    mutate(id = seq(nrow(tt))) %>% 
    gather(class, value, -id)
  p <- ggplot(pd, aes(x = id, y = value, color = class)) + 
    geom_line(stat = "identity", size = .3) + 
    ggtitle(model$modelInfo$label, 
            paste0("MAPE : ", MAPE(predict(model, newdata = tt), pull(tt, class)) %>% percent))
  print(p)
  MAPE(predict(model, newdata = tt), pull(tt, class))
}

## ----eval = T, echo = scriptEcho-----------------------------------------
mlMethods <- c("glm", "pls", "rpart", "pcr", "icr", "knn", "lars", "nnls", "ppr", "rqnc", "glmnet")

fitControl <- trainControl(method = "cv", number = 8, allowParallel = T) # 8-fold cross validation 정책 설정, `allowParallel = T` 는 교차검증시 병렬처리를 통해 처리속도를 빠르게 하기 위한 전략
modelsNominee <- mlMethods %>% 
  lapply(function(x) train(EL_CRAC ~ . - dt, data = trainset, method = x, trControl = fitControl))

MAPEs <- c()
for(i in modelsNominee %>% length %>% seq) MAPEs[i] <- evaluate(modelsNominee[[i]], testset, "EL_CRAC") # 모델 알고리즘 별 예측성능 평가

model <- list()
model$pred_elec <- modelsNominee[[which.min(MAPEs)]] # 예측성능이 가장 높은 알고리즘의 모델 저장
model$pred_elec_mv <- train(EL_CRAC ~ ., data = select(trainset_full, EL_CRAC, zone, month, wday, hour, load_group), method = "rpart", trControl = fitControl) # 시계열 변수에 기반한 항온항습기 전력사용량 단순예측 모델 저장

res <- model
res

## ----eval = T, echo = scriptEcho-----------------------------------------
saveRDS(res, "output/model.rds")

## ----eval = T, echo = scriptEcho-----------------------------------------
Sys.time() - prectime

