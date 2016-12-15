
resource "aws_elb" "load_balancer" {
    name                      = "${var.tag_name}-elb"
    cross_zone_load_balancing = true

    listener {
        instance_port      = "${var.instance_port}"
        instance_protocol  = "${var.instance_protocol}"
        lb_port            = 443
        lb_protocol        = "https"
        ssl_certificate_id = "${var.ssl_certificate_id}"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 5
        timeout = 10
        target = "${var.health_check_target}"
        interval = 30
    }

    security_groups = ["${aws_security_group.load_balancer.id}"]
    subnets = ["${var.subnet_ids}"]
    instances = ["${var.instance_ids}"]
    internal = "true"

    tags {
        Name = "${var.tag_name}_elb"
        Finance = "${var.tag_finance}"
        OwnerEmail = "${var.tag_owner_email}"
        Schedule = "${var.tag_schedule}"
        BusinessJustification = "${var.tag_business_justification}"
        AutoStart = "${var.tag_auto_start}"
    }
}

resource "aws_security_group" "load_balancer" {
    name = "${var.tag_name}_security_group"
    description = "load_balancer traffic"
    vpc_id = "${var.vpc_id}"

    tags {
        Name = "${var.tag_name}"
    }
    // These are for internal traffic

    ingress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
