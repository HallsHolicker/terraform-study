resource "aws_security_group" "sg_t101" {
  vpc_id      = aws_vpc.vpc_t101.id
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
