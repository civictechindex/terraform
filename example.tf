terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

/* Provisions ECR Registry */
resource "aws_ecr_repository" "ecr" {
  name = "cti-backend"
  tags = {
   name = "cti-backend" /* TODO: Variable out */
  }
}

output "repo-url" {
 value = aws_ecr_repository.ecr.repository_url
}

/* Provisions ECS Service */
resource "aws_ecs_cluster" "cluster" {
  name = "cti-backend-cluster"
  tags = {
   name = "cti-backend-cluster" /* TODO: Variable out */
   } 
}

/* Provisions EC2 Instance Free Tier */
resource "aws_instance" "ec2" {
  instance_type = "t2.micro"
  ami = "ami-0263bedf290898e74"
}

/* Provisions RDS Instance Free Tier */

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12"
  instance_class       = "db.t2.micro"
  name                 = "cti"
  username             = "postgres"
  password             = "password"
  parameter_group_name = "default.postgres12"
}