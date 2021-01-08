# 흐름제어

# 반복문

# for 
for ( i in 1:4 ) {
  j <- i + 10
  print( j )
}


# while
i <- 2
while ( i < 5 ) {
  print( i )
  i <- i + 1
}


# 조건문 : if
i

if ( i > 3 ) {
  print( 'yes' )
}

if ( i > 3 ) {
  print( 'yes' )
} else {
  print( 'no' )
}


if ( i < 3 ) {
  print( 'low' )
} else if( i < 9 ) {
  print( 'mid' )
} else {
  print( 'high' )
}


# 벡터를 전달받아 벡터 내 양수들의 합만 구하는 함수
posSum <- function( x ) {
  sum <- 0
  for( i in 1:length(x) ) {
    if( x[i] %% 2 == 0) {
      sum <- sum + 1
    }
  }
  return( sum )
}


posSum( c(-2, 3, 1, -2, 4) )

3 + posSum(c(-2, 3, 1, -2, 4))
