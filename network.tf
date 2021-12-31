#Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "${terraform.workspace}-VPC"
    }
}

#Get all available AZ's in VPC
data "aws_availability_zones" "azs" {
    state = "available"
}

#Create subnet in us-east-1
resource "aws_subnet" "subnet" {
    aws_availability_zone = element(data.aws_availability_zones.azs.names,0)
    vpc_id = aws_vpc.vpc_master.id
    cidr_block = "10.0.1.0/24"

    tags = {
      Name = "${terraform.workspace}-subnet"  
    }
    
}

#Create SG for TCP/22 ssh from anywhere
resource "aws_security_group" "sg" {
    name = "${terraform.workspace}-sg"
    description = "Allow 22 port"
    vpc_id = aws_vpc.vpc_master.id
    dynamic "ingress" {
    for_each = var.rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
    egress {
      rom_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}