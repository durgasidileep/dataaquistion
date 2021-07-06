terraform {
  required_version = ">= 0.14.10" #Forcing which version of Terraform needs to be used
  required_providers{
    aws = {
      version = "~> 3.38.0" #Forcing which version of plugin needs to be used.
      source = "hashicorp/aws"
    }
  }
}
