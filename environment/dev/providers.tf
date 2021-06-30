#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
    region = "${var.aws_region}"

default_tags { # requires aws provider >= 3.38.0
    tags = {
        "terraform"       = "true"
    }
    }
}

