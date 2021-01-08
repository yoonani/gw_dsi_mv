library( tidyverse )
library( lubridate )
library( readxl )

# 도로교통공단 TAAS 교통사고분석시스템
# 교통사고 GIS 분석 시스템
# http://taas.koroad.or.kr/gis/mcm/mcl/initMap.do?menuId=GIS_GMP_STS_RSN
# 한계 읍면동까지만 나옴
# 검색조건 사망사고, 중상사고, 사고유형 : 차대사람
ta <- read_excel( "./data/taas_gw_2019_ta.xlsx" )

names( ta )

# 시 부분 제거
ta %>%
  extract(사고일시, into = c('date', 'time'), '(.*) ([0-9]{1,2}시$)') -> ta

ta$date <- as.Date(ta$date, format="%Y년 %m월 %d일")

ta %>%
  mutate( weekday = wday(ta$date, label=TRUE), .before=요일) %>%
  select( -요일 ) -> ta


# 요일별 교통사고 
# apply 대응 : rowwise(), c_across()
ta %>%
  group_by( weekday ) %>%
  summarise(
    across(사망자수:경상자수, sum)
  ) %>%
  ungroup() %>%
  rowwise() %>%
  mutate( total =  sum(c_across(사망자수:경상자수))  ) -> ta_weekday
  

# 서로 다른 변수(열)이라면???
ggplot(ta_weekday, aes(weekday)) +
  geom_bar( aes(y=total), stat="identity")

# long format 변환
ta_weekday %>%
  pivot_longer(cols=-c(weekday, total), names_to = "type", values_to = "n") %>%
  ggplot(aes(weekday)) +
    geom_bar( aes(y=n, fill=type), stat="identity", position = "stack") +
    labs(x = "요일", y = "피해자수") +
    scale_fill_manual("피해유형", values=c('#1b9e77','#d95f02','#7570b3')) +
    theme_minimal() +
    theme(
      panel.grid.major.x = element_blank()
    )

# 비율로
ta_weekday %>%
  pivot_longer(cols=-c(weekday, total), names_to = "type", values_to = "n") %>%
  ggplot(aes(weekday)) +
  geom_bar( aes(y=n/total, fill=type), stat="identity", position = "stack") +
  labs(x = "요일", y = "피해자수") +
  scale_fill_manual("피해유형", values=c('#1b9e77','#d95f02','#7570b3')) +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank()
  )



# 월별 교통사고 
# apply 대응 : rowwise(), c_across()

month( ta$date )

ta %>%
  mutate( month = month( ta$date ), .before=weekday) %>%
  group_by( month ) %>%
  summarise(
    across(사망자수:경상자수, sum)
  ) %>%
  ungroup() %>%
  rowwise() %>%
  mutate( total =  sum(c_across(사망자수:경상자수))  ) -> ta_month


# long format 변환
ta_month %>%
  pivot_longer(cols=-c(month, total), names_to = "type", values_to = "n") %>%
  ggplot(aes(month)) +
  geom_bar( aes(y=n, fill=type), stat="identity", position = "stack") +
  labs(x = "월", y = "피해자수") +
  scale_fill_manual("피해유형", values=c('#1b9e77','#d95f02','#7570b3')) +
  scale_x_continuous(breaks=1:12, labels = paste0(1:12, "월")) +
  theme_minimal() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )


# 읍면동
ta %>%
  group_by( 시군구 ) %>%
  summarise(
    across(사망자수:경상자수, sum)
  ) %>%
  ungroup() %>%
  rowwise() %>%
  mutate( total =  sum(c_across(사망자수:경상자수))  ) -> ta_emd
  


# 지도와의 연계를 위해 법정동 코드 불러오기
korea_adm_codes <- read_excel("./data/korea_adm_code_2020_12.xlsx", sheet="법정동코드 연계 자료분석용", skip=1)

# 교통사고에는 읍면동이 한 열에 있으므로 이를 위해 자료 준비
korea_adm_codes %>%
  filter(시도 == "강원도") %>%
  filter(str_length(행정구역코드) == 7) %>%
  filter(str_detect(법정동코드, "00$")) %>%
  mutate(BJD_CD = substr(법정동코드, 1, 8)) %>%
  select(-(6:13)) %>%
  mutate(BJD_NM = paste(시도, 시군구, 법정동, sep=" ") ) -> gw_bjd_cd

# 교통사고 데이터와 결합
gw_bjd_cd %>%
  left_join( ta_emd, by=c("BJD_NM" = "시군구")) -> ta_emd

# 읍면동 정보 불러오기
gw_hj_emd <- st_read("./data/gw_hj_emd", "TL_SCCO_EMD", options="ENCODING=EUC-KR" )
gw_hj_emd %>%
  left_join(ta_emd, by=c("EMD_CD"="BJD_CD")) %>%
  ggplot() +
    geom_sf( aes(fill = total) ) +
    scale_fill_gradient("인명피해수", low="#F1F2B5", high="#135058", na.value=NA) +
    theme_minimal() +
    theme(
      panel.grid = element_blank(),
      axis.text =  element_blank()
    )



