resource "aws_vpc" "aviacore" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.project}-${var.env}-vpc"
  }

}

data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "aviacore-pub-sub1" {
  vpc_id                          = aws_vpc.aviacore.id
  cidr_block                      = var.public_subnet1
  map_public_ip_on_launch         = true
  availability_zone               = data.aws_availability_zones.available_zones.names[0]
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.aviacore.ipv6_cidr_block, 8, 1) 
  tags = {
    Name = "${var.project}-${var.env}-public-sub-1"
  }
}

resource "aws_subnet" "aviacore-pub-sub2" {
  vpc_id                          = aws_vpc.aviacore.id
  cidr_block                      = var.public_subnet2
  map_public_ip_on_launch         = true
  availability_zone               = data.aws_availability_zones.available_zones.names[1]
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.aviacore.ipv6_cidr_block, 8, 2)


  tags = {
    Name = "${var.project}-${var.env}-public-sub-2"
  }
}


resource "aws_subnet" "aviacore-priv-sub1" {
  vpc_id                          = aws_vpc.aviacore.id
  cidr_block                      = var.private_subnet
  availability_zone               = data.aws_availability_zones.available_zones.names[1]
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.aviacore.ipv6_cidr_block, 8, 3)


  tags = {
    Name = "${var.project}-${var.env}-private-sub-1"
  }
}


resource "aws_subnet" "aviacore-priv-sub2" {
  vpc_id                          = aws_vpc.aviacore.id
  cidr_block                      = var.private_subnet2
  availability_zone               = data.aws_availability_zones.available_zones.names[1]
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.aviacore.ipv6_cidr_block, 8, 4)


  tags = {
    Name = "${var.project}-${var.env}-private-sub-2"
  }
}



resource "aws_internet_gateway" "aviacore-igw" {
  vpc_id = aws_vpc.aviacore.id

  tags = {
    Name = "${var.project}-${var.env}-igw"
  }
}


resource "aws_route_table" "aviacore-rtb" {
  vpc_id = aws_vpc.aviacore.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aviacore-igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.aviacore-igw.id
  }

  tags = {
    Name = "${var.project}-${var.env}-pub-rtb"
  }

}

resource "aws_route_table_association" "aviacore_pub_sub1_assoc" {
  subnet_id      = aws_subnet.aviacore-pub-sub1.id
  route_table_id = aws_route_table.aviacore-rtb.id
}

resource "aws_route_table_association" "aviacore-pub_sub2_assoc" {
  subnet_id      = aws_subnet.aviacore-pub-sub2.id
  route_table_id = aws_route_table.aviacore-rtb.id
}


resource "aws_route_table" "aviacore-private-rtb" {
  vpc_id = aws_vpc.aviacore.id

  # No internet route to keep the subnets private
  tags = {
    Name = "${var.project}-${var.env}-private-rtb"
  }
}

# Associate Private Subnets with the Private Route Table
resource "aws_route_table_association" "aviacore_priv_sub1_assoc" {
  subnet_id      = aws_subnet.aviacore-priv-sub1.id
  route_table_id = aws_route_table.aviacore-private-rtb.id
}

resource "aws_route_table_association" "aviacore_priv_sub2_assoc" {
  subnet_id      = aws_subnet.aviacore-priv-sub2.id
  route_table_id = aws_route_table.aviacore-private-rtb.id
}