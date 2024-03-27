# Configure AWS provider
provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MyVPC"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"  # Adjust CIDR block as needed
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"  # Change to desired AZ
  tags = {
    Name = "PublicSubnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "MyIGW"
  }
}




# Create a route table for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_route_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
# Web Server Security Group (Allow HTTP on port 80)

resource "aws_security_group" "web_sg" {

name = "web_server_sg"

vpc_id = aws_vpc.my_vpc.id

ingress {

from_port = 80

to_port = 80

protocol = "tcp"

cidr_blocks = ["0.0.0.0/0"] # Allow from anywhere

}

egress {

from_port = 0

to_port = 0

protocol = "-1" # A11 protocols

cidr_blocks =["0.0.0.0/0"] # Allow to anywhere

}

}