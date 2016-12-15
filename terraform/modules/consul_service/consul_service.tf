
data "template_file" "template_consul_client_config" {
    template = "${file("${path.module}/config/client_consul_config.tpl")}"
    vars {
        retry_join = "${join("\",\"", var.consul_cluster_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

data "template_file" "template_install_rest_service" {
    template = "${file("${path.module}/scripts/install_rest_service.sh")}"
    vars {
        rest_service_url = "${var.rest_service_url}"
    }
}


resource "aws_instance" "consul_service"
{
    ami = "${var.ami}"
    count = "${var.service_count}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_ids[count.index % length(var.subnet_ids)]}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${aws_security_group.consul_service.id}"]

    connection
    {
        user          = "ubuntu"
        host          = "${self.private_ip}"
        private_key   = "${var.private_key}"
        agent         = "false"
        bastion_host  = "${var.bastion_host}"
        bastion_user  = "${var.bastion_user}"
    }

    tags
    {
        Name = "${var.tag_name}-${count.index}"
        Finance = "${var.tag_finance}"
        OwnerEmail = "${var.tag_owner_email}"
        Schedule = "${var.tag_schedule}"
        BusinessJustification = "${var.tag_business_justification}"
        AutoStart = "${var.tag_auto_start}"
    }

    provisioner "file" {
        content = "${data.template_file.template_consul_client_config.rendered}"
        destination = "/tmp/consul.json"
    }

    provisioner "file" {
        content = "${data.template_file.template_install_rest_service.rendered}"
        destination = "/tmp/install_rest_service.sh"
    }

    provisioner "file" {
        source = "${path.module}/config/clear.json"
        destination = "/tmp/clear.json"
    }

    provisioner "file" {
        source = "${path.module}/config/service.json"
        destination = "/tmp/service.json"
    }

    provisioner "file" {
        source = "${var.consul_root_certificate}"
        destination = "/tmp/root.crt"
    }

    provisioner "file" {
        source = "${var.consul_certificate}"
        destination = "/tmp/consul.crt"
    }

    provisioner "file" {
        source = "${var.consul_key}"
        destination = "/tmp/consul.key"
    }

    provisioner "file" {
        source = "${var.service_root_certificate}"
        destination = "/tmp/service_root.crt"
    }

    provisioner "file" {
        source = "${var.service_certificate}"
        destination = "/tmp/service.crt"
    }

    provisioner "file" {
        source = "${var.service_key}"
        destination = "/tmp/service.key"
    }

    provisioner "file" {
        source = "${path.module}/config/rest_service.service"
        destination = "/tmp/rest_service.service"
    }

    provisioner "file" {
        source = "${path.module}/config/consul.service"
        destination = "/tmp/consul.service"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/stop_nginx.sh"
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install_rest_service.sh",
            "/tmp/install_rest_service.sh"
        ]
    }

    provisioner "file" {
        source = "${path.module}/config/dnsmasq.conf"
        destination = "/tmp/dnsmasq.conf"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/setup_certs.sh",
            "${path.module}/scripts/rest_service.sh",
            "${path.module}/scripts/dnsmasq.sh"
        ]
    }
}
resource "aws_security_group" "consul_service" {
    name = "${var.tag_name}-security-group"
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
