terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "5.37.0"
		}
	}
}

# Actively managed by us, by our terraform project
resource "aws_s3_bucket" "my_bucket" {
	bucket = "my-sample-bucket"
}

# Datasource, Managed somewhere else, we want to just use it in our project
data "aws_s3_bucket" "my_external_bucket" {
	bucket = "not-managed-by-us"
}

