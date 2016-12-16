

resource "aws_instance" "bastion" {
    ami           = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name      = "${var.key_name}"
    subnet_id     = "${var.subnet_id}"

    vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
    associate_public_ip_address = true

    tags {
        Name = "${var.tag_name}_${count.index}"
        Finance = "${var.tag_finance}"
        OwnerEmail = "${var.tag_owner_email}"
        Schedule = "${var.tag_schedule}"
        BusinessJustification = "${var.tag_business_justification}"
        AutoStart = "${var.tag_auto_start}"
    }
}

resource "aws_security_group" "bastion" {
    name        = "${var.tag_name}_security_group"
    vpc_id      = "${var.vpc_id}"
    description = "Bastion security group"

    tags {
        Name = "${var.tag_name}"
        Finance = "${var.tag_finance}"
        BusinessJustification = "${var.tag_business_justification}"
        OwnerEmail = "${var.tag_owner_email}"
    }

    ingress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    ingress {
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
