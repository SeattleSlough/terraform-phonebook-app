# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "main"
#   }
# }

# resource "aws_subnet" "public-1" {
#     vpc_id = aws_vpc.main.id
#     cidr_block = "10.0.10.0/24"

#     tags = {
#         Name = "public-subnet-1"
#     }
# }

# resource "aws_subnet" "private-1" {
#     vpc_id = aws_vpc.main.id

#     cidr_block = "10.0.20.0/24"
# }

# resource "aws_internet_gateway" "igw" {
#     vpc_id = aws_vpc.main.id
# }

#  resource "aws_nat_gateway" "ngw" {
#     subnet_id = aws_subnet.public-1.id

#  }

#  resource "" "name" {

#  }

#  resource "aws_eip" "alb" {

#  }

 