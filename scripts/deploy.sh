#!/bin/bash

# 작업 디렉토리를 /home/ubuntu로 변경
cd /home/ubuntu/app

# 환경변수 설정
DOCKER_APP_NAME="spring"

# 현재 실행 중인 "blue" 컨테이너 확인
EXIST_BLUE=$(sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml ps | grep Up)

# 배포 시작일자 기록
echo "배포 시작일자 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log

# "blue"가 실행 중이면 "green"으로 배포 시작
if [ -z "$EXIST_BLUE" ]; then
  echo "blue 배포 시작 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log

  # docker-compose.blue.yml 파일을 사용하여 "blue" 컨테이너 빌드 및 실행
  sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up -d --build

  # 30초 동안 대기
  sleep 30

  echo "green 중단 시작 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log

  # docker-compose.green.yml 파일을 사용하여 "green" 컨테이너 중지
  sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml down

  # 사용하지 않는 이미지 삭제
  sudo docker image prune -af

  echo "green 중단 완료 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log

# "blue"가 실행 중이면 "green"으로 배포 시작
else
  echo "green 배포 시작 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log

  # docker-compose.green.yml 파일을 사용하여 "green" 컨테이너 빌드 및 실행
  sudo docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml up -d --build

  sleep 30

  echo "blue 중단 시작 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log

  # docker-compose.blue.yml 파일을 사용하여 "blue" 컨테이너 중지
  sudo docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml down

  # 사용하지 않는 이미지 삭제
  sudo docker image prune -af

  echo "blue 중단 완료 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log
fi

echo "배포 종료 : $(date '+%Y-%m-%d %H:%M:%S')" >> /home/ubuntu/deploy.log
echo "===================== 배포 완료 =====================" >> /home/ubuntu/deploy.log
