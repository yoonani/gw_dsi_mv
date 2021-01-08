library( tidyverse )

read_GW_ADM_5A_pops <- function( file ) {
  popData <- read_csv( file, locale = locale("ko", encoding = "euc-kr") )
  tmp <- as.data.frame( do.call( rbind, str_split(popData$행정구역, "\\(", n=2) ) )
  names(tmp) <- c("region", "region_cd")
  tmp$region <- trimws(tmp$region)
  tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")
  
  popData <- as_tibble( cbind( tmp, popData ) )
  
  popData %>%
    filter( region != "강원도") %>%
    select(-행정구역) %>%
    select( -ends_with("연령구간인구수") ) %>%
    select(1:2, contains("_계_")) -> popData
  
  years <- unique( substr( names(popData)[-c(1, 2)], 1, 4 ) )
  
  colNames <- c("region", "region_cd")
  
  for( i in 1:length(years) ) {
    colNames <- c(colNames, paste0("y", years[i], "_", c("g1u14", "g2o15", "g3o65", "total")))
  }
  
  returnData <- data.frame( 
    var01 = popData$region,
    var02 = popData$region_cd,
    var03 = apply( popData[, 4:6], 1, sum ), 
    var04 = apply( popData[, 7:16], 1, sum ), 
    var05 = apply( popData[, 17:24], 1, sum ),
    var06 = apply( popData[, 4:24], 1, sum ),
    var07 = apply( popData[, 26:28], 1, sum ), 
    var08 = apply( popData[, 29:38], 1, sum ), 
    var09 = apply( popData[, 39:46], 1, sum ),
    var10 = apply( popData[, 26:46], 1, sum ),
    var11 = apply( popData[, 48:50], 1, sum ), 
    var12 = apply( popData[, 51:60], 1, sum ), 
    var13 = apply( popData[, 61:68], 1, sum ),
    var14 = apply( popData[, 48:68], 1, sum )
  )
  
  names(returnData) <- colNames
  
  return( returnData )
}
    
read_GW_ADM_5A_pops("./data/gw_0810_5age.csv") %>%
  left_join( read_GW_ADM_5A_pops("./data/gw_1113_5age.csv"), by=c("region", "region_cd") ) %>%
  left_join( read_GW_ADM_5A_pops("./data/gw_1416_5age.csv"), by=c("region", "region_cd") ) %>%
  left_join( read_GW_ADM_5A_pops("./data/gw_1719_5age.csv"), by=c("region", "region_cd") ) -> gw_adm_5age_0819

saveRDS(gw_adm_5age_0819, "./data/gw_0819_5age_pops.rds")

gw_adm_5age_0819%>%
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

