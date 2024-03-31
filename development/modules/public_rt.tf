resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "jenkins-instance-igw"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "jenkins-instance-public-rt"
    }
}

resource "aws_route_table_association" "public_rt_association" {
  count = var.public_subnets_count
  subnet_id = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
  
}