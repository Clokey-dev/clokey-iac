# Terraform Destroy Workflows

이 디렉토리는 AWS 인프라를 안전하게 삭제하기 위한 GitHub Actions 워크플로우를 포함합니다.

## 🚨 주의사항

- **이 워크플로우들은 되돌릴 수 없는 작업을 수행합니다**
- **Production 환경 삭제 전에는 반드시 데이터베이스 백업을 완료하세요**
- **실행 전에 모든 중요한 데이터가 백업되었는지 확인하세요**

## 📋 사용 가능한 워크플로우

### 1. Development 환경 삭제 (`destroy_dev.yml`)

**사용 시나리오:**
- 개발 환경에서 테스트 후 인프라 정리
- 개발 환경 재구성
- 개발 환경 비용 절약

**실행 방법:**
1. GitHub 저장소의 Actions 탭으로 이동
2. "Terraform Destroy Development Environment" 워크플로우 선택
3. "Run workflow" 버튼 클릭
4. 다음 정보 입력:
   - `confirm_destroy`: "DESTROY" 입력
   - `reason`: 삭제 이유 입력

### 2. Production 환경 삭제 (`destroy_prod.yml`)

**사용 시나리오:**
- 다른 AWS 계정으로 이관 시 기존 인프라 삭제
- Production 환경 재구성
- 서비스 종료

**실행 방법:**
1. GitHub 저장소의 Actions 탭으로 이동
2. "Terraform Destroy Production Environment" 워크플로우 선택
3. "Run workflow" 버튼 클릭
4. 다음 정보 입력:
   - `confirm_destroy`: "DESTROY_PRODUCTION" 입력
   - `reason`: 삭제 이유 입력 (필수)
   - `backup_required`: 백업 상태 선택

### 3. 전체 환경 삭제 (`destroy_all.yml`)

**사용 시나리오:**
- 모든 환경을 한 번에 삭제
- 프로젝트 완전 종료
- 전체 인프라 재구성

**실행 방법:**
1. GitHub 저장소의 Actions 탭으로 이동
2. "Terraform Destroy All Environments" 워크플로우 선택
3. "Run workflow" 버튼 클릭
4. 다음 정보 입력:
   - `confirm_destroy`: "DESTROY_ALL_ENVIRONMENTS" 입력
   - `reason`: 삭제 이유 입력 (필수)
   - `backup_required`: Production 백업 상태 선택
   - `environments`: 삭제할 환경 선택

## 🔒 보안 고려사항

### 필요한 GitHub Secrets

각 워크플로우는 다음 secrets가 설정되어 있어야 합니다:

**Development 환경:**
- `DEV_AWS_ACCESS_KEY_ID`
- `DEV_AWS_SECRET_ACCESS_KEY`
- `DEV_DOMAIN_NAME`
- `RDS_USERNAME`
- `RDS_PASSWORD`

**Production 환경:**
- `PROD_AWS_ACCESS_KEY_ID`
- `PROD_AWS_SECRET_ACCESS_KEY`
- `PROD_DOMAIN_NAME`
- `RDS_USERNAME`
- `RDS_PASSWORD`

### 권한 관리

- Production 환경 삭제는 관리자 권한이 있는 사용자만 실행해야 합니다
- 필요시 GitHub의 브랜치 보호 규칙을 활용하여 추가 승인 프로세스를 구현하세요

## 📝 실행 전 체크리스트

### Development 환경 삭제 전:
- [ ] 중요한 데이터가 Production에 백업되어 있는지 확인
- [ ] 개발 중인 코드가 저장소에 커밋되어 있는지 확인
- [ ] 다른 개발자들이 해당 환경을 사용하지 않는지 확인

### Production 환경 삭제 전:
- [ ] **데이터베이스 백업 완료** (필수)
- [ ] 사용자에게 서비스 중단 공지
- [ ] 도메인 DNS 설정 백업
- [ ] SSL 인증서 백업 (필요시)
- [ ] 모니터링 로그 백업 (필요시)
- [ ] 비즈니스 연속성 계획 수립

## 🛠️ 문제 해결

### 일반적인 오류:

1. **"Destroy 확인이 올바르지 않습니다"**
   - 정확한 확인 문자열을 입력했는지 확인
   - 대소문자 구분 주의

2. **"데이터베이스 백업이 완료되지 않았습니다"**
   - Production 환경 삭제 시 백업 상태를 올바르게 선택했는지 확인

3. **AWS 권한 오류**
   - GitHub Secrets의 AWS 자격 증명이 올바른지 확인
   - AWS IAM 사용자에게 필요한 권한이 있는지 확인

### 복구 방법:

일반적으로 destroy 작업은 되돌릴 수 없습니다. 복구가 필요한 경우:
1. 데이터베이스 백업에서 복원
2. Terraform 코드를 사용하여 인프라 재구성
3. DNS 설정 수동 복원

## 📞 지원

문제가 발생하거나 도움이 필요한 경우:
1. GitHub Issues에 문제 보고
2. 팀 채널에서 문의
3. 인프라 관리자에게 직접 연락

---

**⚠️ 마지막 경고: 이 워크플로우들은 프로덕션 환경에서 매우 신중하게 사용해야 합니다. 실행 전에 충분한 검토와 백업을 진행하세요.**


