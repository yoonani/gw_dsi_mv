library( tidyverse )

gw_pops_emd <- read_csv( "./data/gw_202011_5age_emd.csv", locale = locale("ko", encoding = "euc-kr"))


tmp <- as.data.frame( do.call( rbind, str_split(gw_pops_emd$행정구역, "\\(", n=2) ) )

# Step #3
names(tmp) <- c("region", "region_cd")

# Step #4
tmp$region <- trimws(tmp$region)

# Step #5
tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")

# Step #6
gw_pops_emd <- as_tibble( cbind( tmp, gw_pops_emd ) )

# Step #7
gw_pops_emd %>%
  select(-행정구역) %>%
  select( 1:2, contains("_계_") ) -> gw_pops_emd


names( gw_pops_emd ) <- str_replace( names(gw_pops_emd), "_계", "")

names( gw_pops_emd )

gw_pops_emd2 <- data.frame( 
  region = gw_pops_emd$region,
  region_cd = gw_pops_emd$region_cd,
  g1u14 = apply( gw_pops_emd[, 5:7], 1, sum ), 
  g2o15 = apply( gw_pops_emd[, 8:17], 1, sum ), 
  g3o65 = apply( gw_pops_emd[, 18:25], 1, sum ),
  total = apply( gw_pops_emd[, 5:24], 1, sum ) )

head( gw_pops_emd2 )

# 출장소가 들어간 코드는 앞의 읍면과 합하고 NA 처리
part <- which( str_detect(gw_pops_emd2$region, "출장소$") )

gw_pops_emd2[part-1,  3:6] <- gw_pops_emd2[part-1,  3:6] + gw_pops_emd2[part,  3:6]
gw_pops_emd2[part,  2] <- NA

gw_pops_emd2 %>%
  na.omit() %>% as_tibble() -> gw_pops_emd2

View( gw_pops_emd2 )


saveRDS(gw_pops_emd2, "./export/gw_pops_emd.rds")
