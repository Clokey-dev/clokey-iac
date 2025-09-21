#!/bin/bash

# 시스템 업데이트
echo "시스템 업데이트 시작..."
apt update -y
apt upgrade -y

# Java 21 설치
echo "Java 21 설치 중..."
apt install -y openjdk-21-jdk

# Docker 설치
echo "Docker 설치 중..."
apt install -y docker.io

# Docker 서비스 시작 및 자동 시작 설정
systemctl start docker
systemctl enable docker

# Docker Compose v2 설치
echo "Docker Compose v2 설치 중..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# Swap 메모리 설정 (2GB)
echo "Swap 메모리 설정 중..."
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Swap 영구 설정
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Swap 설정 확인
echo "Swap 설정 완료:"
swapon --show

# Redis 컨테이너 실행
echo "Redis 컨테이너 시작 중..."
docker run -d \
  --name redis-container \
  --restart unless-stopped \
  -p 6379:6379 \
  redis:latest

# Redis 컨테이너 상태 확인
echo "Redis 컨테이너 상태 확인 중..."
sleep 5
if docker ps | grep -q redis-container; then
  echo "Redis 컨테이너가 성공적으로 시작되었습니다."
else
  echo "Redis 컨테이너 시작에 실패했습니다."
fi

# EC2 재시작 시 자동 설정을 위한 systemd 서비스 생성
echo "자동 재시작 서비스 설정 중..."
cat > /etc/systemd/system/clokey-setup.service << 'EOF'
[Unit]
Description=Clokey Application Setup
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c '
  # Swap 활성화 (이미 설정되어 있으면 무시)
  if ! swapon --show | grep -q /swapfile; then
    swapon /swapfile
  fi
  
  # Redis 컨테이너 시작 (이미 실행 중이면 무시)
  if ! docker ps --format "table {{.Names}}" | grep -q redis-container; then
    docker start redis-container 2>/dev/null || docker run -d --name redis-container --restart unless-stopped -p 6379:6379 redis:latest
  fi
'

[Install]
WantedBy=multi-user.target
EOF

# 서비스 활성화
systemctl daemon-reload
systemctl enable clokey-setup.service

# 설치 완료 메시지
echo "=========================================="
echo "WAS 서버 초기 설정 완료!"
echo "Java 버전: $(java -version 2>&1 | head -n 1)"
echo "Docker 버전: $(docker --version)"
echo "Docker Compose 버전: $(docker compose version)"
echo "Swap 메모리: $(swapon --show | grep /swapfile | awk '{print $3}')"
echo "Redis 컨테이너 상태: $(docker ps --filter name=redis-container --format 'table {{.Status}}')"
echo "자동 재시작 서비스: $(systemctl is-enabled clokey-setup.service)"
echo "=========================================="
