# bigkinds
# 문제 // 강원일보, 강원도민일보
Sys.setenv(JAVA_HOME="C:/java/jdk-15.0.1")

# 패키지 연결
library( KoNLP )
library( tidyverse )
library( reshape2 )
library( wordcloud2 )
library( readxl )

# 사용할 사전 활성화
useNIADic()


news <- read_excel("./data/news_ex.xlsx")
str( news )
names( news )

news_read <- news$본문 

# 한글과 띄어쓰기 외 문자 제거하기
news_read[1]
str_replace_all(news_read[1], "[:punct:]", " " )
str_replace_all(news_read[1], "[^가-힣 ]+", "" )


# 분석 변수로 저장
news_wk <- str_replace_all(news_read, "[:punct:]", " " )
news_wk <- str_replace_all(news_wk, "[^가-힣 ]+", "" )
head( news_wk, 3 )

# 명사 추출하기
news_wk %>%
  extractNoun() %>%
  melt() %>%
  as_tibble() -> news_df

View( news_df )

# 글자수 2개 이상의 단어의 출현 횟수 구하기
news_df %>%
  filter(str_length(value) > 1) %>% 
  count(value, sort=TRUE) %>% View()

# 불필요 명사 제거
news_wk <- str_replace_all(news_wk, "강원도", " ")
news_wk <- str_replace_all(news_wk, "강원도민일보", " ")
news_wk <- str_replace_all(news_wk, "강원일보", " ")
news_wk <- str_replace_all(news_wk, "강원", " ")
news_wk <- str_replace_all(news_wk, "도내", " ")
news_wk <- str_replace_all(news_wk, "기자", " ")
news_wk <- str_replace_all(news_wk, "년생", " ")
news_wk <- str_replace_all(news_wk, "내년", " ")
news_wk <- str_replace_all(news_wk, "가운데", " ")
news_wk <- str_replace_all(news_wk, "들이", " ")
news_wk <- str_replace_all(news_wk, "일보", " ")
news_wk <- str_replace_all(news_wk, "올해", " ")

news_wk <- str_replace_all(news_wk, "(강원도민일보|강원일보|강원도|강원|도내|기자|년생|내년|가운데|들이|일보|올해)", " ")

# 재실행
news_wk %>%
  extractNoun() %>%
  melt() %>%
  as_tibble() -> news_df

# 많이 나오는 단어 확인
news_df %>%
  filter(str_length(value) > 1) %>% 
  count(value, sort=TRUE) %>% View()

# 단어구름 만들기 : 많이 나타난 상위 300개 단어 대상
news_df %>%
  filter(str_length(value) > 1) %>% 
  count(value, sort=TRUE) %>%
  head(300) %>%
  wordcloud2(size=0.5)