library( tidyverse )
# leaflet 로드
library( leaflet )

# 사용할 데이터
result <- readRDS("./data/2019_GW_ta_deaths.rds")

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

