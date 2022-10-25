### NLB
resource "aws_lb" "nlb_t101" {
  name               = "nlb-t101"
  load_balancer_type = "network"
  internal           = false
  subnets            = aws_subnet.subnet_public.*.id
}

resource "aws_lb_target_group" "nlb_target" {
  name     = "nlb-tg-t101"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc_t101.id

  health_check {
    interval            = 10
    protocol            = "TCP"
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_lb_listener" "nlb_http" {
  load_balancer_arn = aws_lb.nlb_t101.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.nlb_target.id
    type             = "forward"
  }

}


### ALB
resource "aws_lb" "alb_t101" {
  name               = "alb-t101"
  load_balancer_type = "application"
  subnets            = aws_subnet.subnet_public.*.id
  security_groups    = [aws_security_group.sg_lb.id]

  tags = {
    Name = "alb_t101"
  }
}

resource "aws_lb_listener" "alb_http" {
  load_balancer_arn = aws_lb.alb_t101.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener" "alb_https" {
  load_balancer_arn = aws_lb.alb_t101.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_hallsholicker.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - T101 Study"
      status_code  = 404
    }
  }
}



resource "aws_lb_target_group" "alb_target" {
  name     = "tg-alb-t101"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_t101.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_lb_listener_rule" "alb_http_rule" {
  listener_arn = aws_lb_listener.alb_http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn
  }
}

resource "aws_lb_listener_rule" "alb_https_rule" {
  listener_arn = aws_lb_listener.alb_https.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target.arn
  }
}
