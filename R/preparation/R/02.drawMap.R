library( tidyverse )
library( readxl )
library( sf )


gw_pops_emd2 <- readRDS("./export/gw_pops_emd.rds")

# 통계분류포털 : 한국행정구역분류 - 자료실
# https://kssc.kostat.go.kr:8443/ksscNew_web/index.jsp
korea_adm_codes <- read_excel("./data/korea_adm_code_2020_12.xlsx", sheet="법정동코드 연계 자료분석용", skip=1)
korea_adm_codes

gw_pops_emd2 %>%
  left_join( korea_adm_codes %>% select("행정기관코드", "법정동코드") %>% 
               mutate( 행정기관코드 = as.character( format(행정기관코드, digits=10) ),
                      법정동코드 = as.character( format(법정동코드, digits=10) ) ), 
             by=c("region_cd" = "행정기관코드") ) -> gw_pops_emd3


gw_pops_emd3 %>%
  mutate( EMD_CD = substr(법정동코드, 1, 8) ) -> gw_pops_emd3_bjd_cd

gw_pops_emd3_bjd_cd %>%
  rename("BJD_CD" = "법정동코드") -> gw_pops_emd3_bjd_cd

saveRDS( gw_pops_emd3_bjd_cd, "./export/gw_pops_emd3_bjd_cd.rds" )
write.csv(gw_pops_emd3_bjd_cd, "./data/gw_pops_emd_2020.csv", row.names = FALSE)


# 지도 데이터 로드
# data from : https://www.juso.go.kr/addrlink/devLayerRequestWrite.do (도로명주소 전자지도)
# 2020년 센서스용 행정구역경계 (시군구, 읍면동, 좌표계 UTM-K(GRS80타원체))

gw_hj_emd <- st_read("./data/gw_hj_emd", "TL_SCCO_EMD", options="ENCODING=EUC-KR" )
gw_hj_emd

# 읍면동 인구
gw_hj_emd %>%
  left_join( gw_pops_emd3_bjd_cd, by="EMD_CD" ) %>%
  ggplot() +
  geom_sf( aes(fill = total) ) +
  scale_fill_gradient2("인구", low="#C6FFDD", mid="#FBD786", high="#f7797d", na.value=NA) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text =  element_blank()
  )



# 고령화율 : g3o65
# 14세 이하 : g1u14
gw_hj_emd %>%
  left_join( gw_pops_emd3_bjd_cd, by="EMD_CD" ) %>%
  mutate( op = g1u14 / total ) %>% select(op) %>%
  ggplot() +
    geom_sf( aes(fill = op) ) +
    scale_fill_gradient2("14세 이하 비율", low="#f7797d", mid="#FBD786", high="#C6FFDD", na.value=NA) +
    theme_minimal() +
    theme(
      panel.grid = element_blank(),
      axis.text =  element_blank()
    )


# 시군별 합을 구한 후 고령화율 계산
# 주어진 자료에서 시군코드는 행정기관코드의 앞 5자리가 시군별 코드
# 6자리 이후 모두 0이면 시군별 계
gw_pops_emd3_bjd_cd %>%
  mutate( is_sgg_total = ifelse(substr(region_cd, 6, 10) == "00000", 1, 0) ) %>%
  filter( is_sgg_total == 1) %>%
  mutate( o65prop = g3o65 / total ) %>%
  mutate( SIG_CD = substr(region_cd, 1, 5)) %>%
  select( -region_cd, -is_sgg_total, -EMD_CD ) -> gw_pops_sgg

gw_pops_sgg

gw_hj_sgg <- st_read("./data/gw_hj_sgg", "TL_SCCO_SIG", options="ENCODING=EUC-KR" )
gw_hj_sgg %>%
  left_join( gw_pops_sgg, by="SIG_CD") %>%
  mutate( op = g3o65 / total ) %>% select(region, op) %>%
  ggplot() +
  geom_sf( aes(fill = op) ) +
  geom_sf_text( aes(label = region) ) +
  labs(x="", y="") + 
  scale_fill_gradient2("고령화율", low="#1E9600", mid="#FFF200", high="#FF0000", midpoint = 0.2, na.value=NA) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.text =  element_blank()
  )
