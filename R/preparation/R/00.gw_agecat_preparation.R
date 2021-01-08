library( tidyverse )

gw0810 <- read_csv("./data/gw_0810_5age.csv", 
                locale = locale("ko", encoding = "euc-kr"))

# Step #2
tmp <- as.data.frame( do.call( rbind, str_split(gw0810$행정구역, "\\(", n=2) ) )

# Step #3
names(tmp) <- c("region", "region_cd")

# Step #4
tmp$region <- trimws(tmp$region)

# Step #5
tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")

# Step #6
gw0810 <- as_tibble( cbind( tmp, gw0810 ) )

# Step #7
gw0810 %>%
  filter( region != "강원도") %>%
  select(-행정구역) %>%
  select( -ends_with("연령구간인구수") ) %>%
  select(1:2, contains("_계_")) -> gw0810


names(gw0810) <- str_replace( names(gw0810), "_계", "")


gw1113 <- read_csv("./data/gw_1113_5age.csv", 
                   locale = locale("ko", encoding = "euc-kr"))

# Step #2
tmp <- as.data.frame( do.call( rbind, str_split(gw1113$행정구역, "\\(", n=2) ) )

# Step #3
names(tmp) <- c("region", "region_cd")

# Step #4
tmp$region <- trimws(tmp$region)

# Step #5
tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")

# Step #6
gw1113 <- as_tibble( cbind( tmp, gw1113 ) )

# Step #7
gw1113 %>%
  filter( region != "강원도") %>%
  select(-행정구역) %>%
  select( -ends_with("연령구간인구수") ) %>%
  select(1:2, contains("_계_")) -> gw1113


names(gw1113) <- str_replace( names(gw1113), "_계", "")


gw1416 <- read_csv("./data/gw_1416_5age.csv", 
                   locale = locale("ko", encoding = "euc-kr"))

# Step #2
tmp <- as.data.frame( do.call( rbind, str_split(gw1416$행정구역, "\\(", n=2) ) )

# Step #3
names(tmp) <- c("region", "region_cd")

# Step #4
tmp$region <- trimws(tmp$region)

# Step #5
tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")

# Step #6
gw1416 <- as_tibble( cbind( tmp, gw1416 ) )

# Step #7
gw1416 %>%
  filter( region != "강원도") %>%
  select(-행정구역) %>%
  select( -ends_with("연령구간인구수") ) %>%
  select(1:2, contains("_계_")) -> gw1416


names(gw1416) <- str_replace( names(gw1416), "_계", "")


gw1719 <- read_csv("./data/gw_1719_5age.csv", 
                   locale = locale("ko", encoding = "euc-kr"))

# Step #2
tmp <- as.data.frame( do.call( rbind, str_split(gw1719$행정구역, "\\(", n=2) ) )

# Step #3
names(tmp) <- c("region", "region_cd")

# Step #4
tmp$region <- trimws(tmp$region)

# Step #5
tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")

# Step #6
gw1719 <- as_tibble( cbind( tmp, gw1719 ) )

# Step #7
gw1719 %>%
  filter( region != "강원도") %>%
  select(-행정구역) %>%
  select( -ends_with("연령구간인구수") ) %>%
  select(1:2, contains("_계_")) -> gw1719


names(gw1719) <- str_replace( names(gw1719), "_계", "")


gw_0819_5age_pops <- data.frame( 
  region = gw1719$region,
  region_cd = gw1719$region_cd,
  y2008_g1u14 = apply( gw0810[, 4:6], 1, sum ), 
  y2008_g2o15 = apply( gw0810[, 7:16], 1, sum ), 
  y2008_g3o65 = apply( gw0810[, 17:24], 1, sum ),
  y2008_total = apply( gw0810[, 4:24], 1, sum ),
  y2009_g1u14 = apply( gw0810[, 26:28], 1, sum ), 
  y2009_g2o15 = apply( gw0810[, 29:38], 1, sum ), 
  y2009_g3o65 = apply( gw0810[, 39:46], 1, sum ),
  y2009_total = apply( gw0810[, 26:46], 1, sum ),
  y2010_g1u14 = apply( gw0810[, 48:50], 1, sum ), 
  y2010_g2o15 = apply( gw0810[, 51:60], 1, sum ), 
  y2010_g3o65 = apply( gw0810[, 61:68], 1, sum ),
  y2010_total = apply( gw0810[, 48:68], 1, sum ),
  y2011_g1u14 = apply( gw1113[, 4:6], 1, sum ), 
  y2011_g2o15 = apply( gw1113[, 7:16], 1, sum ), 
  y2011_g3o65 = apply( gw1113[, 17:24], 1, sum ),
  y2011_total = apply( gw1113[, 4:24], 1, sum ),
  y2012_g1u14 = apply( gw1113[, 26:28], 1, sum ), 
  y2012_g2o15 = apply( gw1113[, 29:38], 1, sum ), 
  y2012_g3o65 = apply( gw1113[, 39:46], 1, sum ),
  y2012_total = apply( gw1113[, 26:46], 1, sum ),
  y2013_g1u14 = apply( gw1113[, 48:50], 1, sum ), 
  y2013_g2o15 = apply( gw1113[, 51:60], 1, sum ), 
  y2013_g3o65 = apply( gw1113[, 61:68], 1, sum ),
  y2013_total = apply( gw1113[, 48:68], 1, sum ),
  y2014_g1u14 = apply( gw1416[, 4:6], 1, sum ), 
  y2014_g2o15 = apply( gw1416[, 7:16], 1, sum ), 
  y2014_g3o65 = apply( gw1416[, 17:24], 1, sum ),
  y2014_total = apply( gw1416[, 4:24], 1, sum ),
  y2015_g1u14 = apply( gw1416[, 26:28], 1, sum ), 
  y2015_g2o15 = apply( gw1416[, 29:38], 1, sum ), 
  y2015_g3o65 = apply( gw1416[, 39:46], 1, sum ),
  y2015_total = apply( gw1416[, 26:46], 1, sum ),
  y2016_g1u14 = apply( gw1416[, 48:50], 1, sum ), 
  y2016_g2o15 = apply( gw1416[, 51:60], 1, sum ), 
  y2016_g3o65 = apply( gw1416[, 61:68], 1, sum ),
  y2016_total = apply( gw1416[, 48:68], 1, sum ),
  y2017_g1u14 = apply( gw1719[, 4:6], 1, sum ), 
  y2017_g2o15 = apply( gw1719[, 7:16], 1, sum ), 
  y2017_g3o65 = apply( gw1719[, 17:24], 1, sum ),
  y2017_total = apply( gw1719[, 4:24], 1, sum ),
  y2018_g1u14 = apply( gw1719[, 26:28], 1, sum ), 
  y2018_g2o15 = apply( gw1719[, 29:38], 1, sum ), 
  y2018_g3o65 = apply( gw1719[, 39:46], 1, sum ),
  y2018_total = apply( gw1719[, 26:46], 1, sum ),
  y2019_g1u14 = apply( gw1719[, 48:50], 1, sum ), 
  y2019_g2o15 = apply( gw1719[, 51:60], 1, sum ), 
  y2019_g3o65 = apply( gw1719[, 61:68], 1, sum ),
  y2019_total = apply( gw1719[, 48:68], 1, sum )
)

saveRDS(gw_0819_5age_pops, "./data/gw_0819_5age_pops.rds")

gw_0819_5age_pops %>%
  pivot_longer(-(1:2), names_to="vars", values_to="pops") %>%
  separate(vars, c("year", "agecat")) %>%
  filter( agecat != "total") -> gw_0819_5age_pops_long


gw_0819_5age_pops_long %>%
  left_join( gw_0819_5age_pops_long %>%
                group_by(region, year) %>%
                summarise( 
                  agecat = agecat,
                  props = prop.table(pops) ) %>%
                ungroup() ) -> gw_0819_5age_pops_long


gw_0819_5age_pops_long$year <- as.integer( str_replace(gw_0819_5age_pops_long$year, "y", "") )

write.csv(gw_0819_5age_pops_long, "./data/gw0819agl.csv", row.names = FALSE)
