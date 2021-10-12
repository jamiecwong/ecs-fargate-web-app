terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

resource "random_id" "name_suffix" {
  byte_length = 2
}

locals {
  vpc_name = "vpc-${random_id.name_suffix.hex}"

  cluster_name = "ecs-${random_id.name_suffix.hex}"

  tags = { env = var.env }
}
