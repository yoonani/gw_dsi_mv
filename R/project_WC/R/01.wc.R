# visit : https://jdk.java.net/15/
# 사전에 Java가 설치되어 있어야 합니다.

# Java 사용을 위한 설정
Sys.getenv("JAVA_HOME")
Sys.setenv(JAVA_HOME="C:/java/jdk-15.0.1")
Sys.getenv("JAVA_HOME")

# 사전에 필요한 패키지
# github에서 설치를 위한 devtools와 Java 환경을 구현하는 rJava 패키지
# install.packages( c("devtools", "rJava") )

library(rJava)
devtools::install_github('haven-jeon/KoNLP', INSTALL_opts = "--no-multiarch")

library( KoNLP )
useNIADic()

# 필요한 패키지 설치
# install.packages( c("reshape2", "wordcloud2") )

# 패키지와 작업 공간 연결
library( tidyverse )
library( reshape2 )
library( wordcloud2 )



# 대통령기록관 연설문 : https://www.pa.go.kr/research/contents/speech/index.jsp
# 파일을 줄별로 읽어 벡터로 저장

# readr
spch <- read_lines("./data/ns_dj.txt")
class( spch )
head( spch, 2 )
tail( spch, 2 )


# 품사 구분하기 : KoNLP 사용
# https://github.com/haven-jeon/KoNLP/blob/master/etcs/KoNLP-API.md
SimplePos09("동해물과 백두산이 마르고 닳도록")
SimplePos22("동해물과 백두산이 마르고 닳도록")
class( SimplePos09("동해물과 백두산이 마르고 닳도록") )

SimplePos09("동해물과 백두산이 마르고 닳도록")$백두산이
SimplePos09("동해물과 백두산이 마르고 닳도록")[[2]]

# 연설문 품사별로 구분하기
tmp <- SimplePos09( spch )
length( tmp )
class( tmp )
head( tmp, n=2 )

# 명사만 추출하기
spch_noun <- extractNoun( spch )

# reshape2 의 melt 는 list를 전달받으면 melt.list( )를 호출하고
# 결과로 데이터 프레임 구성
spch_noun %>% 
  melt() %>% 
  as_tibble() -> spch_noun_df
class( spch_noun_df )
spch_noun_df


# 각 단어별 사용 빈도수 출력
spch_noun_df %>%
  count(value, sort=TRUE)

# 글자수 구하기
spch_noun_df %>%
  count(value, sort=TRUE) %>% 
  mutate(length = str_length(value))

# 글자수 2개 이상만 사용하기
spch_noun_df %>%
  count( value, sort=TRUE ) %>% 
  filter( str_length(value) > 1 ) -> spch_noun_df_c2
spch_noun_df_c2

# 단어별 빈도 도표 만들기
library( ggthemes )
spch_noun_df_c2 %>%
  ggplot() +
    geom_bar( aes(x=value, y=n), stat="identity" ) + 
    theme_wsj() +
    coord_flip()


# 단어의 출현횟수 순으로 막대그래프 정렬하기 : reorder( ) 사용
spch_noun_df_c2 %>%
  ggplot() +
    geom_bar( aes(x=reorder(value, n), y=n), stat="identity" ) + 
    theme_wsj() +
    coord_flip()


# 워드클라우드 만들기
spch_noun_df_c2 %>%
  wordcloud2(size=0.5)


# 상위 15개 단어
spch_noun_df %>%
  count( value, sort=TRUE ) %>% 
  filter( str_length(value) > 1 ) %>%
  head( 15 ) -> spch_top_15