# Create VPC

resource "aws_vpc" "vpc_creation_tf" {
cidr_block           = var.vpc_cidr
enable_dns_support   = true
enable_dns_hostnames = true

tags = {
Name = "vpc-creation-tf"
}
}

# Get all availability zones dynamically

data "aws_availability_zones" "available" {
state = "available"
}

# Create Public Subnets

resource "aws_subnet" "public_subnets" {
count                   = length(var.public_subnet_cidrs)
vpc_id                  = aws_vpc.vpc_creation_tf.id
cidr_block              = var.public_subnet_cidrs[count.index]
availability_zone       = data.aws_availability_zones.available.names[count.index]
map_public_ip_on_launch = true

tags = {
Name = "vpc-creation-tf-public-subnet-${count.index + 1}"
Type = "public"
}
}

# Create Private Subnets

resource "aws_subnet" "private_subnets" {
count             = length(var.private_subnet_cidrs)
vpc_id            = aws_vpc.vpc_creation_tf.id
cidr_block        = var.private_subnet_cidrs[count.index]
availability_zone = data.aws_availability_zones.available.names[count.index]

tags = {
Name = "vpc-creation-tf-private-subnet-${count.index + 1}"
Type = "private"
}
}

# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.vpc_creation_tf.id

tags = {
Name = "vpc-creation-tf-igw"
}
}

# Create Public Route Table

resource "aws_route_table" "public_rt" {
vpc_id = aws_vpc.vpc_creation_tf.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}

tags = {
Name = "vpc-creation-tf-public-rt"
}
}

# Associate Public Subnets with Public Route Table

resource "aws_route_table_association" "public_assoc" {
count          = length(aws_subnet.public_subnets)
subnet_id      = aws_subnet.public_subnets[count.index].id
route_table_id = aws_route_table.public_rt.id

depends_on = [
aws_route_table.public_rt,
aws_internet_gateway.igw
]
}
