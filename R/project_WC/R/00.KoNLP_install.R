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
