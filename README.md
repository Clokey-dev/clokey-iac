# Clokey Infrastructure as Code (Terraform)

AWS 인프라를 Terraform으로 관리하는 Infrastructure as Code 프로젝트입니다. CI/CD 파이프라인이 구축되어 있어 GitHub Actions를 통해 자동화된 배포가 가능합니다.

## 🏗️ 프로젝트 구조

```
clokey-iac/
├── .github/
│   └── workflows/
│       ├── ci_dev.yml      # Dev 환경 CI
│       ├── ci_prod.yml     # Prod 환경 CI
│       ├── cd_dev.yml      # Dev 환경 CD
│       └── cd_prod.yml     # Prod 환경 CD
├── terraform/
│   ├── bootstrap/          # Bootstrap 모듈 (S3 백엔드 생성)
│   │   ├── terraform.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   ├── tf_state_bucket.tf
│   │   ├── outputs.tf
│   │   ├── terraform.tfvars
│   │   └── example.tfvars
│   ├── modules/            # 재사용 가능한 모듈들
│   │   ├── compute/ec2/
│   │   ├── database/rds/
│   │   ├── network/
│   │   ├── security/
│   │   └── storage/s3/
│   └── env/               # 환경별 설정
│       ├── dev/
│       └── prod/
└── README.md
```

## 🔧 구성 요소

### Bootstrap
- **S3 Bucket**: Terraform 상태 파일 저장
- **버전 관리**: 상태 파일 변경 이력 추적
- **암호화**: AES256 서버 사이드 암호화
- **보안**: 공개 액세스 차단

### Dev/Prod 환경
- **VPC**: 가상 프라이빗 클라우드
- **Subnets**: 퍼블릭/프라이빗 서브넷 (2개 AZ)
- **EC2**: 웹 애플리케이션 서버
- **RDS**: MySQL 데이터베이스
- **S3**: 파일 저장소
- **Route53**: DNS 관리 (EC2 Public IP 자동 연결)
- **Security Groups**: 방화벽 규칙

## 🚀 시작하기

### 1. 사전 준비

#### AWS 인증 설정
```bash
# AWS CLI 설정
aws configure
# AWS Access Key ID: [your-access-key]
# AWS Secret Access Key: [your-secret-key]
# Default region name: ap-northeast-2
# Default output format: json

# 또는 환경 변수 설정
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="ap-northeast-2"
```

### 2. Bootstrap 실행 (최초 1회)

```bash
cd terraform/bootstrap

# secret.tfvars 파일 생성
cat > secret.tfvars << EOF
access_key_id     = "YOUR_ACCESS_KEY_ID"
secret_access_key = "YOUR_SECRET_ACCESS_KEY"
EOF

# Bootstrap 실행
terraform init
terraform plan -var-file="terraform.tfvars" -var-file="secret.tfvars"
terraform apply -var-file="terraform.tfvars" -var-file="secret.tfvars"

# S3 버킷명 확인
terraform output state_bucket_name
```

### 3. 환경별 설정

#### Dev 환경 설정
```bash
cd terraform/env/dev

# terraform.tfvars 파일 편집
# - 실제 도메인 설정
# - RDS 사용자명 설정

# Dev 환경 실행
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

#### Prod 환경 설정
```bash
cd terraform/env/prod

# terraform.tfvars 파일 편집
# - 실제 도메인 설정
# - RDS 사용자명 설정

# Prod 환경 실행
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## 🔄 CI/CD 파이프라인

### GitHub Actions 설정

#### GitHub Secrets 설정
다음 값들을 GitHub 저장소의 Secrets에 설정하세요:

| Secret Name | Description |
|-------------|-------------|
| `DEV_AWS_ACCESS_KEY_ID` | Dev 환경 AWS Access Key |
| `DEV_AWS_SECRET_ACCESS_KEY` | Dev 환경 AWS Secret Key |
| `PROD_AWS_ACCESS_KEY_ID` | Prod 환경 AWS Access Key |
| `PROD_AWS_SECRET_ACCESS_KEY` | Prod 환경 AWS Secret Key |

#### 자동 배포
- **Dev 브랜치**: `main` 브랜치에 push 시 Dev 환경 자동 배포
- **Prod 환경**: GitHub Release 생성 시 Prod 환경 자동 배포

## 🔒 보안 고려사항

### 파일 보안
- `*.tfvars` 파일은 `.gitignore`에 포함되어 Git에 커밋되지 않습니다
- `example.tfvars` 파일만 Git에 커밋되어 템플릿으로 사용됩니다
- `*.secret.tfvars` 파일은 민감한 정보를 포함하며 Git에서 제외됩니다

### AWS 보안
- AWS 인증 정보는 GitHub Secrets로 관리
- 최소 권한 원칙 적용
- 정기적인 키 로테이션 권장

### Terraform 상태 관리
- S3 백엔드로 중앙화된 상태 관리
- 상태 파일 암호화
- 버전 관리로 이전 상태 복구 가능

## 📝 파일 설명

### Bootstrap
- `terraform.tf`: Terraform 버전 및 provider 요구사항
- `provider.tf`: AWS Provider 설정
- `variables.tf`: 입력 변수 정의
- `tf_state_bucket.tf`: S3 백엔드 버킷 생성
- `outputs.tf`: 출력 값 정의
- `terraform.tfvars`: 변수 값 (Git에서 제외)
- `example.tfvars`: 변수 템플릿 (Git에 포함)

### 환경별 설정
- `backend.tf`: S3 백엔드 설정
- `provider.tf`: AWS Provider 설정
- `locals.tf`: 공통 변수 정의
- `variables.tf`: 입력 변수 정의
- `data.tf`: 데이터 소스 정의
- `network.tf`: 네트워크 인프라
- `compute.tf`: 컴퓨팅 리소스
- `database.tf`: 데이터베이스 리소스
- `storage.tf`: 스토리지 리소스
- `outputs.tf`: 출력 값 정의
- `terraform.tfvars`: 환경별 변수 값 (Git에서 제외)
- `example.tfvars`: 변수 템플릿 (Git에 포함)

## 🛠️ 모듈 구조

### Compute
- **EC2**: 웹 서버 인스턴스
  - Amazon Linux 2023 AMI
  - t3.micro 인스턴스 타입
  - 퍼블릭 서브넷에 배치

### Database
- **RDS**: MySQL 데이터베이스
  - MySQL 8.0
  - 프라이빗 서브넷에 배치
  - AWS Secrets Manager로 비밀번호 관리

### Network
- **VPC**: 10.0.0.0/16 CIDR
- **Subnets**: 2개 AZ (ap-northeast-2a, ap-northeast-2c)
  - 퍼블릭 서브넷: 10.0.1.0/24, 10.0.2.0/24
  - 프라이빗 서브넷: 10.0.11.0/24, 10.0.12.0/24
- **Route53**: DNS 관리 및 A 레코드 자동 설정

### Security
- **Security Groups**: EC2, RDS, ALB용 보안 그룹
- **NACLs**: 서브넷 레벨 네트워크 제어

### Storage
- **S3**: 파일 저장소
  - 버전 관리 활성화
  - 암호화 설정
  - 공개 액세스 차단

## 🚨 주의사항

### 비용 관리
- 프로덕션 환경에 적용하기 전에 비용을 확인하세요
- 적절한 인스턴스 타입을 선택하세요
- 사용하지 않는 리소스는 정기적으로 정리하세요

### 보안
- 도메인 정보는 절대 GitHub에 커밋하지 마세요
- AWS 키는 정기적으로 로테이션하세요
- 프로덕션 환경에서는 더 강력한 보안 설정을 적용하세요

### 백업
- 정기적으로 Terraform 상태를 백업하세요
- 중요한 데이터는 별도로 백업하세요

## 📞 지원

문제가 발생하거나 질문이 있으시면 이슈를 생성해주세요.