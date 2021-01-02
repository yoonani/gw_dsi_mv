# install.packages("readxl")

library( tidyverse )
library( readxl )

gw1 <- read.csv("./data/gw_2010_2020.csv", header = TRUE)
gw2 <- read_excel("./data/gw_2010_2020.xlsx")
