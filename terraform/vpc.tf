resource "aws_vpc" "lootvault_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "lootvault-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lootvault_vpc.id

  tags = {
    Name = "lootvault-igw"
  }
}

resource "aws_subnet" "public_web_a" {
  vpc_id            = aws_vpc.lootvault_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-2a"

  tags = {
    Name = "lootvault-public-web-a"
  }
}

resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.lootvault_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "eu-central-2a"

  tags = {
    Name = "lootvault-private-db-a"
  }
}

resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.lootvault_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "eu-central-2b"

  tags = {
    Name = "lootvault-private-db-b"
  }
}
