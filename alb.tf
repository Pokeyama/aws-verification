# ALB
resource "aws_lb" "hirayama_alb" {
  load_balancer_type = "application"
  name               = "hirayama-alb"
  internal           = false

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = [aws_subnet.hirayama_public_1a.id, aws_subnet.hirayama_public_1b.id]

  tags = {
    Name = "hirayama-alb"
  }
}

# ALBにリスナーを設定
resource "aws_lb_listener" "hirayama_alb_listener" {
  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.hirayama_alb.arn

  # httpでアクセスしてきたらhttpsにリダイレクト
  default_action {
    #    type = "redirect"
    #    redirect {
    #      port        = "443"
    #      protocol    = "HTTPS"
    #      status_code = "HTTP_301"
    #    }
    type             = "forward"
    target_group_arn = aws_lb_target_group.hirayama_alb_target_group.arn
    # fixed_response {
    #   content_type = "text/plain"
    #   status_code  = "200"
    #   message_body = "test"
    # }
    # fixed_response {
    #   content_type = "text/plain"
    #   status_code  = "200"
    #   message_body = "test"
    # }  
  }
  tags = {
    Name = "hirayama-alb-listener"
  }
}

# ALBのリスナー（https）
resource "aws_alb_listener" "https_test" {
  load_balancer_arn = aws_lb.hirayama_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # 証明書をアタッチ
  certificate_arn   = aws_acm_certificate.hirayama_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hirayama_alb_target_group.arn
  }
}

# ALBターゲットグループ
resource "aws_lb_target_group" "hirayama_alb_target_group" {
  name             = "hirayama-lb-tg"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = aws_vpc.hirayama_vpc.id
  target_type      = "instance"

  health_check {
    path = "/"
  }
}

# ALBとEC2をつなげる 1c
resource "aws_lb_target_group_attachment" "hirayama_alb_a" {
  target_group_arn = aws_lb_target_group.hirayama_alb_target_group.arn
  target_id        = aws_instance.hirayama-ec2-c.id
  port             = 8080
}

# ALBとEC2をつなげる 1d
resource "aws_lb_target_group_attachment" "hirayama_alb_b" {
  target_group_arn = aws_lb_target_group.hirayama_alb_target_group.arn
  target_id        = aws_instance.hirayama-ec2-d.id
  port             = 8080
}