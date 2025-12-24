terraform {
  backend "s3" {
    bucket         = "tf-bucket48"
    key            = "two-tier/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tf-locks"
    encrypt        = "true"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "terraform_remote_state" "core" {
	backend = "s3"
	config = {
		bucket = "tf-bucket48"
		key    = "core/${var.environment}/terraform.tfstate"
		region = var.aws_region
	}
}