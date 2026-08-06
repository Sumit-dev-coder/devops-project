terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg" {
  name        = "devops-project-sg"
  description = "Allow SSH and app traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "devops-project-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbdwmMpmpaHlugd+lHxNJkKXI88JoNcd8Ru5ImfumG4Gy7OHuNVsyoWJgPMiqcLjli/cZ9L0JqjQNqmeOo16JOEf7Hfn9ZD9TFm+7FzRaqIsjTQwCIuIVPz7M0xcFzL8fMRxe4hAD6AEnSHlzvySA20hnvWAmGDHKkA2mg1YYczNu2QT1dfVID1thOfw9x9Tgrc/95VJjDfJ57lGWj3fe+lYcmB8Y1rmSKt9t4+xtUawJHFjZm6orslAp9CX9Vcphk7oxTWqqEypgBQO3MA2Qtz1Y87Ze2Vf0SEAanlfiqZtDdQJY0dYoMpIyOQPzK/G3P4ZtR6UQSu6slLyqPitonQQl7y4H304EERiodU4zK85vM320yHnjOWXO6zKhgqqJ/breNNFNlaRH9AFVZyc7F9l6TdMjQq1+TUlYBxvsrft+dZT5K7ward/onAZCMEQJ16X2GcxzgAl86kU3F6r1FGKGRWB3bUCA0LI2uQJ6elakzdMizoFi82QS6kYQSaZeA7vg2wFQLFs2iHpsWX0pv9anNQ5hPLYcCjyG21E56cP1L+Mn6Id4S8W/kXfslOrOaHoc3Xo5zqNonP2CKACDckVuwPZHICPyy4RixI1eSr/bV0BMz+sCtOUeT7UDu8l0T5+4+keNT0tzWzoefTtoyo2Az6/HftUnygBZEbQPC/Q== sumit@LHEA01311"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "devops-project-server"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}