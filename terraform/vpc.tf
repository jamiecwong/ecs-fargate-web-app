

locals {
  cluster_name = "ecs-${random_id.name_suffix.hex}"

  tags = { env = var.env }
}

resource "random_id" "name_suffix" {
  byte_length = 2
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "vpc-${random_id.name_suffix.hex}"

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = true

  tags = {
    env = var.env
  }
}


