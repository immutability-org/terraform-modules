
resource "aws_instance" "consul_node" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    count = "${var.consul_cluster_count}"
    subnet_id = "${var.subnet_ids[count.index % length(var.subnet_ids)]}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${aws_security_group.consul_node.id}"]

    connection {
        user          = "ubuntu"
        host          = "${self.private_ip}"
        private_key   = "${var.private_key}"
        agent         = "false"
        bastion_host  = "${var.bastion_host}"
        bastion_user  = "${var.bastion_user}"
    }

    #Instance tags
    tags {
      Name = "${var.tag_name}_${count.index}"
      Finance = "${var.tag_finance}"
      OwnerEmail = "${var.tag_owner_email}"
      Schedule = "${var.tag_schedule}"
      BusinessJustification = "${var.tag_business_justification}"
      AutoStart = "${var.tag_auto_start}"
    }

    provisioner "file" {
        source = "${path.module}/config/consul.service"
        destination = "/tmp/consul.service"
    }

    provisioner "file" {
        source = "${path.module}/config/nginx.conf"
        destination = "/tmp/nginx.conf"
    }

    provisioner "remote-exec" {
        scripts =
        [
            "${path.module}/scripts/install.sh"
        ]
    }
}


resource "aws_security_group" "consul_node" {
    name = "${var.tag_name}_security_group"
    description = "Consul internal traffic + maintenance."
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

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
