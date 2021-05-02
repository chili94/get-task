provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/21"
}

resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "app-iwg"
  }
}

resource "aws_subnet" "app-public-a" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "app-public-b" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "subnet-b"
  }
}


resource "aws_route_table" "app-route-table" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }


  tags = {
    Name = "app-route-table"
  }
}

resource "aws_route_table_association" "app-rta-a" {
  subnet_id      = aws_subnet.app-public-a.id
  route_table_id = aws_route_table.app-route-table.id
}

resource "aws_route_table_association" "app-rta-b" {
  subnet_id      = aws_subnet.app-public-b.id
  route_table_id = aws_route_table.app-route-table.id
}

resource "aws_security_group" "app-sg" {
  name        = "default-sg"
  description = "Allow inbound http ssh"
  vpc_id      = aws_vpc.app-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.localip]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

resource "aws_network_interface" "app-eni" {
  subnet_id = aws_subnet.app-public-a.id
  security_groups = [aws_security_group.app-sg.id]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_key_pair" "app-key" {
  key_name   = "app-key"
  public_key = file(var.app-key-pub)
}

resource "aws_instance" "app-web" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"
  network_interface {
    network_interface_id = aws_network_interface.app-eni.id
    device_index         = 0
  }
  key_name  = aws_key_pair.app-key.id
  user_data = file("install_httpd.sh")
  tags = {
    Name        = "test-ec2"
    Description = "Test instance"
    CostCenter  = "123456"
  }
}






















