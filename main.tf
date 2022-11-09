provider "aws" {
  region     = "ap-northeast-2"
  access_key = "엑세스키..!"
  secret_key = "시크릿 키입니다..!"
}

resource "aws_vpc" "dodo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Dodo"
  }
}

resource "aws_subnet" "dodo_subnet_1" {
  vpc_id     = aws_vpc.dodo_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "Name" = "Dodo-subnet"
  }
}
