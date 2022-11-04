resource "aws_security_group" "sg_t101" {
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  name        = "T101 SG"
  description = "T101 Study SG"
}

resource "aws_security_group_rule" "sg_t101_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_t101.id
}

resource "aws_security_group_rule" "sg_t101_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_t101.id
}


resource "aws_security_group" "sg_lb" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  name   = "T101 Loadbalancer SG"
}

resource "aws_security_group_rule" "sg_rule_lb_inbound_80" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_lb.id
}

resource "aws_security_group_rule" "sg_rule_lb_inbound_443" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_lb.id
}

resource "aws_security_group_rule" "sg_rule_lb_outbound_all" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_lb.id

}
