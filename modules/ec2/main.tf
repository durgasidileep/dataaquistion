
locals {
  server_name          = "${var.prefix}-server"
  ebs_volume_type      = "gp3"
  data_ebs_device_name = "/dev/sdf"
}

#This will deploy new server to AWS with customized root(C drive) size 
resource "aws_instance" "ingestion-dev" {
    ami = var.imagename
    availability_zone = "us-east-1a"
    instance_type = var.instance_type
    key_name = "dataacquisition" 
    subnet_id = "${aws_subnet.subnet-private.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]	
    tags = {
        Name = "ingestion-dev"
        Env = "Dev"

 }
root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.ebs_root_size
}

ebs_block_device {
    device_name = var.ebs_volume_name
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
    encrypted = "true"
  }
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
	    environment = "${var.environment}"
    }
}

resource "aws_security_group" "allow_all" {
  name        = "${local.server_name}-sg"
  #name        = "dataacquisition-allow-custom-ports"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 3389 
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}


resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "subnet-private" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.private_subnet_name}"
    }
}

resource "aws_route_table" "terraform-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "${var.Main_routing_Table}"
    }
}

resource "aws_route_table_association" "terraform-private" {
    subnet_id = "${aws_subnet.subnet-private.id}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}


