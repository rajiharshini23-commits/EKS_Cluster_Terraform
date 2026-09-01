module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.name
  cluster_version = "1.34"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  # Allow Jenkins to connect to the EKS API
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Cluster logging
  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  tags = local.tags
}
