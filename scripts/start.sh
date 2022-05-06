#!/usr/bin/env bash
# start.sh
# 서버 구동을 위한 스크립트
ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ubuntu/SNSClone
IDLE_PORT=$(find_idle_port)
IDLE_PROFILE=$(find_idle_profile)
IMAGEPATH=/home/ubuntu/SNSClone


# shellcheck disable=SC1068

echo "> JASYPT_ENCRYPTOR_PASSWORD: ${JASYPT_ENCRYPTOR_PASSWORD}"
echo "> IDLE_PORT : $IDLE_PORT"
echo "> IDLE_PROFILE : $IDLE_PROFILE"

echo "> Build 파일 복사"
echo "> cp $REPOSITORY/zip/*.jar $REPOSITORY/"

cp $REPOSITORY/zip/*.jar $REPOSITORY

echo "> 새 어플리케이션 배포"
JAR_NAME=$(ls -S $REPOSITORY/*.jar | head -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> $JAR_NAME 에 실행권한 추가"

sudo chmod +x $JAR_NAME

echo "> $JAR_NAME 실행"

echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."

cd /home/ubuntu/SNSClone


sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8081

sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8082

nohup java -jar -Dspring.profiles.active=$IDLE_PROFILE sdd-0.0.1-SNAPSHOT.jar > nohup.out 2>&1 &