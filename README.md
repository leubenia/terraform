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

- - -

### Terraform AWS 공식문서 링크

<https://registry.terraform.io/providers/hashicorp/aws/latest/docs>

## 메모

프로바이더를 셋팅할때 리전을 선택해야됨.
AWS에 리스트있음 ap-northeast-2 난이거선택

엑세스키랑 시크릿 키가 필요함
AWS에 IAM에 시크릿키 엑세스키 발급가능

### 테라폼 명령어 Set

#### 테라폼 변경점 확인

```bash
terraform plan
```

테라폼 설정이 이상이 없는지 확인한다.
실재로 어떠한식으로 인프라가 변경되었는지도 확인 가능
But plan을 할때 실재로 적용하지 않고 테스트만 해서 AWS의 권한 문제 등으로 거절 되는것은 검증해주지 않음
- - -

#### 테라폼 실행

```bash
terraform apply
```

테라폼을 실행한다.
중요한점 인프라스트럭처 이므로 Terraform이 실패했다고 롤백해주지는 않는다.
성공한 부분까지는 적용 실패한 부분부터 다시 적용해야된다.
- - -

#### 테라폼 그래프

```bash
terraform graph
```

아직은 잘모르겠지만 설정한 리소스의 의존성 그래프를 확인이 가능하다.
GraphViz 형식으로 [GraphViz]:<https://dreampuf.github.io/GraphvizOnline> 를 보여주는곳으로 확인이 가능.

- - -

#### 테라폼 디스트로이

```bash
terraform destroy
```

말그대로 디스트로이 현재 계획되거나 테라폼으로 apply 되어있는 인프라를 다 제거한다
테라폼이 아닌 인프라는 삭제되지 않는다. -확인 필요

## .terraform 폴더

이폴더는 대충 생각하면 테라폼의 node module같은 존재인가 보다.

```bash
terraform init
```

해당 명령어로 테라폼을 진행한다.

## terraform.tfstate

AWS올리기전에 정의해주는것.
이 스테이터스 파일을 변경하면 오류가 생김 조심..!
