provider "aws" {
  region     = "eu-west-1"
  access_key = "AKIA5HPA5JMVQXIP2I6A"
  secret_key = "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"
}

# terraform {
#   backend "s3" {
#     bucket = "terraform-backend-terraform"
#     key    = "terraform.tfstate"
#     region = "eu-west-1"
#     access_key = "AKIA5HPA5JMVQXIP2I6A"
#     secret_key = "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"
#   }
# }

module "ec2" {
  source = "../modules/ec2module"
  instancetype = "t2.nano"
  aws_common_tag = {
    Name = "ec2-dev-terraform"
  }
  sg_name = "dev-terraform-sg"
}
