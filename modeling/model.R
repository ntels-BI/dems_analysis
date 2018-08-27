## ----env, echo = F, warning = F, message = F-----------------------------
pacman::p_load(knitr, tidyverse, ggplot2, lubridate, tidyr, dplyr, data.table, caret, zoo, RMySQL)
opts_chunk$set(fig.path = "output/figure/", fig.align = "center", out.width = "85%", warning = F, message = F)
theme_set(theme_bw(base_family = "FreeMono")); scriptEcho = T

## ------------------------------------------------------------------------
d <- readRDS("../../data/rd/preprocessing.rds")

## ------------------------------------------------------------------------
trainset <- d %>% 
  filter(substr(as.character(dt), 1, 10) != max(substr(as.character(dt), 1, 10)))

predset <- d %>% 
  filter(substr(as.character(dt), 1, 10) == max(substr(as.character(dt), 1, 10))) %>% 
  mutate(EL_CRAC = NA) # predict 으로 이관

## ------------------------------------------------------------------------
model <- list()

fitControl <- trainControl(method = "cv", number = 10, allowParallel = TRUE)
model$pred_elec <- train(EL_CRAC ~ . - dt, data = trainset, method = "lars", trControl = fitControl)
model$pred_elec_mv <- train(EL_CRAC ~ ., data = select(trainset, EL_CRAC, zone, month, wday, hour), method = "rpart", trControl = fitControl)

res <- model
res

## ------------------------------------------------------------------------
saveRDS(res, "output/model.rds")

