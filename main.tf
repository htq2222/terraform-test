#>>> HQ - missing terrform block specifying providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # define backend "s3" block for cloud state file storage or backend "remote" block for terraform cloud (exec and state management)
  # backend "s3" {
  #   bucket         = "your-tfstate-bucket"
  #   key            = "envs/test/terraform.tfstate"
  #   region         = "eu-west-2"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region  = var.region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Environment = var.environment
    Service     = var.service
    ManagedBy   = "terraform"
  }
}

module "networking" {
  source      = "./modules/networking"
  environment = var.environment
  region      = var.region
}

module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.networking.vpc_id
  environment = var.environment
}

module "alb" {
  source            = "./modules/alb"
  environment       = var.environment
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  domain_name       = var.domain_name
  route53_zone_id   = var.route53_zone_id
  vpc_id            = module.networking.vpc_id
}

module "ecs" {
  source            = "./modules/ecs"
  environment       = var.environment
  service           = var.service
  web_subnet_ids    = module.networking.web_subnet_ids
  ecs_sg_id         = module.security_groups.ecs_sg_id
  target_group_arn  = module.alb.target_group_arn
}

module "rds" {
  source             = "./modules/rds"
  environment       = var.environment
  db_subnet_ids      = module.networking.db_subnet_ids
  db_sg_id           = module.security_groups.db_sg_id
  db_username        = var.db_username
  db_password        = var.db_password
}
#<<< HQ
