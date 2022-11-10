provider "aws" {
  region     = "ap-northeast-2"
  access_key = "엑세스키"
  secret_key = "시크릿키"
}

# resource "aws_instance" "dodo_instance" {
#   ami           = "ami-07d16c043aa8e5153"
#   instance_type = "t2.micro"

# }

# resource "aws_vpc" "dodo_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     "Name" = "Dodo"
#   }
# }

# resource "aws_subnet" "dodo_subnet_1" {
#   vpc_id     = aws_vpc.dodo_vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     "Name" = "Dodo-subnet"
#   }
# }


resource "aws_vpc" "dodo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

resource "aws_internet_gateway" "dodo_gw" {
  vpc_id = aws_vpc.dodo_vpc.id
  tags = {
    "Name" = "production"
  }
}

resource "aws_route_table" "dodo_route_table" {
  vpc_id = aws_vpc.dodo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dodo_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dodo_gw.id
  }

  tags = {
    Name = "example"
  }
}


resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.dodo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    "Name" = "prod_subnet"
  }
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.dodo_route_table.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.dodo_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "web_server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web_server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [
    aws_internet_gateway.dodo_gw
  ]
}

resource "aws_instance" "web-server-instance" {
  ami               = "ami-07d16c043aa8e5153"
  instance_type     = "t2.micro"
  availability_zone = "ap-northeast-2a"
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_server-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo dodo id best web > /var/www/html/index.html'
              EOF
  tags = {
    "Name" = "web-server"
  }
}
