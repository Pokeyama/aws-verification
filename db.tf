# RDS
resource "aws_db_subnet_group" "private-db" {
  name       = "private-db"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
  tags       = {
    Name = "praivate-db"
  }
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "hirayama-db-parameter"
  family = "mariadb10.6"

  # データベースに設定するパラメーター
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_instance" "test-db" {
  identifier                = "hirayama-db"
  allocated_storage         = 20
  backup_retention_period   = 0
  storage_type              = "gp2"
  engine                    = "mariadb"
  engine_version            = "10.6.7"
  instance_class            = "db.t3.micro"
  username                  = "root"
  password                  = var.rds_password
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  db_subnet_group_name      = aws_db_subnet_group.private-db.name
  parameter_group_name      = aws_db_parameter_group.rds_parameter_group.name
  skip_final_snapshot       = false
  final_snapshot_identifier = "hirayama-db"

  tags = {
    Name = "hirayama-db"
  }
}