# Create vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }

}

# Create Public Subnet 1
resource "aws_subnet" "Public_subnet_1a" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.0.0/20"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
    Name = "${var.project_name}-Public_subnet_1a"
  }
  
}

# Create Public Subnet 2
resource "aws_subnet" "Public_subnet_1b" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.16.0/20"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
    Name = "${var.project_name}-Public_subnet_1b"
  }
  
}

# Create Public Subnet 3
resource "aws_subnet" "Public_subnet_1c" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.32.0/20"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true

    tags = {
    Name = "${var.project_name}-Public_subnet_1c"
  }
  
}

# create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
    vpc_id = aws_vpc.vpc.id 

    tags = {
    Name = "${var.project_name}-internet-gateway"
  } 
}

# Public route table
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gateway.id   
    }

    tags = {
    Name = "${var.project_name}-public_route_table"
  } 
}

# Association of public subnet_1a to the public route table
resource "aws_route_table_association" "Public_subnet_1a_public_route_table_association" {
    route_table_id = aws_route_table.public_route_table.id 
    subnet_id = aws_subnet.Public_subnet_1a.id 
}

# Association of public subnet_1b to the public route table
resource "aws_route_table_association" "Public_subnet_1b_public_route_table_association" {
    route_table_id = aws_route_table.public_route_table.id 
    subnet_id = aws_subnet.Public_subnet_1b.id  
}

# Association of public subnet_1a to the public route table
resource "aws_route_table_association" "Public_subnet_1c_public_route_table_association" {
    route_table_id = aws_route_table.public_route_table.id 
    subnet_id = aws_subnet.Public_subnet_1c.id  
}

# Create Private subnets
# Create Private subnet 1a
resource "aws_subnet" "Private_subnet_1a" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.128.0/20"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false

    tags = {
    Name = "${var.project_name}-Private_subnet_1a"
  }
  
}

# Create Private subnet 1b
resource "aws_subnet" "Private_subnet_1b" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.144.0/20"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false

    tags = {
    Name = "${var.project_name}-Private_subnet_1b"
  }
  
}

# Create Private subnet 1c
resource "aws_subnet" "Private_subnet_1c" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.160.0/20"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = false

    tags = {
    Name = "${var.project_name}-Private_subnet_1c"
  }
  
}

# create elasitc_ip
resource "aws_eip" "eip" {
    domain = "vpc" 
}

# Create nat-gateway
resource "aws_nat_gateway" "nat-gateway" {
    allocation_id = aws_eip.eip.id 
    subnet_id = aws_subnet.Public_subnet_1a.id 

    tags = {
    Name = "${var.project_name}-nat-gateway"
  }
  
}

# Private routable for AZ1a
resource "aws_route_table" "Private_routable_az1a" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gateway.id 
         
    }

    tags = {
    Name = "${var.project_name}-Private_routable_az1a"
  }
  
}

# Private routable for AZ1b
resource "aws_route_table" "Private_routable_az1b" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gateway.id 
    }

    tags = {
    Name = "${var.project_name}-Private_routable_az1b"
  }
  
}

# Private routable for AZ1c
resource "aws_route_table" "Private_routable_az1c" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gateway.id 
    }

    tags = {
    Name = "${var.project_name}-Private_routable_az1c"
  }
  
}

# create private route table assocition for az1a
resource "aws_route_table_association" "private_route_table_association_az1a" {
    route_table_id = aws_route_table.Private_routable_az1a.id 
    subnet_id = aws_subnet.Private_subnet_1a.id 
}

# create private route table assocition for az1b
resource "aws_route_table_association" "private_route_table_association_az1b" {
    route_table_id = aws_route_table.Private_routable_az1b.id 
    subnet_id = aws_subnet.Private_subnet_1b.id 
}

# create private route table assocition for az1c
resource "aws_route_table_association" "private_route_table_association_az1c" {
    route_table_id = aws_route_table.Private_routable_az1c.id  
    subnet_id = aws_subnet.Private_subnet_1c.id 
}

