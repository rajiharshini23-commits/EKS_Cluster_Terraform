locals {
  region = "us-east-1"
  name   = "raji_cluster"

  vpc_cidr = "10.123.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.123.1.0/24",
    "10.123.2.0/24"
  ]

  private_subnets = [
    "10.123.3.0/24",
    "10.123.4.0/24"
  ]

  intra_subnets = [
    "10.123.5.0/24",
    "10.123.6.0/24"
  ]

  tags = {
    Example = local.name
  }
}

provider "aws" {
  region = local.region
}

# --------------------------------------------------
# VPC
# --------------------------------------------------

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# --------------------------------------------------
# EKS Cluster
# --------------------------------------------------

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.name
  cluster_version = "1.34"

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  enable_irsa = true

  # Allow Jenkins to connect to the EKS API
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # EKS control-plane logging
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator"
  ]

  tags = local.tags
}
