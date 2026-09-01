terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket       = "nvdevprojectbucket-2"
    key          = "eks-cluster/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}




