## ----env, echo = F, warning = F, message = F-----------------------------
pacman::p_load(knitr, tidyverse, ggplot2, lubridate, tidyr, dplyr, data.table, caret, zoo, RMySQL)
opts_chunk$set(fig.path = "output/figure/", fig.align = "center", out.width = "85%", warning = F, message = F)
theme_set(theme_bw(base_family = "FreeMono")); scriptEcho = T; prectime <- Sys.time()

## ----eval = T, echo = scriptEcho-----------------------------------------
d <- readRDS("../preprocessing/output/preprocessing.rds")
d
model <- readRDS("../modeling/output/model.rds")
model

## ----eval = T, echo = scriptEcho-----------------------------------------
predset <- d %>% 
  filter(substr(as.character(dt), 1, 10) == max(substr(as.character(dt), 1, 10))) %>% 
  mutate(EL_CRAC = NA) # 전처리단에서 미리만든 예측셋만 가져온 후 예측대상인 항온항습기 전력사용량 값을 NULL 처리
predset

## ----eval = T, echo = scriptEcho-----------------------------------------
res <- predset %>% 
  mutate(reg_dt = now(), 
         pred_elec_mv = predict(model$pred_elec_mv, newdata = predset), # 과거패턴 기반 항온항습 전력량 예측
         pred_elec = predict(model$pred_elec, newdata = predset), # 설정온도 기반 항온항습 전력량 예측
         # TODO : 추천 권장온도값
         pred_down = pred_elec_mv - pred_elec) %>% # 시뮬레이션 할 가상의 설정온도에 따른 예상절감량
  select(reg_dt, pred_dt = dt, zone, pred_elec_mv, pred_elec, pred_down)

res

## ----eval = T, echo = scriptEcho-----------------------------------------
con <- dbConnect(MySQL(), host = "219.250.188.145", user = "dems", password = "dems123#", dbname = "demsdb")
dbWriteTable(con, "pred_elec", res, append = T, row.names = F) # demsdb.pred_elec 테이블에 예측결과를 더함(append)
dbDisconnect(con)

## ----eval = T, echo = scriptEcho-----------------------------------------
Sys.time() - prectime

