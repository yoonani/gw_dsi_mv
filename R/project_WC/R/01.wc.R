Sys.setenv(JAVA_HOME="C:/java/jdk-15.0.1")

library( KoNLP )
useNIADic()

# 필요한 패키지 설치
# install.packages( c("reshape2", "wordcloud2") )

# 패키지와 작업 공간 연결
library( tidyverse )
library( reshape2 )
library( wordcloud2 )



# 대통령기록관 연설문
# https://www.pa.go.kr/research/contents/speech/index.jsp
# 파일을 줄별로 읽어 벡터로 저장

# readr
spch <- read_lines("./data/ns_dj.txt")
class( spch )
head( spch, 2 )
tail( spch, 2 )


# 품사 구분하기 : KoNLP 사용
# https://github.com/haven-jeon/KoNLP/blob/master/etcs/KoNLP-API.md
SimplePos09( spch[1] )
SimplePos22( spch[1] )
class( SimplePos09(  spch[1]  ) )

SimplePos09(  spch[1] )$사랑하는
SimplePos09(  spch[1] )[[2]]

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