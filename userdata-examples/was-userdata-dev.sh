#!/bin/bash

# UserData 스크립트 실행 권한 확인 및 설정
chmod +x "$0"

# 로그 파일 설정
LOG_FILE="/var/log/userdata.log"
exec > >(tee -a $LOG_FILE) 2>&1

echo "=========================================="
echo "UserData 스크립트 시작: $(date)"
echo "환경: DEV"
echo "=========================================="

# 환경 변수 설정 (Terraform 템플릿 변수에서 주입)
DOMAIN_NAME="${domain_name}"
EMAIL="${email}"

# 시스템 업데이트
echo "시스템 업데이트 시작..."
sudo apt update -y
sudo apt upgrade -y

# Java 21 설치
echo "Java 21 설치 중..."
sudo apt install -y openjdk-21-jdk

# MySQL 클라이언트 설치
sudo apt install -y mysql-client-core-8.0

# Docker 설치
echo "Docker 설치 중..."
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Docker Compose v2 설치
echo "Docker Compose v2 설치 중..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# Nginx 설치
echo "Nginx 설치 중..."
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Certbot 설치 (Let's Encrypt)
echo "Certbot 설치 중..."
sudo apt install -y certbot python3-certbot-nginx

# Nginx 기본 설정 파일 백업
echo "Nginx 설정 파일 백업 중..."
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Nginx 기본 설정 (sites-enabled 방식 사용)
echo "Nginx 기본 설정 생성 중..."
sudo tee /etc/nginx/nginx.conf > /dev/null << 'NGINXCONF'
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
}

http {
        sendfile on;
        tcp_nopush on;
        types_hash_max_size 2048;
        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        gzip on;

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;

        client_max_body_size 100M;
}
NGINXCONF

# sites-available 디렉토리 생성
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled

# HTTP 서버 설정 (Let's Encrypt 인증 및 리버스 프록시)
echo "Nginx HTTP 서버 설정 생성 중..."
sudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null << EOF
server {
        listen 80;
        server_name ${DOMAIN_NAME};

        # Let's Encrypt 인증을 위한 경로
        location /.well-known/acme-challenge/ {
                root /var/www/html;
        }

        # 리버스 프록시 설정
        location / {
                proxy_pass http://localhost:8080;
                proxy_http_version 1.1;
                proxy_set_header Connection "";
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto \$scheme;
        }
}
EOF

# sites-enabled에 심볼릭 링크 생성
sudo ln -sf /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/

# Nginx 설정 테스트 및 재시작
echo "Nginx 설정 테스트 중..."
sudo nginx -t
if [ $? -eq 0 ]; then
    sudo systemctl restart nginx
    echo "✅ Nginx 재시작 완료"
else
    echo "❌ Nginx 설정 테스트 실패"
    sudo cp /etc/nginx/nginx.conf.backup /etc/nginx/nginx.conf
    sudo systemctl restart nginx
fi

# Let's Encrypt 인증서 발급 스크립트 생성
echo "Let's Encrypt 인증서 발급 스크립트 생성 중..."
cat > /root/get-ssl-cert.sh << CERTSCRIPT
#!/bin/bash
DOMAIN_NAME="${DOMAIN_NAME}"
EMAIL="${EMAIL}"

echo "SSL 인증서 발급 시작: \${DOMAIN_NAME}"

# certbot이 nginx 설정을 자동으로 업데이트하도록 실행
# --nginx 플러그인은 자동으로 HTTPS 블록을 추가하고 HTTP를 HTTPS로 리다이렉트합니다
sudo certbot --nginx \
  -d \${DOMAIN_NAME} \
  --non-interactive \
  --agree-tos \
  --email \${EMAIL} \
  --redirect \
  --keep-until-expiring

# 인증서 자동 갱신 설정
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

echo "✅ SSL 인증서 발급 완료"
echo "✅ Nginx 설정이 자동으로 업데이트되었습니다"
CERTSCRIPT

chmod +x /root/get-ssl-cert.sh

# Swap 메모리 설정 (2GB)
echo "Swap 메모리 설정 중..."
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Redis 컨테이너 실행
echo "Redis 컨테이너 시작 중..."
sudo docker run -d \
  --name redis-container \
  --restart unless-stopped \
  -p 6379:6379 \
  redis:latest

# EC2 재시작 시 자동 설정을 위한 systemd 서비스 생성
cat > /etc/systemd/system/clokey-setup.service << 'EOF'
[Unit]
Description=Clokey Application Setup
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c '
  if ! swapon --show | grep -q /swapfile; then
    swapon /swapfile
  fi
  if ! docker ps --format "table {{.Names}}" | grep -q redis-container; then
    docker start redis-container 2>/dev/null || docker run -d --name redis-container --restart unless-stopped -p 6379:6379 redis:latest
  fi
'

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable clokey-setup.service

# 설치 완료 메시지
echo "=========================================="
echo "WAS 서버 초기 설정 완료!"
echo "환경: DEV"
echo "도메인: ${DOMAIN_NAME}"
echo "=========================================="
echo "SSL 인증서 발급 방법:"
echo "1. 도메인이 이 서버의 퍼블릭 IP를 가리키도록 설정"
echo "2. 다음 명령어 실행: sudo /root/get-ssl-cert.sh"
echo "=========================================="
echo "UserData 스크립트 완료: $(date)"
echo "로그 파일 위치: $LOG_FILE"
echo "=========================================="

