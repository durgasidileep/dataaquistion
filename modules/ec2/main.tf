locals {
  server_name          = "${var.prefix}-server"
  ebs_volume_type      = "gp3"
  data_ebs_device_name = "/dev/sdf"
}

#This will deploy new server to AWS with customized root(C drive) size 
resource "aws_instance" "ingestion-dev" {
    ami = var.imagename
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "chilakakey1" 
    subnet_id = "${aws_subnet.subnet-private.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]	
    tags = {
        Name = "ingestion-dev"
        Env = "Dev"

 }
root_block_device {
    volume_type = "gp2"
    volume_size = "120"
}

ebs_block_device {
    device_name = "/dev/xvdc"
    volume_size = 1024
    volume_type = "gp2"
    encrypted = "true"
  }
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
	    Owner = "Aravind"
	    environment = "${var.environment}"
    }
}

resource "aws_security_group" "allow_all" {
  name        = "Mercury-allow-custom-ports"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 3389 
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
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
