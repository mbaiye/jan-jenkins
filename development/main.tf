variable "aws_region" {}
variable "cidr_block" {}
variable "availability_zones" {}
variable "public_subnets_count" {}
variable "private_subnets_count" {}


provider "aws" {
  region = var.aws_region
}

terraform {
    backend "s3" {
        bucket = "terraform-state-mobann-jenkins-live"
        key =   "mobann/development/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
}
}

resource "aws_vpc" "main-vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "jenkins-instance-main-vpc"
  }
}

module "subnet_module" {
  source = "./modules"
  vpc_id = aws_vpc.main-vpc.id
  vpc_cidr_block = aws_vpc.main-vpc.cidr_block
  availability_zones = var.availability_zones
  public_subnets_count = var.public_subnets_count
  private_subnets_count = var.private_subnets_count
  
}