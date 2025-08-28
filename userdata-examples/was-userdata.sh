#!/bin/bash

# 시스템 업데이트
echo "시스템 업데이트 시작..."
yum update -y

# Java 17 설치
echo "Java 17 설치 중..."
yum install -y java-17-amazon-corretto-devel

# Docker 설치
echo "Docker 설치 중..."
yum install -y docker

# Docker 서비스 시작 및 자동 시작 설정
systemctl start docker
systemctl enable docker

# Docker Compose v2 설치
echo "Docker Compose v2 설치 중..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# 설치 완료 메시지
echo "=========================================="
echo "WAS 서버 초기 설정 완료!"
echo "Java 버전: $(java -version 2>&1 | head -n 1)"
echo "Docker 버전: $(docker --version)"
echo "Docker Compose 버전: $(docker compose version)"
echo "=========================================="
