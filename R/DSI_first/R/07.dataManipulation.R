# install.packages( "tidyverse" )
library( tidyverse )

# data from https://www.kaggle.com/kimjihoo/coronavirusdataset
pInfo <- readRDS("./data/03.PI.rds")

class( pInfo )
head( pInfo, n=2 )

pInfo
as_tibble( pInfo )

pInfo <- as_tibble(pInfo)
class( pInfo )
typeof( pInfo$age )

### filter()
filter(pInfo, state == "released" )
filter(pInfo, province == "Daegu" )
filter(pInfo, province == "Daegu", state == "released" )
filter(pInfo, province == "Daegu" | state == "released" )



### select()
select(pInfo, patient_id, sex, age, country)
select(pInfo, ends_with("date"))
# starts_with(), contains() 등



### mutate()
View( mutate(pInfo, age2 = 2020 - birth_year ) )


### arrange()
arrange(pInfo, birth_year )
arrange(pInfo, desc(birth_year) )



### summarise() with group_by()
pInfo2 <- mutate(pInfo, age2 = 2020 - birth_year ) 
summarise(pInfo2,
          n = n(),
          mean.age = mean(age2, na.rm=TRUE)
)


pInfo2_grp <- group_by(pInfo2, sex)
summarise(pInfo2_grp,
          n = n(),
          mean.age = mean(age2, na.rm=TRUE)
)


# functions for grouped df
group_vars( pInfo2_grp )
group_rows( pInfo2_grp )
group_data( pInfo2_grp )
n_groups( pInfo2_grp )
ungroup( pInfo2_grp )


# %>% 연산자
pInfo %>%
  mutate( age2 = 2020 - birth_year ) %>%
  group_by(sex) %>%
  summarise(
    n = n(),
    mean.age = mean(age2, na.rm=TRUE)
  )

