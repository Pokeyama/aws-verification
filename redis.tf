resource "aws_elasticache_subnet_group" "hirayama-redis-group" {
  name       = "hirayama-redis-group"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}

resource "aws_elasticache_replication_group" "hirayama-redis" {
  replication_group_id       = "hirayama-redis"
  description                = "hirayama redis"
  node_type                  = "cache.t3.micro"
  automatic_failover_enabled = true
  num_cache_clusters         = 2
  engine_version             = "6.x"
  subnet_group_name          = aws_elasticache_subnet_group.hirayama-redis-group.name
  port                       = 6379
  security_group_ids         = [aws_security_group.redis_sg.id]
  #  parameter_group_name          = "default.redis5.0"
  tags                       = {
    Name = "hirayama-redis"
  }
}