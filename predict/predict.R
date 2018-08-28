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
trainset <- d %>% 
  filter(substr(as.character(dt), 1, 10) != max(substr(as.character(dt), 1, 10)))
trainset

predset <- d %>% 
  filter(substr(as.character(dt), 1, 10) == max(substr(as.character(dt), 1, 10))) %>% 
  mutate(EL_CRAC = NA)
predset

## ----eval = T, echo = scriptEcho-----------------------------------------
res <- predset %>% 
  mutate(reg_dt = now(), 
         pred_elec_mv = predict(model$pred_elec_mv, newdata = predset),
         pred_elec = predict(model$pred_elec, newdata = predset),
         pred_downcost = pred_elec_mv - pred_elec) %>%
  select(reg_dt, pred_dt = dt, zone, pred_elec_mv, pred_elec, pred_downcost)

res

## ----eval = T, echo = scriptEcho-----------------------------------------
con <- dbConnect(MySQL(), host = "219.250.188.145", user = "dems", password = "dems123#", dbname = "demsdb")
dbWriteTable(con, "pred_elec", res, append = T, row.names = F)
dbDisconnect(con)

