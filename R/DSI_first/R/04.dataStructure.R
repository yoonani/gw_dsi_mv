# 벡터
v1 <- c( 1, 3, -2, 4 )
v1
v2 <- 3:7
v2
v3 <- seq( -3, 3, by=0.1 )
v3
v4 <- rep( v1, times=2 )
v4
v4_2 <- rep( v1, each=2 )
v4_2
v5 <- c("a", "a", "b", "c")
v5
v6 <- c( v1, v2 )
v6
v7 <- c (v1, v5)
v7      # 벡터는 동일한 자료형을 갖는 자료의 모임


sort( v1 )
rev( v1 )
table( v5 )
class( table(v5) )
unique( v4 )


# matrix
v4
m1 <- matrix( v4, nrow=4 )
m1
m2 <- matrix( v4, nrow=4, byrow = TRUE )
m2    # 행부터 채우기

class( m2 )


## factor
gender <- c(1, 2, 2, 2, 1)
gender
gender.f <- factor(gender, levels=c(1, 2), labels=c("여성", "남성"))
gender.f

levels( gender.f )
class( gender.f )


# 데이터 프레임
df1 <- data.frame( col1 = v1, col2 = v5 )
df1
class( df1 )

dim( df1 )
nrow( df1 )
ncol( df1 )
names( df1 )

head( df1 )
head( df1, n=2 )
tail( df1, n=2 )
str( df1 )


# 합치기 : 이름이 있는 행렬 혹은 데이터 프레임
# 벡터끼리의 합치기는 행렬로, 데이터 프레임이 있을 시 데이터 프레임으로
# as.data.frame() 함수로 데이터프레임으로 변경가능
mat1 <- cbind( v1, v5 )
mat1
str( mat1 )
mat2 <- rbind( v1, v5 )
mat2
mat3 <- cbind( df1, v1 )
mat3
mat4 <- as.data.frame( mat1 )
mat4


# list
list1 <- list(v = v1, m = m1, df = df1)
list1
class( list1 )

save.image(file = "./data/02.RData")
