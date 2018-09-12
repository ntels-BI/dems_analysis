### Code, File summary

* `/preprocessing` : Input 및 전처리단
* `/preprocessing/output` : Input 및 전처리단의 출력물 (전처리 수행 후 산출되는 학습마트 R 객체 등)
* `/preprocessing/preprocessing.R` : Input 및 전처리단 R 코드 (preprocessing.rmd 의 산출물)
* `/preprocessing/preprocessing.html` : Input 및 전처리단의 코드실행 리포트 (preprocessing.rmd 의 산출물)
* `/preprocessing/preprocessing.rmd` : Input 및 전처리 Rmarkdown 코드 원본
* `/preprocessing/preprocessing.Rout` : Input 및 전처리단 R 코드 실행에 대한 로그

* `/modeling` : 모델링단
* `/modeling/output` : 모델링단의 출력물 (선정모델 R 객체 등)
* `/modeling/modeling.R` : 모델링단 R 코드 (modeling.rmd 의 산출물)
* `/modeling/modeling.html` : 모델링단의 코드실행 리포트 (modeling.rmd 의 산출물)
* `/modeling/modeling.rmd` : 모델링 Rmarkdown 코드 원본
* `/modeling/modeling.Rout` : 모델링단 R 코드 실행에 대한 로그

* `/predict` : 예측테이블 계산 및 Out단
* `/predict/predict.R` : 예측테이블 계산 및 Out단 R 코드 (predict.rmd 의 산출물)
* `/predict/predict.html` : 예측테이블 계산 및 Out단의 코드실행 리포트 (predict.rmd 의 산출물)
* `/predict/predict.rmd` : 예측테이블 계산 및 Out의 Rmarkdown 코드 원본
* `/predict/predict.Rout` : 예측테이블 계산 및 Out단 R 코드 실행에 대한 로그

* `/sh/run.sh` : 전체 스크립트 실행 스위치 쉘
* `/sh/log` : `run.sh` 실행에 대한 표준출력 및 표준에러 로그

* `/.gitignore` : git 버전관리에 무시될 파일포맷 설정
* `/README.md`

### DB connection info

```r
library(RMySQL)
con <- dbConnect(MySQL(), host = "219.250.188.145", user = "dems", password = "dems123#", dbname = "demsdb")
dbListTables(con)
```

### Create `pred_elec` table query

```sql
CREATE TABLE pred_elec (
  regDate DATETIME NOT NULL,
  predDate DATE NOT NULL,
  predTime VARCHAR(2) NOT NULL,
  zone VARCHAR(1) NOT NULL,
  predElecMV DECIMAL(10, 2),
  predElecMVCost DECIMAL(10, 2),
  predElec DECIMAL(10, 2),
  predElecCost DECIMAL(10, 2),
  predDownCost DECIMAL(10, 2),
  PRIMARY KEY (predDate, predTime, zone)
)
```

### `pred_elec` table description

```
mysql> desc pred_elec;
+----------------+---------------+------+-----+---------+-------+
| Field          | Type          | Null | Key | Default | Extra |
+----------------+---------------+------+-----+---------+-------+
| regDate        | date          | NO   |     | NULL    |       |
| regTime        | varchar(2)    | NO   |     | NULL    |       |
| predDate       | date          | NO   | PRI | NULL    |       |
| predTime       | varchar(2)    | NO   | PRI | NULL    |       |
| zone           | varchar(1)    | NO   | PRI | NULL    |       |
| predElecMV     | decimal(10,2) | YES  |     | NULL    |       |
| predElecMVCost | decimal(10,2) | YES  |     | NULL    |       |
| predElec       | decimal(10,2) | YES  |     | NULL    |       |
| predElecCost   | decimal(10,2) | YES  |     | NULL    |       |
| predDownCost   | decimal(10,2) | YES  |     | NULL    |       |
+----------------+---------------+------+-----+---------+-------+
10 rows in set (0.00 sec)
```

### `pred_elec` table 변수별 의미

* `regDate` : 데이터 생성날짜
* `regTime` : 데이터 생성시각
* `predDate` : 예측시점 날짜
* `predTime` : 예측시점 시각
* `zone` : Zone 구분
* `predElecMV` : 과거 패턴기반 항온항습 전력량 예측값
* `predElecMVCost` : 과거 패턴기반 항온항습 전력량 기준 전력사용비용 예측값
* `predElec` : 설정온도 기반 항온항습 전력량 예측값
* `predElecCost` : 설정온도 기반 항온항습 전력량 기준 전력사용비용 예측값
* `predDownCost` : `predElecMVCost` - `predElecCost` 값

### `pred_elec` table 성격

현재 1시간 간격으로 Zone 별, 하루미래 00~23시 까지의 24개 예측값이 생성되므로 한시간 간격 120개의 행 데이터가 append 되는 형태임

### `pred_elec` table 연동방법

최적운전 -> 수요예측 페이지의 

1. 수요예측 선 : x축은 pred_dt, y축은 pred_elec_mv 값을 이용하여 그래프 플롯팅
2. 예측 전력량 선 : x축은 pred_dt, y축은 pred_elec 값을 이용하여 그래프 플롯팅

### 최적운전 -> 수요예측 페이지의 그래프 컨텐츠의 갱신 주기

매일 00:00 정각

### To BI team

안녕하세요 효진입니다.  
제가 입사한 이후 1년 8개월만에 시스템에 도입되는 수준의 R code 를 처음이자 마지막으로 엔텔스에서 만들어 봅니다.  
돌이켜 보면 오랫동안 이러한 분석 시스템 소프트웨어를 만들기를 엔텔스에 들어와서 희망하지 않았나 싶습니다.  
그리고 미약한 소프트웨어로 시작해 지속적으로 고도화 하고 발전시키는 것을 제 개인적인 목적으로 갖고 있었답니다.  
도로교통공단에서는 희망했던 그러한 일을 자력으로 수행해 보지 못했지만,  
DEMS 라는 프로젝트를 통해서 이런 기회를 얻게 되어 기쁩니다.  

저는 흔적을 남기는 것을 되게 좋아하는 것 같습니다.  
기억속에서 언젠가 잊혀지는 말보다는, 반영구적으로 남는 흔적인 글 혹은 코드를 좋아 하는것 같습니다.  
이 흔적이 오래오래 남아서 BI 팀에 조금이라도 의미가 있게 쓰였으면 좋겠고, 만약 이 결과물들이 소중한 자산으로 BI팀에게 남게 된다면 이후에 정말로 뿌듯할 것 같습니다.  
누군가가 이 미약한 분석 시스템을 고도화 하고 발전시키는 것을 연이어서 해 주시길 진심으로 바랍니다.  

> HyoJin Song - 2018-09-06 20:27