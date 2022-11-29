# セキュリティグループ alb
resource "aws_security_group" "alb_sg" {
  name        = "hirayama-alb-sg"
  description = "hirayama alb sg"
  vpc_id      = aws_vpc.hirayama_vpc.id

  # anetからhttp許可
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ALBからhttpsの通信を許可
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 外に出ていくアクセス制限 アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# セキュリティグループ vpc内部
resource "aws_security_group" "vpc_all_sg" {
  name        = "hirayama-vpc-all"
  description = "hirayama vpc-all sg"
  vpc_id      = aws_vpc.hirayama_vpc.id

  # 全ポート開放
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [aws_vpc.hirayama_vpc.cidr_block]
  }

  # 外に出ていくアクセス制限 アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# セキュリティグループ ec2
resource "aws_security_group" "ec2_sg" {
  name        = "hirayama-ec2"
  description = "hirayama ec2 sg"
  vpc_id      = aws_vpc.hirayama_vpc.id

  # vpnからssh許可
  # 検証用なので全開放しておく
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    // 許可するIP
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 外に出ていくアクセス制限 アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# セキュリティグループ rds
resource "aws_security_group" "rds_sg" {
  name        = "hirayama-rds"
  description = "hirayama rds sg"
  vpc_id      = aws_vpc.hirayama_vpc.id

  # ec2に紐付いているものからのアクセス許可
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  # 外に出ていくアクセス制限 アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# セキュリティグループ redis
resource "aws_security_group" "redis_sg" {
  name        = "hirayama-redis"
  description = "hirayama redis sg"
  vpc_id      = aws_vpc.hirayama_vpc.id

  # ec2に紐付いているものからのアクセス許可
  ingress {
    #    from_port   = 6379
    #    to_port     = 6379
    #    protocol    = "tcp"
    #    security_groups = [aws_security_group.ec2_sg.id]
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 外に出ていくアクセス制限 アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}