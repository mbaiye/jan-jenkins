resource "aws_eip" "eip_nat_gateway" {
    domain = "vpc"
  
  tags = {
    Name = "jenkins-instance-eip-nat-gateway"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_nat_gateway.id
  subnet_id = element(aws_subnet.public-subnets.*.id, 0)
  
  tags = {
    Name = "jenkins-instance-nat-gateway"
  }
  
}

resource "aws_route_table" "private_rt" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }

    tags = {
      Name = "jenkins-instance-private-rt"
    }
}

resource "aws_route_table_association" "private_rt_association" {
  count = var.private_subnets_count
  subnet_id = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
  
}