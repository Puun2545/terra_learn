terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
        }
    }
}

provider "aws" {
    access_key = ""
    secret_key = ""
    token = ""
    region = "us-west-2"
}

# DATA

data "aws_availability_zones" "available" {
    all_availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

