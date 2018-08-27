## ----env, echo = F, warning = F, message = F-----------------------------
pacman::p_load(knitr, tidyverse, ggplot2, lubridate, tidyr, dplyr, data.table, RMySQL, zoo)
opts_chunk$set(fig.path = "output/figure/", fig.align = "center", out.width = "85%", warning = F, message = F)
theme_set(theme_bw(base_family = "FreeMono")); scriptEcho = T

## ----eval = T, echo = scriptEcho-----------------------------------------
con <- dbConnect(MySQL(), host = "219.250.188.145", user = "dems", password = "dems123#", dbname = "demsdb")
query <- "select * from data_sample_fix where tagId in ('EL-2F-U.A1.AI84', 'EL-2F-U.B1.AI84', 'EL-2F-U.A2.AI84', 'EL-2F-U.B2.AI84', 'EL-2F-U.A3.AI84', 'EL-2F-U.B3.AI84', 'EL-2F-U.A4.AI84', 'EL-2F-U.B4.AI84', 'EL-2F-U.A5.AI84', 'EL-2F-U.B5.AI84', 'EL-2F-U.A6.AI84', 'EL-2F-U.B6.AI84', 'EL-2F-U.A7.AI84', 'EL-2F-U.B7.AI84', 'EL-2F-U.A8.AI84', 'EL-2F-U.B8.AI84', 'EL-2F-U.A9.AI84', 'EL-2F-U.B9.AI84', 'EL-2F-U.A10.AI84', 'EL-2F-U.B10.AI84', 'EL-2F-U.A11.AI84', 'EL-2F-U.B11.AI84', 'EL-P2.A-1.AI17', 'EL-P2.A-2.AI17', 'EL-P2.A-3.AI17', 'EL-P2.A-4.AI17', 'EL-P2.A-5.AI17', 'EL-P2.B-1.AI17', 'EL-P2.B-2.AI17', 'EL-P2.B-3.AI17', 'EL-P2.B-4.AI17', 'EL-P2.B-5.AI17', 'EL.LN-2A.AI58', 'BAS.2F-CRAC.1.temp', 'BAS.2F-CRAC.1.humi', 'BAS.2F-CRAC.1.temp_s', 'BAS.2F-CRAC.1.humi_s', 'BAS.2F-CRAC.2.temp', 'BAS.2F-CRAC.2.humi', 'BAS.2F-CRAC.2.temp_s', 'BAS.2F-CRAC.2.humi_s', 'BAS.2F-CRAC.3.temp', 'BAS.2F-CRAC.3.humi', 'BAS.2F-CRAC.3.temp_s', 'BAS.2F-CRAC.3.humi_s', 'BAS.2F-CRAC.4.temp', 'BAS.2F-CRAC.4.humi', 'BAS.2F-CRAC.4.temp_s', 'BAS.2F-CRAC.4.humi_s', 'BAS.2F-CRAC.5.temp', 'BAS.2F-CRAC.5.humi', 'BAS.2F-CRAC.5.temp_s', 'BAS.2F-CRAC.5.humi_s', 'BAS.2F-CRAC.6.temp', 'BAS.2F-CRAC.6.humi', 'BAS.2F-CRAC.6.temp_s', 'BAS.2F-CRAC.6.humi_s', 'BAS.2F-CRAC.7.temp', 'BAS.2F-CRAC.7.humi', 'BAS.2F-CRAC.7.temp_s', 'BAS.2F-CRAC.7.humi_s', 'BAS.2F-CRAC.8.temp', 'BAS.2F-CRAC.8.humi', 'BAS.2F-CRAC.8.temp_s', 'BAS.2F-CRAC.8.humi_s', 'BAS.2F-CRAC.9.temp', 'BAS.2F-CRAC.9.humi', 'BAS.2F-CRAC.9.temp_s', 'BAS.2F-CRAC.9.humi_s', 'BAS.2F-CRAC.10.temp', 'BAS.2F-CRAC.10.humi', 'BAS.2F-CRAC.10.temp_s', 'BAS.2F-CRAC.10.humi_s', 'BAS.2F-CRAC.11.temp', 'BAS.2F-CRAC.11.humi', 'BAS.2F-CRAC.11.temp_s', 'BAS.2F-CRAC.11.humi_s', 'BAS.2F-CRAC.12.temp', 'BAS.2F-CRAC.12.humi', 'BAS.2F-CRAC.12.temp_s', 'BAS.2F-CRAC.12.humi_s', 'BAS.2F-CRAC.13.temp', 'BAS.2F-CRAC.13.humi', 'BAS.2F-CRAC.13.temp_s', 'BAS.2F-CRAC.13.humi_s', 'BAS.2F-CRAC.14.temp', 'BAS.2F-CRAC.14.humi', 'BAS.2F-CRAC.14.temp_s', 'BAS.2F-CRAC.14.humi_s', 'BAS.2F-CRAC.15.temp', 'BAS.2F-CRAC.15.humi', 'BAS.2F-CRAC.15.temp_s', 'BAS.2F-CRAC.15.humi_s', 'BAS.2F-CRAC.16.temp', 'BAS.2F-CRAC.16.humi', 'BAS.2F-CRAC.16.temp_s', 'BAS.2F-CRAC.16.humi_s', 'BAS.2F-CRAC.17.temp', 'BAS.2F-CRAC.17.humi', 'BAS.2F-CRAC.17.temp_s', 'BAS.2F-CRAC.17.humi_s', 'BAS.2F-CRAC.18.temp', 'BAS.2F-CRAC.18.humi', 'BAS.2F-CRAC.18.temp_s', 'BAS.2F-CRAC.18.humi_s', 'BAS.2F-CRAC.19.temp', 'BAS.2F-CRAC.19.humi', 'BAS.2F-CRAC.19.temp_s', 'BAS.2F-CRAC.19.humi_s', 'BAS.2F-CRAC.20.temp', 'BAS.2F-CRAC.20.humi', 'BAS.2F-CRAC.20.temp_s', 'BAS.2F-CRAC.20.humi_s', 'BAS.CT-12.AI1', 'BAS.CT-12.AI2', 'BAS.CT-12.AI3', 'BAS.CT-10.AI5', 'BAS.CT-12.AI4', 'BAS.CT-10.AI7', 'BAS.EXT.temp', 'BAS.EXT.humi')"

d1 <- dbGetQuery(con, query) %>% tbl_df # 분석범위에 해당되는 데이터 추출 후 R session 에 준비

dbDisconnect(con) # RDB 상의 데이터 추출 외에 사용은 없으니 RDB 연결종료

d2 <-  d1 %>% 
  mutate(collectDate = ymd_hms(collectDate)) %>% # 날짜시각 산술을 위하여 날짜 Class 로 변형 
  rename(dt = collectDate, class = tagId) %>% # 편의상 변수명 변경
  filter(!value %in% c("false", "true")) %>% # 윗단에서 추출을 하긴 했지만, 혹시나 모르는 상태값을 가지는 관제포인트를 분석범위에서 제외하기 위해
  mutate(value = as.numeric(value), class = gsub("\\W", "_", class) %>% toupper) %>% # 관제포인트 네이밍을 정리 및 소문자로 일괄변경, 값들은 모두 연속형 값으로 변경
  group_by(byhour = floor_date(dt, "hour"), class) %>% # 관제포인트 별 한시간 단위 집계를 위한 시간내림 이후 그룹핑
  summarise(mean = mean(value, na.rm = T), n = n()) %>% ungroup %>% # 관제포인트 별 평균 및 샘플개수 계산
  arrange(class, byhour) %>% 
  group_by(class) %>% 
  mutate(mean_diff = mean - lag(mean), lag_time = byhour - lag(byhour)) %>% ungroup # 관제포인트 별 시간간격 평균 차분값 및 차분시간간격 계산

d3_1 <- d2 %>% 
  filter(grepl("^BAS", class)) %>% 
  select(byhour, class, mean) %>% 
  spread(class, mean) # "BAS" 로 시작하는 관제포인트 값은 한시간 평균값을 이용

d3_2 <- d2 %>% 
  filter(grepl("^EL", class)) %>% 
  filter(lag_time == 1, mean_diff >= 0) %>% 
  group_by(class) %>% 
  filter(mean_diff <= quantile(mean_diff, .995, na.rm = T)) %>% ungroup %>% # "EL" 로 시작하는 관제포인트 값은 한시간간격과 정상적산값(양의값) 및 관제포인트 별 초극단치를 제거한 한시간 간격 전력실사용 값을 이용
  select(byhour, class, mean_diff) %>% 
  spread(class, mean_diff)

d4 <- full_join(d3_1, d3_2, by = "byhour") %>% # BAS, EL 통합테이블 구성
  na.locf %>% # 결측 및 맵핑 실패로 인한 것은 LOCF(last observation carried forward; 최근값 상속) 방법으르 결측 대치
  rename(dt = byhour) 

full_join(d3_1, d3_2, by = "byhour") %>% 
  # na.locf %>% 
  rename(dt = byhour) %>% 
  saveRDS("../../data/rd/preprocessing_d4.rds") # Ad-hoc 분석을 위한 임시 저장

# Generate futureset for predset (LOCF after lastest date load)
d4_predset <- d4 %>% 
  filter(ymd(substr(dt, 1, 10)) == max(ymd(substr(dt, 1, 10)))) %>% 
  mutate(dt = as.POSIXct(Sys.Date() + days(1) + hours(0:23))) # 그 다음날의 예측셋을 가장최근날의 값으로 구성(이론상 하루전 데이터를 상속)

d5 <- bind_rows(d4, d4_predset) # 예측셋을 append

# 예측대상인 Zone 별 항온항습 전력사용량 총계값 변수 설정
d6 <- d5 %>% 
  mutate(interval = floor_date(dt, "week", week_start = 7) %--% ceiling_date(dt, "week", week_start = 7, change_on_boundary = T),
         interval = as.character(interval) %>% gsub("[[:alpha:]]", "", .) %>% gsub("\\s", "", .) %>% gsub("--", " ~ ", .)) %>% # 주간간격 파생변수 생성
  gather(class, value, -dt, -interval) %>% # long term 변환
  mutate(
    zone = case_when(
      class %in% c("EL_P2_A_1_AI17", 'EL_P2_B_1_AI17', 
                   "EL_2F_U_A1_AI84","EL_2F_U_A2_AI84",
                   "EL_2F_U_B1_AI84","EL_2F_U_B2_AI84",
                   "BAS_2F_CRAC_1_HUMI","BAS_2F_CRAC_1_HUMI_S","BAS_2F_CRAC_1_TEMP","BAS_2F_CRAC_1_TEMP_S",
                   "BAS_2F_CRAC_2_HUMI","BAS_2F_CRAC_2_HUMI_S","BAS_2F_CRAC_2_TEMP","BAS_2F_CRAC_2_TEMP_S",
                   "BAS_2F_CRAC_3_HUMI","BAS_2F_CRAC_3_HUMI_S","BAS_2F_CRAC_3_TEMP","BAS_2F_CRAC_3_TEMP_S",
                   "BAS_2F_CRAC_4_HUMI","BAS_2F_CRAC_4_HUMI_S","BAS_2F_CRAC_4_TEMP","BAS_2F_CRAC_4_TEMP_S") ~ "1",
      class %in% c("EL_P2_A_2_AI17", 'EL_P2_B_2_AI17', 
                   "EL_2F_U_A3_AI84","EL_2F_U_A4_AI84","EL_2F_U_A5_AI84",
                   "EL_2F_U_B3_AI84","EL_2F_U_B4_AI84","EL_2F_U_B5_AI84",
                   "BAS_2F_CRAC_5_HUMI","BAS_2F_CRAC_5_HUMI_S","BAS_2F_CRAC_5_TEMP","BAS_2F_CRAC_5_TEMP_S",
                   "BAS_2F_CRAC_6_HUMI","BAS_2F_CRAC_6_HUMI_S","BAS_2F_CRAC_6_TEMP","BAS_2F_CRAC_6_TEMP_S",
                   "BAS_2F_CRAC_7_HUMI","BAS_2F_CRAC_7_HUMI_S","BAS_2F_CRAC_7_TEMP","BAS_2F_CRAC_7_TEMP_S",
                   "BAS_2F_CRAC_8_HUMI","BAS_2F_CRAC_8_HUMI_S","BAS_2F_CRAC_8_TEMP","BAS_2F_CRAC_8_TEMP_S") ~ "2",
      class %in% c("EL_P2_A_3_AI17", 'EL_P2_B_3_AI17', 
                   "EL_2F_U_A6_AI84","EL_2F_U_A7_AI84",
                   "EL_2F_U_B6_AI84","EL_2F_U_B7_AI84",
                   "BAS_2F_CRAC_9_HUMI","BAS_2F_CRAC_9_HUMI_S","BAS_2F_CRAC_9_TEMP","BAS_2F_CRAC_9_TEMP_S",
                   "BAS_2F_CRAC_10_HUMI","BAS_2F_CRAC_10_HUMI_S","BAS_2F_CRAC_10_TEMP","BAS_2F_CRAC_10_TEMP_S",
                   "BAS_2F_CRAC_11_HUMI","BAS_2F_CRAC_11_HUMI_S","BAS_2F_CRAC_11_TEMP","BAS_2F_CRAC_11_TEMP_S",
                   "BAS_2F_CRAC_12_HUMI","BAS_2F_CRAC_12_HUMI_S","BAS_2F_CRAC_12_TEMP","BAS_2F_CRAC_12_TEMP_S") ~ "3",
      class %in% c("EL_P2_A_4_AI17", 'EL_P2_B_4_AI17', 
                   "EL_2F_U_A8_AI84","EL_2F_U_A9_AI84",
                   "EL_2F_U_B8_AI84","EL_2F_U_B9_AI84",
                   "BAS_2F_CRAC_13_HUMI","BAS_2F_CRAC_13_HUMI_S","BAS_2F_CRAC_13_TEMP","BAS_2F_CRAC_13_TEMP_S",
                   "BAS_2F_CRAC_14_HUMI","BAS_2F_CRAC_14_HUMI_S","BAS_2F_CRAC_14_TEMP","BAS_2F_CRAC_14_TEMP_S",
                   "BAS_2F_CRAC_15_HUMI","BAS_2F_CRAC_15_HUMI_S","BAS_2F_CRAC_15_TEMP","BAS_2F_CRAC_15_TEMP_S",
                   "BAS_2F_CRAC_16_HUMI","BAS_2F_CRAC_16_HUMI_S","BAS_2F_CRAC_16_TEMP","BAS_2F_CRAC_16_TEMP_S") ~ "4",
      class %in% c("EL_P2_A_5_AI17", 'EL_P2_B_5_AI17', 
                   "EL_2F_U_A10_AI84","EL_2F_U_A11_AI84",
                   "EL_2F_U_B10_AI84","EL_2F_U_B11_AI84",
                   "BAS_2F_CRAC_17_HUMI","BAS_2F_CRAC_17_HUMI_S","BAS_2F_CRAC_17_TEMP","BAS_2F_CRAC_17_TEMP_S",
                   "BAS_2F_CRAC_18_HUMI","BAS_2F_CRAC_18_HUMI_S","BAS_2F_CRAC_18_TEMP","BAS_2F_CRAC_18_TEMP_S",
                   "BAS_2F_CRAC_19_HUMI","BAS_2F_CRAC_19_HUMI_S","BAS_2F_CRAC_19_TEMP","BAS_2F_CRAC_19_TEMP_S",
                   "BAS_2F_CRAC_20_HUMI","BAS_2F_CRAC_20_HUMI_S","BAS_2F_CRAC_20_TEMP","BAS_2F_CRAC_20_TEMP_S") ~ "5"
      ), # Zone 맵핑
    class2 = case_when(
      grepl("^EL_P2_", class) ~ "EL_CRAC",
      grepl("^EL_2F_U_", class) ~ "EL_IT",
      grepl("^EL_LN_", class) ~ "EL_LN",
      grepl("TEMP$", class) ~ "TEMP",
      grepl("HUMI$", class) ~ "HUMI",
      grepl("TEMP_S$", class) ~ "TEMP_SET",
      grepl("HUMI_S$", class) ~ "HUMI_SET",
      grepl("^BAS_CT_12_AI[12]", class) ~ "COLLING_G",
      grepl("^BAS_CT_12_AI[34]", class) ~ "COLLING_H",
      grepl("BAS_EXT_TEMP", class) ~ "OUT_TEMP"
      ) # 관제포인트 대분류 맵핑
    ) %>% 
  select(class, class2, dt, interval, zone, everything()) %>% 
  arrange(class2, dt)

# Change wide term for trainset
d7_1 <- d6 %>% 
  filter(class2 == "EL_CRAC") %>%
  group_by(dt, zone) %>% 
  summarise(value = sum(value, na.rm = T)) %>% ungroup %>% # Zone 별 항온항습기 전력사용량 총계 계산 (for 설명변수 Y 설정)
  rename(EL_CRAC = value)

d7_2 <- d6 %>% 
  select(dt, class, value) %>% 
  spread(class, value)
  
res <- full_join(d7_1, d7_2, by = "dt") %>% 
  select(dt, EL_CRAC, zone, everything()) %>% 
  mutate(month = lubridate::month(dt) %>% as.character %>% as.factor, # 당월 파생변수 생성 (for 시간에 대한 설명변수 추가)
         wday = lubridate::wday(dt, label = T) %>% as.character %>% as.factor, # 당일에 대한 요일 파생변수 생성 (for 시간에 대한 설명변수 추가)
         hour = lubridate::hour(dt) %>% as.character %>% as.factor) # 당일 시각 파생변수 생성 (for 시간에 대한 설명변수 추가)

res

## ------------------------------------------------------------------------
saveRDS(res, "../../data/rd/preprocessing.rds")
