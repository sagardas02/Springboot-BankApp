resource "aws_key_pair" "terra-app-key" {
  key_name = "bank-app-terra-key"
  public_key = file("ec2-terra-app-key.pub")

    tags = {
    Name = "bank-app-terra-key"
  }
}


resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "bank-app-sg" {
    name        = "bank-app-sg"
    description = "This is the security group of bank app"
    vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "bank-app-sg"
  }
    ingress  {
        cidr_blocks = ["0.0.0.0/0"]
        to_port = 22
        from_port = 22
        protocol = "tcp"
        description = "allow 22 port number"
    }

    ingress  {
        cidr_blocks = ["0.0.0.0/0"]
        to_port = 80
        from_port = 80
        protocol = "tcp"
        description = "allow 80 port number"
    }

        ingress  {
        cidr_blocks = ["0.0.0.0/0"]
        to_port = 8080
        from_port = 8080
        protocol = "tcp"
        description = "allow 8080 port number"
    }

    ingress  {
        cidr_blocks = ["0.0.0.0/0"]
        to_port = 443
        from_port = 443
        protocol = "tcp"
        description = "allow 443 port number"
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        to_port = 0
        from_port = 0
        protocol = -1
        description = "allow all ports for outbound rules"
    }
}

data "aws_ami" "os_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*amd64*"]
  }

  owners = ["099720109477"] 
}


resource "aws_instance" "bank-app-ec2" {
  key_name = aws_key_pair.terra-app-key.key_name
  instance_type = var.instance_type
  ami = data.aws_ami.os_ami.id
  security_groups = [aws_security_group.bank-app-sg.name]
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }


  tags = {
    Name = "bank-app-ec2"
  }
}