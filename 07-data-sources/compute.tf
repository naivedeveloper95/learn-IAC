data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Owner is Canonical

}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "prod_vpc" {
  tags = {
    Env = "Prod"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "azs" {
  value = data.aws_availability_zones.available
}

output "prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "ubuntu_ami_data" {
  value = data.aws_ami.ubuntu.id
}

output "aws_caller_identity" {
  value = data.aws_caller_identity.current
}

output "aws_region" {
  value = data.aws_region.current
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t3.micro"

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
}
