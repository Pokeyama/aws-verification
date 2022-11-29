# subnet public1a
resource "aws_subnet" "hirayama_public_1a" {
  vpc_id = aws_vpc.hirayama_vpc.id

  availability_zone = "ap-northeast-1a"

  cidr_block = "172.50.15.0/24"

  tags = {
    Name = "hirayama-subnet-public-1a"
  }
}

# subnet public1b
resource "aws_subnet" "hirayama_public_1b" {
  vpc_id = aws_vpc.hirayama_vpc.id

  availability_zone = "ap-northeast-1c"

  cidr_block = "172.50.16.0/24"

  tags = {
    Name = "hirayama-subnet-public-1b"
  }
}

# subnet public1c
resource "aws_subnet" "hirayama_public_1c" {
  vpc_id = aws_vpc.hirayama_vpc.id

  availability_zone = "ap-northeast-1a"

  cidr_block = "172.50.17.0/24"

  tags = {
    Name = "hirayama-subnet-public-1c"
  }
}

# subnet public1d
resource "aws_subnet" "hirayama_public_1d" {
  vpc_id = aws_vpc.hirayama_vpc.id

  availability_zone = "ap-northeast-1c"

  cidr_block = "172.50.18.0/24"

  tags = {
    Name = "hirayama-subnet-public-1d"
  }
}

# subnet private1a
resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.hirayama_vpc.id

  availability_zone = "ap-northeast-1a"

  cidr_block = "172.50.32.0/24"

  tags = {
    Name = "hirayama-subnet-private-1a"
  }
}

# subnet private1b
resource "aws_subnet" "private_1b" {
  vpc_id = aws_vpc.hirayama_vpc.id

  availability_zone = "ap-northeast-1c"

  cidr_block = "172.50.33.0/24"

  tags = {
    Name = "hirayama-subnet-private-1b"
  }
}

# つなぐ
resource "aws_route_table_association" "hirayama_public_1a" {
  subnet_id      = aws_subnet.hirayama_public_1a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "hirayama_public_1b" {
  subnet_id      = aws_subnet.hirayama_public_1b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "hirayama_public_1c" {
  subnet_id      = aws_subnet.hirayama_public_1c.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "hirayama_public_1d" {
  subnet_id      = aws_subnet.hirayama_public_1d.id
  route_table_id = aws_route_table.public.id
}