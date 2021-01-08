library( tidyverse )

gw1719 <- readRDS("./data/gw_pops_1719.rds")

# 강원도 전체 합을 저장하고 있는 행 제거
gw1719 %>%
  filter( region != "강원도")

# 년도별로 연령구간인구수 열 제거
gw1719 %>%
  filter( region != "강원도") %>%
  select( -ends_with("연령구간인구수") )

# 첫번째와 두번째 열과 열 이름 중 "_계_"가 들어간 열만 선택
# 남녀 구분은 하지 않고 총 인구만
gw1719 %>%
  filter( region != "강원도") %>%
  select( -ends_with("연령구간인구수") ) %>%
  select( 1:2, contains("_계_"))

# 기존 변수 대체
gw1719 %>%
  filter( region != "강원도") %>%
  select( -ends_with("연령구간인구수") ) %>%
  select( 1:2, contains("_계_")) -> gw1719



# 열 이름 중 "_계" 제거
names(gw1719)
names(gw1719) <- str_replace( names(gw1719), "_계", "")
names(gw1719)

# 15세 미만, 65세 미만, 65세 이상의 인구와 전체 인구를 구함 (총인구수 열이 있으나, 자료로부터 합을 구함)
# 각 년도별로 3가지 연령대를 갖는 데이터 프레임 생성
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