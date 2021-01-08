# install.packages("readxl")

library( tidyverse )
library( readxl )


gw0 <- read_csv("./data/gw_1820_5age_pops.csv")

Sys.getlocale()
default_locale()

gw1 <- read_csv("./data/gw_1820_5age_pops.csv", 
                locale = locale("ko", encoding = "euc-kr"))
gw1
names( gw1 )

gw2 <- read_excel("./data/gw_1820_5age_pops.xlsx", skip=3)
gw2


# Step #1
gw1$행정구역
str_split(gw1$행정구역, "\\(", n=2)

# Step #2
do.call( rbind, str_split(gw1$행정구역, "\\(", n=2) )
tmp <- as.data.frame( do.call( rbind, str_split(gw1$행정구역, "\\(", n=2) ) )

# Step #3 : 열 이름 변경
names(tmp) <- c("region", "region_cd")

# Step #4 :공백제거
tmp$region[1:5]
str_length( tmp$region )[1:5]
tmp$region <- trimws(tmp$region)
str_length( tmp$region )[1:5]

# Step #5 : 행정기관코드의 닫는 괄호 제거
tmp$region_cd[1:5]
tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")
tmp$region_cd[1:5]

# Step #6 : tibble로 변경
gw1
gw1 <- as_tibble( cbind( tmp, gw1 ) )

# Step #7 : 사용하지 않을 열 제거
gw1 %>%
  select(-행정구역) -> gw1

# 작업한 데이터를 R이 자료를 저장하는 방식인 rds로 저장
saveRDS(gw1, "./data/gw_pops.rds")



# 2017년부터 2019년의 5세 단위 인구 불러와 저장하기
# 자료의 구조만 동일하다면 위의 코드를 그대로 사용할 수 있음
gw1719 <- read_csv("./data/gw_1719_5age.csv", 
                   locale = locale("ko", encoding = "euc-kr"))

tmp <- as.data.frame( do.call( rbind, str_split(gw1719$행정구역, "\\(", n=2) ) )
names(tmp) <- c("region", "region_cd")
tmp$region <- trimws(tmp$region)
tmp$region_cd <- str_replace(tmp$region_cd, "\\)$", "")
gw1719 <- as_tibble( cbind( tmp, gw1719 ) )
gw1719 %>%
  select(-행정구역) -> gw1719
saveRDS(gw1719, "./data/gw_pops_1719.rds")
