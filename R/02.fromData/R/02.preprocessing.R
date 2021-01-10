library( tidyverse )

gw1719 <- readRDS("./data/gw_pops_1719.rds")

# Step#1) 분석에서 제외할 행 제거
# 강원도 전체 인구를 저장하고 있는 행 (region의 값이 "강원도"인 행)
gw1719 %>%
  filter( region != "강원도")

# Step #2) 년도별로 연령구간인구수 열 제거
# 열 이름이 "연령구간인구수"로 끝나는 열
gw1719 %>%
  filter( region != "강원도") %>%
  select( -ends_with("연령구간인구수") )

# Step #3) 성별 및 전체 인구를 갖고 있는 자료로 이중 전체 인구만 사용
# 열 이름에 문자열 "_계_"를 담고 있는 열
gw1719 %>%
  filter( region != "강원도") %>%
  select( -ends_with("연령구간인구수") ) %>%
  select( 1:2, contains("_계_"))

# 기존 변수 대체
gw1719 %>%
  filter( region != "강원도") %>%
  select( -ends_with("연령구간인구수") ) %>%
  select( 1:2, contains("_계_")) -> gw1719


# Step #4) 열 이름 중 문자열 "_계" 제거
# str_replace( 문자열, 바꿀 문자열 패턴, 바뀔 문자열)
names(gw1719)
names(gw1719) <- str_replace( names(gw1719), "_계", "")
names(gw1719)

# 5세 단위 연령대를 “14세 이하, 15~64세, 65세 이상”의 연령대로 재구조화
# 각 년도별로 3가지 연령대를 갖는 데이터 프레임 생성
# apply( 데이터프레임, (1 또는 2), 함수명 )
names( gw1719 )
gw_1719_5age_pops <- data.frame( 
  region = gw1719$region,
  region_cd = gw1719$region_cd,
  y2017_g1u14 = apply( gw1719[, 4:6], 1, sum ), 
  y2017_g2o15 = apply( gw1719[, 7:16], 1, sum ), 
  y2017_g3o65 = apply( gw1719[, 17:24], 1, sum ),
  y2018_g1u14 = apply( gw1719[, 26:28], 1, sum ), 
  y2018_g2o15 = apply( gw1719[, 29:38], 1, sum ), 
  y2018_g3o65 = apply( gw1719[, 39:46], 1, sum ),
  y2019_g1u14 = apply( gw1719[, 48:50], 1, sum ), 
  y2019_g2o15 = apply( gw1719[, 51:60], 1, sum ), 
  y2019_g3o65 = apply( gw1719[, 61:68], 1, sum )
)

saveRDS(gw_1719_5age_pops, "./data/gw_1719_5age_pops.rds")