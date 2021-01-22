# install.packages("ggthemes")
library( tidyverse )
library( XML )

# 요청 URL과 구하고자 하는 요청변수
reqURL <- "http://apis.data.go.kr/B552061/AccidentDeath/getRestTrafficAccidentDeath"
myKey <- "RWFEucfLuyiglprc5BWByBmKAOyIxzS4qvUhO7ZGoi%2FAomTDwdDCUE1oGNAYWZBJ8TgD99XVfdfOAhco0Db6Lw%3D%3D"
param <- c("ServiceKey", "searchYear", "siDo", "guGun", "numOfRows", "pageNo")
values <- c(myKey, 2019, 1400, 1402, 50, 1)

# 요청 URL 만들기
paste( param, values, sep="=" )
paste( param, values, sep="=", collapse="&" )

req <- paste( reqURL, 
              paste( param, values, sep="=", collapse="&" ), 
              sep="?" )

req

# 요청하기
response <- xmlTreeParse(req, useInternalNodes = TRUE, encoding="UTF-8")
summary( response )

rn <- xmlRoot(response)
rn

# 특정노드의 값 가져오기
xpathApply(rn, "//resultMsg", xmlValue)
xpathApply(rn, "//totalCount", xmlValue)

# 전체 응답수 : 만일 이 수가 현재 페이지당 데이터수보다 크면, 또 다시 호출
numRows <- xpathApply(rn, "//totalCount", xmlValue)

# 결과를 데이터 프레임을 저장하기
taDeath <- xmlToDataFrame( nodes = getNodeSet(rn, "//item") )
View( taDeath )
dim( taDeath )


# 사망자수, 부상자수 구하기
taDeath %>%
  mutate(dth_dnv_cnt = as.numeric(dth_dnv_cnt)) %>%
  mutate(injpsn_cnt = as.numeric(injpsn_cnt)) %>%
  summarise( 
    n = n(),
    nd = sum(dth_dnv_cnt),
    ni = sum(injpsn_cnt)
  )

# 요일별 사망자수와 부상자수
taDeath %>%
  mutate(dth_dnv_cnt = as.numeric(dth_dnv_cnt)) %>%
  mutate(injpsn_cnt = as.numeric(injpsn_cnt)) %>%
  group_by(occrrnc_day_cd) %>%
  summarise(
    n = n(),
    nd = sum(dth_dnv_cnt),
    ni = sum(injpsn_cnt)
  ) 


# factor 생성
# 숫자로 된 요일에 Label 붙히기
class( taDeath$occrrnc_day_cd )
table( taDeath$occrrnc_day_cd )

factor( taDeath$occrrnc_day_cd )

factor( taDeath$occrrnc_day_cd,
        levels = 1:7,
        labels = c("일", "월", "화", "수", "목", "금", "토") )


# 요일 이름표 붙혀주기
taDeath %>%
  mutate(dth_dnv_cnt = as.numeric(dth_dnv_cnt)) %>%
  mutate(injpsn_cnt = as.numeric(injpsn_cnt)) %>%
  group_by(occrrnc_day_cd) %>%
  summarise(
    n = n(),
    nd = sum(dth_dnv_cnt),
    ni = sum(injpsn_cnt)
  ) %>% 
  mutate( wday = factor( occrrnc_day_cd,
                         levels = 1:7, 
                         labels=c("일", "월", "화", "수", "목", "금", "토")
                  )
        ) %>% 
  select(wday, n, nd, ni)


# 강원도 전체 시군 자료 불러오기

# 자료의 코드와 시군 이름 데이터 생성 : 요청시 gugun 에 코드 값 전달
# 공공데이터 포털에서 제공하고 있는 "기술문서_도로교통공단_사망교통사고정보.hwp" 참조

gwTAcode <- tibble(
  SGcode = as.character( c( 1404, 1422, 1403, 1407, 1405, 1420, 1423, 1415, 1402, 
              1421, 1417, 1418, 1401, 1406, 1416, 1412, 1419, 1413 ) ),
  SGname = c( "강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", 
              "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군" )
  )

gwTAcode

saveRDS(gwTAcode, "./data/gwTAcode.rds")


# 요청 함수 만들기
setReqURL <- function(key, year=2019, sido=1400, sigun=1402, numRows=50, page=1) {
  param <- c("ServiceKey", "searchYear", "siDo", "guGun", "numOfRows", "pageNo")
  values <- c(key, year, sido, sigun, numRows, 1)
  
  req <- paste(reqURL, 
               paste(param, values, sep="=", collapse="&"), 
               sep="?")
  return( req )
}

setReqURL( myKey, sigun=1401 )

# 결과물이 저장될 빈 데이터 프레임 생성
data.frame( matrix( vector("character"), ncol=ncol(taDeath), nrow=0) )

# 기존 결과물의 열 이름을 가진 빈 데이터 프레임 생성
names(taDeath)
result <- setNames(
            data.frame(
              matrix( vector("character"), ncol=ncol(taDeath), nrow=0)
            ), 
            names(taDeath) )

str( result )


# 춘천(1401)과 원주(1402)의 데이터를 요청하고 값을 result에 쌓아가기
req <- setReqURL(key = myKey, sigun = 1401)
response <- xmlTreeParse(req, useInternalNodes = TRUE, encoding="UTF-8")
rn <- xmlRoot(response)
xpathApply(rn, "//totalCount", xmlValue)
result %>%
  bind_rows( xmlToDataFrame( nodes = getNodeSet(rn, "//item") ) ) -> result
dim(result)

req <- setReqURL(key = myKey, sigun = 1402)
response <- xmlTreeParse(req, useInternalNodes = TRUE, encoding="UTF-8")
rn <- xmlRoot(response)
xpathApply(rn, "//totalCount", xmlValue)
result %>%
  bind_rows( xmlToDataFrame( nodes = getNodeSet(rn, "//item") ) ) -> result
dim(result)

result


# 반복문을 사용하여 각 시군의 데이터를 요청하고 결과를 저장하기
# 데이터프레임 초기화
result <- result[NULL,]
for(i in 1:nrow(gwTAcode)) {
  req <- setReqURL(key = myKey, sigun = gwTAcode[i, 1])
  response <- xmlTreeParse(req, useInternalNodes = TRUE, encoding="UTF-8")
  rn <- xmlRoot(response)
  result %>%
    bind_rows( xmlToDataFrame( nodes = getNodeSet(rn, "//item") ) ) -> result
}

dim( result )
View( result )

# 2019년 강원도 교통사고 사망자수 자료 저장
saveRDS(result, "./data/2019_GW_ta_deaths.rds")


# 아래 코드는 각자 한번 실행해 보세요 :)


# 사망자수, 부상자수 구하기
# dth_dnv_cnt
result %>%
  mutate(dth_dnv_cnt = as.numeric(dth_dnv_cnt)) %>%
  mutate(injpsn_cnt = as.numeric(injpsn_cnt)) %>%
  summarise( 
    n = n(),
    nd = sum(dth_dnv_cnt),
    ni = sum(injpsn_cnt)
  )

# 요일별 사망자수와 부상자수
result %>%
  mutate(dth_dnv_cnt = as.numeric(dth_dnv_cnt)) %>%
  mutate(injpsn_cnt = as.numeric(injpsn_cnt)) %>%
  group_by(occrrnc_day_cd) %>%
  summarise(
    n = n(),
    nd = sum(dth_dnv_cnt),
    ni = sum(injpsn_cnt)
  ) %>%
  mutate( wday = factor( occrrnc_day_cd,
                  levels = as.character(1:7), 
                  labels=c("일", "월", "화", "수", "목", "금", "토")
                 )
          ) %>%
  select(wday, n, nd, ni)


# 도로형태별 사망자수와 부상자수
result %>%
  mutate(dth_dnv_cnt = as.numeric(dth_dnv_cnt)) %>%
  mutate(injpsn_cnt = as.numeric(injpsn_cnt)) %>%
  group_by(road_frm_cd) %>%
  summarise( 
    n = n(),
    nd = sum(dth_dnv_cnt),
    ni = sum(injpsn_cnt)
  ) %>% 
  left_join( read_csv("./data/road_frm_cd_nm.csv", locale = locale("ko", encoding = "euc-kr")), by="road_frm_cd")
