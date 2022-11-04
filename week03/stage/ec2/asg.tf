resource "aws_launch_configuration" "lc_t101" {
  name_prefix                 = "t101-asg-"
  image_id                    = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  security_groups             = [aws_security_group.sg_t101.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              wget https://busybox.net/downloads/binaries/1.28.1-defconfig-multiarch/busybox-x86_64
              mv busybox-x86_64 busybox
              chmod +x busybox
              RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
              IID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
              LIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
              echo "<h1>HallsHolicker</h1> <h1>RegionAz($RZAZ) : Instance ID($IID) : Private IP($LIP) : Web Server</h1>" > index.html
              nohup ./busybox httpd -f -p 80 &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_alb_t101" {
  name                 = "asg-alb-t101"
  launch_configuration = aws_launch_configuration.lc_t101.name
  vpc_zone_identifier  = data.terraform_remote_state.vpc.outputs.vpc_subnmet_public.*.id
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  health_check_type    = "ELB"
  target_group_arns    = [data.terraform_remote_state.elb.outputs.elb_alb_target_arn]

  tag {
    key                 = "name"
    value               = "asg-alb-t101"
    propagate_at_launch = true
  }
}

### NLB ASG
resource "aws_autoscaling_group" "asg_nlb_t101" {
  name                 = "asg-nlb-t101"
  launch_configuration = aws_launch_configuration.lc_t101.name
  vpc_zone_identifier  = data.terraform_remote_state.vpc.outputs.vpc_subnmet_public.*.id
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  health_check_type    = "ELB"
  target_group_arns    = [data.terraform_remote_state.elb.outputs.elb_nlb_target_arn]

  tag {
    key                 = "name"
    value               = "asg-nlb-t101"
    propagate_at_launch = true
  }
}
