terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
}

provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

resource "aws_s3_bucket" "us_east_1" {
  bucket   = "my-unique-bucket-name-learn-tf-2025-us-east-1"
  provider = aws.us-east
}

resource "aws_s3_bucket" "ap_south_1" {
  bucket = "my-unique-bucket-name-learn-tf-2025"
}