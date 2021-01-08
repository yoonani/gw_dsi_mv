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


# 명사추출하기 : 에러 발생
news_read %>%
  extractNoun() %>%
  melt() %>%
  as_tibble() -> news_df

# 본문 중 알 수 없는 글자로 인해 발생
# 해당 기사는 제거
news_read[str_detect(news_read, "제15회 지속가능발전 강원대회본사, 도 춘천시지속가능발전협 주최구체적 실행방안 논의")] <- NA
news_read[str_detect(news_read, "양양 양양군의회는 25일 제252회 정례회를 속개하고 문화체육과,도시계획과,대외정책과,산림녹지과를 상대로 3일차 행정사무감사를 실시했다")] <- NA
news_read[str_detect(news_read, "이종석 부의장은 “사이클 선수로 활동하는 학생은 물론 학부모,코치 등이 주소까지 옮겨오고 있는데 이럴 때 일수록 부족한 부분을 꼼꼼하게 챙겨봐야 한다”라고 조언했다.")] <- NA
news_read[str_detect(news_read, "김택철 의원은 “지역주민들의 문화향유를 위해")] <- NA

news_read %>%
  extractNoun() %>%
  melt() %>%
  as_tibble() -> news_df

news_df

# 글자수 2개 이상의 단어의 출현 횟수 구하기
news_df %>%
  filter(str_length(value) > 1) %>% 
  count(value, sort=TRUE) %>% View()

# 불필요 명사 제거
news_read <- str_replace_all(news_read, "강원도", " ")
news_read <- str_replace_all(news_read, "강원도민일보", " ")
news_read <- str_replace_all(news_read, "강원일보", " ")
news_read <- str_replace_all(news_read, "강원", " ")
news_read <- str_replace_all(news_read, "도내", " ")
news_read <- str_replace_all(news_read, "기자", " ")
news_read <- str_replace_all(news_read, "년생", " ")
news_read <- str_replace_all(news_read, "내년", " ")
news_read <- str_replace_all(news_read, "가운데", " ")
news_read <- str_replace_all(news_read, "들이", " ")
news_read <- str_replace_all(news_read, "[0-9]", " ")

news_read <- str_replace_all(news_read, "(강원도민일보|강원일보|강원도|강원|도내|기자|년생|내년|가운데|들이|[0-9])", " ")

# 재실행
news_read %>%
  extractNoun() %>%
  melt() %>%
  as_tibble() -> news_df

# 많이 나오는 단어 확인
news_df %>%
  filter(str_length(value) > 1) %>% 
  count(value, sort=TRUE) %>% View()

# 단어구름 만들기
news_df %>%
  filter(str_length(value) > 1) %>% 
  count(value, sort=TRUE) %>%
  wordcloud2(size=0.5)