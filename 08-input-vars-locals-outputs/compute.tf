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

resource "aws_instance" "compute" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_volume_config.config.size
    volume_type           = var.ec2_volume_config.config.type
  }

  tags = merge(var.additional_tags, {
    ManagedBy = "Terraform"
  })
}

# AMI ID - ap-south-1 - ami-0ff91eb5c6fe7cc86

provider "aws" {
  region = var.aws_region
}