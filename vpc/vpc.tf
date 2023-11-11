resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-vpc"
  })   
}
 # bc this tags is a variable as seen in var.tf, it can be change or overide in main.tf


resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet1_cidr
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public_subnet1"
  })     
}


resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet2_cidr
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public_subnet2"
  })
  
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet1_cidr
  availability_zone = var.availability_zones[0]
  
  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private_subnet1"
  })

}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet2_cidr
  availability_zone = var.availability_zones[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private_subnet2"
  })

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-gw"
  })

}

resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-RT"
  })
}

resource "aws_route_table_association" "public-subnet1-association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "public-subnet2-association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_eip" "eip" {
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip"
  }) 
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet1.id

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-NAT-gw"
  })

  depends_on = [ aws_eip.eip, aws_subnet.public_subnet1 ]
}
# To ensure proper oder of creation, its recommended to add an explicit dependency
# on the eip  and public_subnet1 for the Nat gw

resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  # bc you want resources in private subnet to downloads some patches from the internet
    gateway_id = aws_nat_gateway.NAT.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-RT"
  })

}

resource "aws_route_table_association" "private-subnet1-association" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private-RT.id
}

resource "aws_route_table_association" "private-subnet2-association" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private-RT.id
}
