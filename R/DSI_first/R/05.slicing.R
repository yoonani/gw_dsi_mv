save.image(file = "./data/02.RData")

load(file = "./data/02.RData")


# 자료구조의 일부분 추출하기
# 위치값을 이용해서 가져오기
# vector (factor도 동일)
v3
v3[3]
v3[-3]
v3[1:3]
v3[c(1, 3, 4)]

# Matrix (2차원의 경우 Data frame도 동일)
m1
m1[1, ]
m1[, 1]
m1[2:3, 1:2]


# Data frame과 List : 하위 요소 이름으로 추출
df1$col1
list1$m

# 다음 두 결과물은 어떤 자료구조일까요?
list1[2]
list1[[2]]

class( list1[2] )
class( list1[[2]] )


# 조건을 만족하는 값 추출하기
v3 %% 2 == 0
v3[v3 %% 2 == 0]

which( v3 %% 2 == 0 )
v3[which( v3 %% 2 == 0 )]
