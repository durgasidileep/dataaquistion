variable "aws_region" {
  type = string
  default =  "us-east-1"
}

variable "prefix" {
  type = string
  default = "dev"
}

variable "root_volume_type" {
    type = string
    default = "gp2"
}

variable "ebs_root_size" {
    type = string
    default = "120"
}

variable "ebs_volume_name" {
    type = string
    default = "/dev/xvdc"
}

variable "ebs_volume_size" {
    type = string
    default = "1024"
}

variable "ebs_volume_type" {
    type = string
    default = "gp2"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-077f1edd46ddb3129"
    }
}
#variable "vpc_cidr" {}
variable "vpc_cidr" {
  type = string
  default =  "10.1.0.0/16"
}
#variable "vpc_name" {}
variable "vpc_name" {
  type = string
  default =  "vpc_dataacquisition"
}
#variable "IGW_name" {}
variable "IGW_name" {
  type = string
  default =  "igw_dataaquistion"
}
#variable "key_name" {}
variable "key_name" {
  type = string
  default = "dataaquistion"
}

#variable "imagename" {}
variable "imagename" {
   type = string
   default = "dev"
}
#variable "private_subnet_cidr" {}
variable "private_subnet_cidr" {
   type = string
   default = "10.1.20.0/24"
}

#variable "private_subnet_name" {}
variable "private_subnet_name" {
   type = string
   default ="dataaquistion_ps"
}
#variable Main_Routing_Table {}
variable "Main_routing_Table" {
    type = string 
    default = "dataaquistion_mr"
}
variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "environment" { default = "prod" }
variable "instance_type" {
  type = map
  default = {
     dev = "t2.micro"
    #prd = "c5.2xlarge" # This configuration is as per the Ingestion0 on premise server
    }
}
