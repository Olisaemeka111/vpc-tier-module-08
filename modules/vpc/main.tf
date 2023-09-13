# create vpc
resource "aws_vpc" "interview-vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default" #shared is default
    enable_dns_hostnames = true

    tags = {
      Name = "${var.project_name}-vpc"
    }
}

#create internet gateway and attach it to the vpc
resource "aws_internet_gateway" "igw-interview" {
    vpc_id = aws_vpc.interview-vpc.id

    tags = {
      Name = "${var.project_name}-igw"
    }
}

#use data source to get a list of all availability zones in prefered region
data "aws_availability_zones" "available_zones" {
  state = "available"
}

#create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
    vpc_id = aws_vpc.interview-vpc.id
    cidr_block = var.public_subnet_az1_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet_az1"
    }
}
    # az2 is indexed to the first zone by the zero.
    # create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
    vpc_id = aws_vpc.interview-vpc.id
    cidr_block = var.public_subnet_az2_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet_az2"
    }
}

# create route table and add a public route
resource "aws_route_table" "interview-rt" {
    vpc_id = aws_vpc.interview-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-interview.id
    }

    tags = {
    Name = "public-route-table"
    }
}

# associate public subnet az1 to the "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
    subnet_id = aws_subnet.public_subnet_az1.id
    route_table_id = aws_route_table.interview-rt.id
}

# associate public subnet az2 to the "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
    subnet_id = aws_subnet.public_subnet_az2.id
    route_table_id = aws_route_table.interview-rt.id
}
# create a private app subnet in az1
resource "aws_subnet" "private_app_subnet_az1"{
    vpc_id = aws_vpc.interview-vpc.id
    cidr_block = var.private_app_subnet_az1_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = false

    tags = {
        Name = "private_app_subnet_az1"
    }
}

# create a private app subnet in az2
resource "aws_subnet" "private_app_subnet_az2"{
    vpc_id = aws_vpc.interview-vpc.id
    cidr_block = var.private_app_subnet_az2_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = false

    tags = {
        Name = "private_app_subnet_az2"
    }
}

# create a private db subnet in az1
resource "aws_subnet" "private_db_subnet_az1"{
    vpc_id = aws_vpc.interview-vpc.id
    cidr_block = var.private_db_subnet_az1_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = false

    tags = {
        Name = "private_db_subnet_az1"
    }
}

# create a private db subnet in az2
resource "aws_subnet" "private_db_subnet_az2"{
    vpc_id = aws_vpc.interview-vpc.id
    cidr_block = var.private_db_subnet_az2_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = false

    tags = {
        Name = "private_db_subnet_az2"
    }
}
