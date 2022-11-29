# vpc
resource "aws_vpc" "hirayama_vpc" {
  cidr_block = "172.50.0.0/16"

  tags = {
    Name = "vpc-hirayama"
  }
}

# IGW
resource "aws_internet_gateway" "hirayama_vpc" {
  vpc_id = aws_vpc.hirayama_vpc.id

  tags = {
    Name = "hirayama-igw"
  }
}

# ルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.hirayama_vpc.id

  tags = {
    Name = "hirayama-route-table-public"
  }
}

# publicのRoute
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.hirayama_vpc.id
}