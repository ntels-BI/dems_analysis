## ----env, echo = F, warning = F, message = F-----------------------------
pacman::p_load(knitr, tidyverse, ggplot2, lubridate, tidyr, dplyr, data.table, caret, zoo, RMySQL)
opts_chunk$set(fig.path = "output/figure/", fig.align = "center", out.width = "85%", warning = F, message = F)
theme_set(theme_bw(base_family = "FreeMono")); scriptEcho = T

## ----eval = T, echo = scriptEcho-----------------------------------------
d <- readRDS("../preprocessing/output/preprocessing.rds")
d
model <- readRDS("../modeling/output/model.rds")
model

## ----eval = T, echo = scriptEcho-----------------------------------------
con <- dbConnect(MySQL(), host = "219.250.188.145", user = "dems", password = "dems123#", dbname = "demsdb")
query <- "select * from tb_cost where ('2018-09-10' between basicdate and endbasicdate) or '2018-09-10' >= basicdate and endbasicdate is null"
cost <- dbGetQuery(con, query) %>% tbl_df # 분석범위에 해당되는 데이터 추출 후 R session 에 준비
cost

## ----eval = T, echo = scriptEcho-----------------------------------------
predset <- d %>% 
  filter(substr(as.character(dt), 1, 10) == max(substr(as.character(dt), 1, 10))) %>% 
  mutate(EL_CRAC = NA) # 전처리단에서 미리만든 예측셋만 가져온 후 예측대상인 항온항습기 전력사용량 값을 NULL 처리
predset

## ----eval = T, echo = scriptEcho-----------------------------------------
res <- predset %>% 
  mutate(predDate = floor_date(dt, "day"), 
         predTime = lubridate::hour(dt) %>% formatC(width = 2, flag = "0"), # 시각을 고정폭 스트링으로 준비하기 위하여 `formatC()` 함수를 이용
         caseCost = case_when(
           month(predDate) %in% 3:5         & predTime %in% 0:6   ~ pull(cost, cost11),
           month(predDate) %in% 3:5         & predTime %in% 7:12  ~ pull(cost, cost12),
           month(predDate) %in% 3:5         & predTime %in% 13:18 ~ pull(cost, cost13),
           month(predDate) %in% 3:5         & predTime %in% 19:23 ~ pull(cost, cost14),
           month(predDate) %in% 6:8         & predTime %in% 0:6   ~ pull(cost, cost21),
           month(predDate) %in% 6:8         & predTime %in% 7:12  ~ pull(cost, cost22),
           month(predDate) %in% 6:8         & predTime %in% 13:18 ~ pull(cost, cost23),
           month(predDate) %in% 6:8         & predTime %in% 19:23 ~ pull(cost, cost24),
           month(predDate) %in% 9:11        & predTime %in% 0:6   ~ pull(cost, cost31),
           month(predDate) %in% 9:11        & predTime %in% 7:12  ~ pull(cost, cost32),
           month(predDate) %in% 9:11        & predTime %in% 13:18 ~ pull(cost, cost33),
           month(predDate) %in% 9:11        & predTime %in% 19:23 ~ pull(cost, cost34),
           month(predDate) %in% c(12, 1, 2) & predTime %in% 0:6   ~ pull(cost, cost41),
           month(predDate) %in% c(12, 1, 2) & predTime %in% 7:12  ~ pull(cost, cost42),
           month(predDate) %in% c(12, 1, 2) & predTime %in% 13:18 ~ pull(cost, cost43),
           month(predDate) %in% c(12, 1, 2) & predTime %in% 19:23 ~ pull(cost, cost44),
          ), # TODO : tb_cost 테이블이 제대로 된 부하시간대별 전력요금을 연동하는지 확인하여, 계산될 `predElecMVCost`, `predElecCost` 값을 검토할 필요가 있을것임
         regDate = Sys.time(), # 데이터 생성기준 날짜시각
         predElecMV = predict(model$pred_elec_mv, newdata = predset), # 과거패턴 기반 항온항습 전력량 예측
         predElec = predict(model$pred_elec, newdata = predset), # 설정온도 기반 항온항습 전력량 예측
         predElecMVCost = predElecMV * caseCost, # 과거패턴 기반 항온항습 전력사용비용 예측
         predElecCost = predElec * caseCost, # 설정온도 기반 항온항습 전력사용비용 예측
         # TODO : 추천 권장온도값에 대한 필드가 개발이 되면 추가되어야 함
         predDownCost = predElecMVCost - predElecCost) %>% # 시뮬레이션 할 가상의 설정온도에 따른 예상절감비용
  select(regDate, predDate, predTime, zone, predElecMV, predElecMVCost, predElec, predElecCost, predDownCost)

res

## ----eval = T, echo = scriptEcho-----------------------------------------
con <- dbConnect(MySQL(), host = "219.250.188.145", user = "dems", password = "dems123#", dbname = "demsdb")
dbWriteTable(con, "pred_elec", res, append = T, row.names = F) # demsdb.pred_elec 테이블에 예측결과를 더함(append)
dbDisconnect(con)

## ----eval = T, echo = scriptEcho-----------------------------------------
proc.time()

