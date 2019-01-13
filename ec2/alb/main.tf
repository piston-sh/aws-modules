resource "aws_lb" "lb" {
  name               = "${var.name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.security_group.id}"]
  subnets            = ["${var.subnet_ids}"]
}

resource "aws_lb_target_group" "target" {
  name     = "${var.name}-target"
  port     = "${var.target_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path    = "${var.health_check_path}"
    matcher = "${var.health_check_matcher}"
  }
}

resource "aws_autoscaling_attachment" "nomad_asg_attachment" {
  autoscaling_group_name = "${var.target_asg_id}"
  alb_target_group_arn   = "${aws_lb_target_group.target.arn}"
}

resource "aws_lb_listener" "listener" {
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.acm_certificate_arn}"
  load_balancer_arn = "${aws_lb.lb.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target.arn}"
  }
}
