# terraform

무지성 테라폼

## 사전준비

무지성 테라폼 설치

### 자 메모 드가자

일단 기본적으로 테라폼의 기본 확장자는 .tf

```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-2"                                         // 리전 변경(한국)
}

resource "aws_instance" "web" {
  ami           = "ami-0f2c95e9fe3f8f80e"                          // 이미지는 AWS에서 골라서 복사(Amazon Linux2)
  instance_type = "t2.micro"

  tags = {
    Name = "WebServerInstance"
  }
}
```

기본 WebServerInstance 를 생성하는 예제

## 메모

프로바이더를 셋팅할때 리전을 선택해야됨.
AWS에 리스트있음 ap-northeast-2 난이거선택

엑세스키랑 시크릿 키가 필요함
AWS에 IAM에 시크릿키 엑세스키 발급가능
