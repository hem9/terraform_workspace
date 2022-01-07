#Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true #gives you an internal domain name
  enable_dns_hostnames = true #gives you an internal host name
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = "main-vpc"
  }

}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  state = "available"
}

#Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet" {
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  vpc_id                  = aws_vpc.vpc_master.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}