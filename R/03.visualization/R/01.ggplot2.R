library( tidyverse )

gw_ag <- read_csv("./data/gw0819agl.csv",
                  locale = locale("ko", encoding = "euc-kr"))

gw_ag

# 시군별 고령화율 변화

# Data
gw_ag %>% 
  filter(agecat == "g3o65")

# ggplot 객체 생성  
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( )

# geom_ 객체 추가하기
# geom_point
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( ) +
    geom_point( aes( year, props*100 ) )

# geom_line
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( ) +
    geom_point( aes( year, props*100 ) ) +
    geom_line( aes( year, props*100 ) )

# Group 화
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( ) +
    geom_point( aes( year, props*100 ) ) +
    geom_line( aes( year, props*100, color = region ) )

# geom_text
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( ) +
  geom_point( aes( year, props*100 ) ) +
    geom_line( aes( year, props*100, color = region ) ) +
    geom_text( aes( year, props*100, label=round(props*100, 1)) )
  
# aes( ) 
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( aes( year, props*100 ) ) +
    geom_point(  )  +
    geom_line( aes( color=region ) ) +
    geom_text( aes( label=round(props*100, 1)) )

# Data 
gw_ag %>%
  filter( agecat == "g3o65" ) %>%
  ggplot( aes( year, props*100 ) ) +
    geom_point( aes( shape = region, color = region ), show.legend = FALSE )  +
    geom_line( aes( color=region ) ) +
    geom_text( aes( label=round(props*100, 1)), size=2, show.legend = FALSE, nudge_x = 0.2 )

# scale
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( aes( year, props*100 ) ) +
    geom_point( aes( shape = region, color = region ), show.legend = FALSE )+
    geom_line( aes( color = region ) ) +
    geom_text( aes( label=round(props*100, 1) ), size=2, show.legend = FALSE, nudge_x = 0.2 ) +
    scale_x_continuous( "년도", breaks = 2008:2019 ) +
    scale_shape_manual( values=1:18 )


# 축제목, 범례 제목 등의 설정
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( aes( year, props*100 ) ) +
    geom_point( aes( shape = region, color = region ), show.legend = FALSE )+
    geom_line( aes( color = region ) ) +
    geom_text( aes( label=round(props*100, 1) ), size=2, show.legend = FALSE, nudge_x = 0.2 ) +
    scale_x_continuous( "년도", breaks = 2008:2019 ) +
    scale_shape_manual( values=1:18 ) +
    labs(y="비율(%)", color="시군")

# 테마
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( aes( year, props*100 ) ) +
    geom_point( aes( shape = region, color = region ), show.legend = FALSE )+
    geom_line( aes( color = region ) ) +
    geom_text( aes( label=round(props*100, 1) ), size=2, show.legend = FALSE, nudge_x = 0.2 ) +
    scale_x_continuous( "년도", breaks = 2008:2019 ) +
    scale_shape_manual( values=1:18 ) +
    labs(y="비율(%)", color="시군") +
    theme_minimal()


# 사용자 정의
gw_ag %>% 
  filter(agecat == "g3o65") %>%  
  ggplot( aes( year, props*100 ) ) +
    geom_point( aes( shape = region, color = region ), show.legend = FALSE )+
    geom_line( aes( color = region ) ) +
    geom_text( aes( label=round(props*100, 1) ), size=2, show.legend = FALSE, nudge_x = 0.2 ) +
    scale_x_continuous( "년도", breaks = 2008:2019 ) +
    scale_shape_manual( values=1:18 ) +
    labs(y="비율(%)", color="시군") +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill="#cad9db"),
      axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"),
      panel.background = element_rect(fill="#f5f3f0", color=NA),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.major = element_line(color="gray", linetype = 2)
    )

summary( theme_minimal() )


# 도표
gw_ag %>%
  filter( agecat == "g3o65" ) %>%
  mutate( prop100 = props*100) %>%
  mutate( region_title = str_replace(region, "강원도 ", "")  ) %>%
  ggplot( aes( year, prop100 ) ) +
    geom_point( aes( shape = region_title, color = region_title ), show.legend = FALSE )  +
    geom_line( aes( color=region_title ) ) +
    geom_text( aes( label=round(prop100, 1)), size=2, show.legend = FALSE, nudge_x = 0.2 ) +
    scale_x_continuous( "년도", breaks = 2008:2019 ) +
    scale_shape_manual( values=1:18 ) +
    labs(y="비율(%)", color="시군") +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill="#cad9db"),
      axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"),
      panel.background = element_rect(fill="#f5f3f0", color=NA),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.major = element_line(color="gray", linetype = 2)
    )


# facet_wrap
gw_ag %>%
  filter( agecat == "g3o65" ) %>%
  mutate( prop100 = props*100) %>%
  mutate( region_title = str_replace(region, "강원도 ", "")  ) %>%
  ggplot( aes( year, prop100 ) ) +
    geom_point( aes( color = region_title ), show.legend = FALSE )  +
    geom_line( aes( color=region_title ), show.legend = FALSE ) +
    geom_text( aes( label=round(prop100, 1)), size=2, show.legend = FALSE, nudge_x = 0.2 ) +
    scale_x_continuous( "년도", breaks = 2008:2019 ) +
    scale_shape_manual( values=1:18 ) +
    labs(y="비율(%)", color="시군") +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill="#cad9db"),
      axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"),
      panel.background = element_rect(fill="#f5f3f0", color=NA),
      panel.grid.minor.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.major = element_line(color="gray", linetype = 2)
    ) +
    facet_wrap( vars(region_title) )


# facet_grid
gw_ag %>%
  mutate( prop100 = props*100) %>%
  mutate( region_title = str_replace(region, "강원도 ", "")  ) %>%
  ggplot( aes( year, prop100 ) ) +
  geom_point( aes( color = region_title ), show.legend = FALSE )  +
  geom_line( aes( color=region_title ), show.legend = FALSE ) +
  geom_text( aes( label=round(prop100, 1)), size=2, show.legend = FALSE, nudge_x = 0.2 ) +
  scale_x_continuous( "년도", breaks = 2008:2019 ) +
  scale_shape_manual( values=1:18 ) +
  labs(y="비율(%)", color="시군") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill="#cad9db"),
    axis.line = element_line(size = 0.5, linetype = "solid", colour = "black"),
    panel.background = element_rect(fill="#f5f3f0", color=NA),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.major = element_line(color="gray", linetype = 2)
  ) +
  facet_grid( rows = vars(region_title), cols = vars(agecat) )