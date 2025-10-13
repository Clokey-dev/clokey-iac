# S3 Bucket Module

이 모듈은 AWS S3 버킷을 생성하고 보안 설정을 자동으로 구성합니다.

## 기능

- S3 버킷 생성
- 버전 관리 설정 (선택적)
- 서버 사이드 암호화 설정 (선택적)
- 공개 액세스 차단 설정 (선택적)
- 수명 주기 정책 설정 (선택적)
- 자동 태그 설정

## 사용법

### 기본 사용법

```hcl
module "s3_bucket" {
  source = "../../modules/storage/s3"

  bucket_name = "my-example-bucket"
  environment = "dev"
  purpose     = "backup"
}
```

### Terraform State 버킷 생성

```hcl
module "tf_state_bucket" {
  source = "../../modules/storage/s3"

  bucket_name = "my-terraform-state-bucket"
  environment = "prod"
  purpose     = "tfstate"

  # 보안 설정
  enable_versioning         = true
  enable_sse               = true
  sse_algorithm            = "AES256"
  enable_block_public_access = true
}
```

### 이미지 저장용 버킷 (수명 주기 정책 포함)

```hcl
module "image_bucket" {
  source = "../../modules/storage/s3"

  bucket_name = "my-image-bucket"
  environment = "prod"
  purpose     = "image"

  enable_versioning         = true
  enable_sse               = true
  enable_block_public_access = true
  enable_lifecycle_policy   = true

  lifecycle_rules = [
    {
      id     = "image-lifecycle"
      status = "Enabled"
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
      expiration = {
        days = 365
      }
    }
  ]
}
```

## 변수

| 변수명 | 설명 | 타입 | 기본값 | 필수 |
|--------|------|------|--------|------|
| bucket_name | S3 버킷 이름 | string | - | ✅ |
| environment | 환경명 (dev, prod) | string | - | ✅ |
| purpose | 용도 (tfstate, image, backup 등) | string | - | ✅ |
| tags | 추가 태그 | map(string) | {} | ❌ |
| enable_versioning | 버전 관리 활성화 | bool | false | ❌ |
| enable_sse | 서버 사이드 암호화 활성화 | bool | false | ❌ |
| sse_algorithm | 암호화 알고리즘 (AES256, aws:kms) | string | "AES256" | ❌ |
| enable_block_public_access | 공개 액세스 차단 | bool | true | ❌ |
| enable_lifecycle_policy | 수명 주기 정책 활성화 | bool | false | ❌ |
| lifecycle_rules | 수명 주기 정책 규칙 | list(object) | [] | ❌ |

## 출력값

| 출력값 | 설명 |
|--------|------|
| bucket_arn | 버킷 ARN |
| bucket_name | 버킷 이름 |
| bucket_id | 버킷 ID |
| bucket_domain_name | 버킷 도메인 이름 |
| bucket_regional_domain_name | 지역별 버킷 도메인 이름 |
| bucket_region | 버킷 지역 |

## 보안 고려사항

- 기본적으로 공개 액세스가 차단됩니다
- 서버 사이드 암호화를 활성화하는 것을 권장합니다
- Terraform state 버킷의 경우 반드시 버전 관리와 암호화를 활성화하세요
