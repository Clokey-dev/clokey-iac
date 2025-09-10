provider "aws" {
  region = local.aws_region

  # AWS 자격증명은 환경변수(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)에서 자동으로 가져옴

  default_tags {
    tags = local.common_tags
  }
}
