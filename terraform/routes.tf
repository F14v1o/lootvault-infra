resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lootvault_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "lootvault-public-rt"
  }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_web_a.id
  route_table_id = aws_route_table.public_rt.id
}
