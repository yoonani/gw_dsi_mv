#devtools::install_github("yutannihilation/ggsflabel", force=TRUE)

library( tidyverse )
library( readxl )
library( sf )
library( rvest )
library( readxl )
library( sf )
library( extrafont )
library( ggsflabel )



#font_import(pattern="KoPub")
fonts()
loadfonts(device="win")

url <- "https://www.provin.gangwon.kr/covid-19.html"
read_html( url ) %>% html_nodes(".txt-c") %>% html_text -> curCOVID


curCOVID[1] <- parse_number( str_extract(curCOVID[1], "확진자: ([0-9,]+)") )
curCOVID <- as.numeric( curCOVID )

gw_pop <- read_excel("./data/gw_pops_2020.xlsx")

gw_pop_covid <- cbind(gw_pop, curCOVID)

names( gw_pop_covid ) <- c("hjgg_cd", "region", "pops", "nop")

gw_pop_covid %>%
  mutate( hj_cd = substr(hjgg_cd, 1, 5)) 

gw_hj_sgg <- st_read("./data/gw_hj_sgg", "TL_SCCO_SIG", options="ENCODING=EUC-KR" )

gw_hj_sgg %>%
  left_join(gw_pop_covid %>%
              mutate( hj_cd = substr(hjgg_cd, 1, 5)) , by=c("SIG_CD" = "hj_cd")) %>%
  ggplot() +
    geom_sf( aes(fill = nop) ) +
    geom_sf_label_repel( aes(label = paste(region, "\n(", nop, "명)") ),
                  family="KoPubWorldDotum Medium", force=10) +
    labs(x="", y="") + 
    scale_fill_gradient2("확진자", low="#1E9600", mid="#FFF200", high="#FF0000", midpoint = median(gw_pop_covid$nop), na.value=NA) +
    theme_minimal() +
    theme(
      text = element_text(size = 12, family="KoPubWorldDotum Medium"),
      panel.grid = element_blank(),
      axis.text =  element_blank()
    ) +
    coord_sf()



gw_hj_sgg %>%
  left_join(gw_pop_covid %>%
              mutate( hj_cd = substr(hjgg_cd, 1, 5)) , by=c("SIG_CD" = "hj_cd")) %>%
  mutate( ppp = nop / (pops/10000) ) -> gw_cvd
  ggplot(gw_cvd) +
  geom_sf( aes(fill = ppp) ) +
  geom_sf_label_repel( aes(label = paste(region, "\n(", round(ppp,1),  "명)") ),
                       family="KoPubWorldDotum Medium", force=10) +
  labs(x="", y="") + 
  scale_fill_gradient2("만명당 확진자 수", low="#1E9600", mid="#FFF200", high="#FF0000", midpoint = median( gw_cvd$ppp ), na.value=NA) +
  theme_minimal() +
  theme(
    text = element_text(size = 12, family="KoPubWorldDotum Medium"),
    panel.grid = element_blank(),
    axis.text =  element_blank()
  ) +
  coord_sf()


