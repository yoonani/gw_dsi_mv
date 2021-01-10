library( tidyverse )

###################
#   비율 구하기   #
###################

# 데이터 불러오기
gw_1719_5age_pops <- readRDS( "./data/gw_1719_5age_pops.rds" )



# 열 이름을 연령대 변수(vars)의 값(pops)이 되도록 long format으로 변환
gw_1719_5age_pops %>%
  pivot_longer(-(1:2), names_to="vars", values_to="pops")


# vars 변수를 년도(year)와 연령대(agecat) 변수로 분리
gw_1719_5age_pops %>%
  pivot_longer(-(1:2), names_to="vars", values_to="pops") %>%
  separate(vars, c("year", "agecat")) 

# 새로운 변수로 저장
gw_1719_5age_pops %>%
  pivot_longer(-(1:2), names_to="vars", values_to="pops") %>%
  separate(vars, c("year", "agecat")) -> gw_1719_5age_pops_long



# prop.table( ) 함수를 이용하여 비율 구하기
gw_1719_5age_pops_long %>%
  group_by(region, year) %>%
  summarise( 
    agecat = agecat,
    props = prop.table(pops) ) %>%
  ungroup() -> gw_1719_5age_pops_long_prop


# 기존 데이터와 비율 데이터 조인
gw_1719_5age_pops_long %>%
  left_join( gw_1719_5age_pops_long_prop ) -> gw_1719_5age_pops_long


gw_1719_5age_pops_long


# 위와 같이 정리한 데이터를 다음에 저장하였습니다.
# 이를 이용해 봅시다
gw_ag <- read_csv("./data/gw0819agl.csv",
                  locale = locale("ko", encoding = "euc-kr"))

gw_ag

gw_ag %>% 
  filter(agecat == "g3o65") %>% 
  select(region, year, props)

# 시군별 고령화율 변화

# 테이블
gw_ag %>%
  filter( agecat == "g3o65" ) %>%
  pivot_wider(region, names_from = "year", values_from="props")
