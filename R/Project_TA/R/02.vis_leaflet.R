library( tidyverse )
library( ggthemes )
# leaflet 로드
library( leaflet )


# 사용할 데이터
result <- readRDS("./data/2019_GW_ta_deaths.rds")



# 시군별 사망자수와 부상자수
# gwTAcode
result %>%
  mutate(dth_dnv_cnt = as.numeric(dth_dnv_cnt)) %>%
  mutate(injpsn_cnt = as.numeric(injpsn_cnt)) %>%
  group_by(occrrnc_lc_sgg_cd) %>%
  summarise(
    n = n(),
    nd = sum(dth_dnv_cnt),
    ni = sum(injpsn_cnt)
  ) %>%
  left_join( gwTAcode, by=c("occrrnc_lc_sgg_cd"="SGcode") ) %>%
  select( SGname, n, nd, ni) -> ta_gw_sgg

View( ta_gw_sgg )


# 2nd
# 그래프 작성 : 막대도표( geom_bar )
# ggthemes 패키지를 이용하여 테마 확장

ta_gw_sgg %>%
  ggplot() +
  geom_bar( aes(x=SGname, y=n), stat="identity") +
  theme_wsj()

# 시군별 사망자수와 부상자수
# 사망자수와 부상자수를 관찰변수로 즉, long format 변환
View( ta_gw_sgg )
ta_gw_sgg %>%
  pivot_longer( cols=c(nd, ni), 
                names_to = "type", values_to = "noi" ) %>% View()

# 그래프 작성
ta_gw_sgg %>%
  pivot_longer( cols=c(nd, ni), 
                names_to = "type", values_to = "noi" ) %>%
  ggplot( aes(x=SGname, y=noi) ) +
  geom_bar( aes(fill=type), stat="identity", position="dodge") +
  scale_fill_manual("유형", 
                    breaks = c("nd", "ni"),
                    labels = c("사망자수", "부상자수"),
                    values = c("#6e695c", "#f0ca0e")) +
  theme_wsj() +
  theme(
    legend.position = "bottom",
    legend.title = element_text(size=12),
    legend.key.size = unit(0.3, "cm")
  )


# leaflet 사용하기
result %>%
  leaflet()

# addTiles()로 지도 올리기
result %>%
  leaflet() %>%
    addTiles()

# 중심위치와 확대정도 설정하기
result %>%
  leaflet() %>%
    setView( lng = 128.3105, lat = 37.6836, zoom = 8 ) %>%
    addTiles()


# Marker를 이용하여 표시하기
result %>%
  mutate( noi = as.numeric(dth_dnv_cnt) + as.numeric(injpsn_cnt) ) %>%
  leaflet() %>%
    setView( lng = 128.3105, lat = 37.6836, zoom = 8 ) %>%
    addTiles() %>%
    addCircleMarkers( lng = ~as.numeric(lo_crd), 
                      lat = ~as.numeric(la_crd), 
                      radius = ~as.numeric(noi),
                      stroke = FALSE, fillOpacity = 0.7)

# Marker를 이용하여 표시하기
result %>%
  mutate( noi = as.numeric(dth_dnv_cnt) + as.numeric(injpsn_cnt) ) %>%
  leaflet() %>%
    setView( lng = 128.3105, lat = 37.6836, zoom = 8 ) %>%
    addTiles() %>%
    addCircleMarkers( lng = ~as.numeric(lo_crd), 
                      lat = ~as.numeric(la_crd), 
                      radius = ~as.numeric(noi),
                      stroke = FALSE, fillOpacity = 0.7)

# Marker 클릭시 팝업 창 띄우기
result %>%
  mutate( noi = as.numeric(dth_dnv_cnt) + as.numeric(injpsn_cnt) ) %>%
  leaflet() %>%
    setView( lng = 128.3105, lat = 37.6836, zoom = 8 ) %>%
    addTiles() %>%
    addCircleMarkers( lng = ~as.numeric(lo_crd), 
                      lat = ~as.numeric(la_crd), 
                      radius = ~as.numeric(noi),
                      stroke = FALSE, fillOpacity = 0.7,
                      popup = ~paste0("사망자수 : ", dth_dnv_cnt,
                                      "<br />",
                                      "부상자수 : ", injpsn_cnt))


# 지도 바꾸기 : addProviderTiles( )
result %>%
  mutate( noi = as.numeric(dth_dnv_cnt) + as.numeric(injpsn_cnt) ) %>%
  leaflet() %>%
    setView( lng = 128.3105, lat = 37.6836, zoom = 8 ) %>%
    addProviderTiles("Stamen.Toner") %>%
    addCircleMarkers( lng = ~as.numeric(lo_crd), 
                      lat = ~as.numeric(la_crd), 
                      radius = ~as.numeric(noi),
                      stroke = FALSE, fillOpacity = 0.7,
                      popup = ~paste0("사망자수 : ", dth_dnv_cnt,
                                      "<br />",
                                      "부상자수 : ", injpsn_cnt))

# 지원하는 지도
# https://leaflet-extras.github.io/leaflet-providers/preview/


# 클러스터로 표현하기
result %>%
  mutate( noi = as.numeric(dth_dnv_cnt) + as.numeric(injpsn_cnt) ) %>%
  leaflet() %>%
    setView( lng = 128.3105, lat = 37.6836, zoom = 8 ) %>%
    addProviderTiles("Stamen.Toner") %>%
    addCircleMarkers( lng = ~as.numeric(lo_crd), 
                      lat = ~as.numeric(la_crd), 
                      radius = ~as.numeric(noi),
                      stroke = FALSE, fillOpacity = 0.7,
                      clusterOptions = markerClusterOptions()
    )

