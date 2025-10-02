#!/bin/bash

# UserData 스크립트 실행 권한 확인 및 설정
chmod +x "$0"

# 로그 파일 설정
LOG_FILE="/var/log/userdata.log"
exec > >(tee -a $LOG_FILE) 2>&1

echo "=========================================="
echo "UserData 스크립트 시작: $(date)"
echo "현재 사용자: $(whoami)"
echo "현재 디렉토리: $(pwd)"
echo "환경 변수 PATH: $PATH"
echo "Nginx 설정 파일 경로: /etc/nginx/nginx.conf"
echo "Nginx 설정 파일 존재 여부: $(ls -la /etc/nginx/nginx.conf 2>/dev/null || echo '파일 없음')"
echo "=========================================="

# 시스템 업데이트
echo "시스템 업데이트 시작..."
sudo apt update -y
if [ $? -eq 0 ]; then
    echo "✅ 패키지 목록 업데이트 완료"
else
    echo "❌ 패키지 목록 업데이트 실패"
fi

sudo apt upgrade -y
if [ $? -eq 0 ]; then
    echo "✅ 시스템 업그레이드 완료"
else
    echo "❌ 시스템 업그레이드 실패"
fi

# Java 21 설치
echo "Java 21 설치 중..."
sudo apt install -y openjdk-21-jdk
if [ $? -eq 0 ]; then
    echo "✅ Java 21 설치 완료"
else
    echo "❌ Java 21 설치 실패"
fi

# Docker 설치
echo "Docker 설치 중..."
sudo apt install -y docker.io
if [ $? -eq 0 ]; then
    echo "✅ Docker 설치 완료"
else
    echo "❌ Docker 설치 실패"
fi

# Docker 서비스 시작 및 자동 시작 설정
echo "Docker 서비스 시작 중..."
sudo systemctl start docker
sudo systemctl enable docker
if [ $? -eq 0 ]; then
    echo "✅ Docker 서비스 시작 완료"
else
    echo "❌ Docker 서비스 시작 실패"
fi

# Docker Compose v2 설치
echo "Docker Compose v2 설치 중..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
if [ $? -eq 0 ]; then
    echo "✅ Docker Compose v2 설치 완료"
else
    echo "❌ Docker Compose v2 설치 실패"
fi

# Nginx 설치
echo "Nginx 설치 중..."
sudo apt install -y nginx
if [ $? -eq 0 ]; then
    echo "✅ Nginx 설치 완료"
else
    echo "❌ Nginx 설치 실패"
fi

# Nginx 서비스 시작 및 자동 시작 설정
echo "Nginx 서비스 시작 중..."
sudo systemctl start nginx
sudo systemctl enable nginx
if [ $? -eq 0 ]; then
    echo "✅ Nginx 서비스 시작 완료"
else
    echo "❌ Nginx 서비스 시작 실패"
fi

# Nginx 설정 파일 백업
echo "Nginx 설정 파일 백업 중..."
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
if [ $? -eq 0 ]; then
    echo "✅ Nginx 설정 파일 백업 완료"
else
    echo "❌ Nginx 설정 파일 백업 실패"
fi

# Nginx 설정 파일 생성
echo "Nginx 설정 파일 생성 중..."
sudo tee /etc/nginx/nginx.conf > /dev/null << 'EOF'
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
        # multi_accept on;
}

http {
        server {
                listen 80;
                server_name clokey.shop;
                location / {
                        proxy_pass http://localhost:8080;
                        proxy_http_version 1.1;
                        proxy_set_header Connection ""; 
                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                }
        }

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;

        ##
        # Gzip Settings
        ##

        gzip on;

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;

        client_max_body_size    100M;
}
EOF

if [ $? -eq 0 ]; then
    echo "✅ Nginx 설정 파일 생성 완료"
else
    echo "❌ Nginx 설정 파일 생성 실패"
fi

# Nginx 설정 테스트
echo "Nginx 설정 테스트 중..."
sudo nginx -t
if [ $? -eq 0 ]; then
    echo "✅ Nginx 설정 테스트 성공"
    # Nginx 재시작
    sudo systemctl restart nginx
    if [ $? -eq 0 ]; then
        echo "✅ Nginx 재시작 완료"
    else
        echo "❌ Nginx 재시작 실패"
    fi
else
    echo "❌ Nginx 설정 테스트 실패"
    # 백업 파일로 복원
    sudo cp /etc/nginx/nginx.conf.backup /etc/nginx/nginx.conf
    sudo systemctl restart nginx
fi

# Swap 메모리 설정 (2GB)
echo "Swap 메모리 설정 중..."
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
if [ $? -eq 0 ]; then
    echo "✅ Swap 메모리 설정 완료"
else
    echo "❌ Swap 메모리 설정 실패"
fi

# Swap 영구 설정
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Swap 설정 확인
echo "Swap 설정 완료:"
swapon --show

# Redis 컨테이너 실행
echo "Redis 컨테이너 시작 중..."
sudo docker run -d \
  --name redis-container \
  --restart unless-stopped \
  -p 6379:6379 \
  redis:latest

# Redis 컨테이너 상태 확인
echo "Redis 컨테이너 상태 확인 중..."
sleep 5
if sudo docker ps | grep -q redis-container; then
  echo "✅ Redis 컨테이너가 성공적으로 시작되었습니다."
else
  echo "❌ Redis 컨테이너 시작에 실패했습니다."
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
if [ $? -eq 0 ]; then
    echo "✅ 자동 재시작 서비스 활성화 완료"
else
    echo "❌ 자동 재시작 서비스 활성화 실패"
fi

# 설치 완료 메시지
echo "=========================================="
echo "WAS 서버 초기 설정 완료!"
echo "Java 버전: $(java -version 2>&1 | head -n 1)"
echo "Docker 버전: $(docker --version)"
echo "Docker Compose 버전: $(docker compose version)"
echo "Nginx 버전: $(nginx -v 2>&1)"
echo "Nginx 상태: $(systemctl is-active nginx)"
echo "Swap 메모리: $(swapon --show | grep /swapfile | awk '{print $3}')"
echo "Redis 컨테이너 상태: $(docker ps --filter name=redis-container --format 'table {{.Status}}')"
echo "자동 재시작 서비스: $(systemctl is-enabled clokey-setup.service)"
echo "=========================================="
echo "UserData 스크립트 완료: $(date)"
echo "로그 파일 위치: $LOG_FILE"
echo "=========================================="
