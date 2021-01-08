# 앞의 예에서 저장한 자료들을 불러옵니다.
load(file = "./data/01.RData")


# 자료형 확인하기 : typeof( )
typeof( a )
typeof( str1 )


# 자료형 판별 함수들 : is.xxx()
# a에는 1이 저장되어 있습니다.
is.integer( a )
is.double( a )
is.numeric( a )

# c에는 4가 저장되어 있습니다.
is.integer( a:c )
is.double( a:c )
is.numeric( a:c )
typeof( a:c )

is.logical( a < c )

is.character( a )
is.character( str1 )


# 자료형 변환 함수 as.xxx( )
as.numeric( TRUE )
as.numeric( FALSE )

as.logical( 0 )
as.logical( 1 )

as.character( a )
as.character( TRUE )
