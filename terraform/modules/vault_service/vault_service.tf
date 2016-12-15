
data "template_file" "template_consul_client_config" {
    template = "${file("${path.module}/config/client_consul_config.tpl")}"
    vars {
        retry_join = "${join("\",\"", var.consul_cluster_ips)}"
        datacenter = "${var.datacenter}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

resource "aws_instance" "vault_service" {
    ami = "${var.ami}"
    count = "${var.service_count}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_ids[count.index]}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    vpc_security_group_ids = ["${aws_security_group.vault_service.id}"]

    connection {
        user          = "ubuntu"
        host          = "${self.private_ip}"
        private_key   = "${var.private_key}"
        agent         = "false"
        bastion_host  = "${var.bastion_host}"
        bastion_user  = "${var.bastion_user}"
    }

    tags {
        Name = "${var.tag_name}_${count.index}"
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
        source = "${path.module}/config/vault_service.json"
        destination = "/tmp/vault_service.json"
    }

    provisioner "file" {
        source = "${path.module}/config/vault.json"
        destination = "/tmp/vault.json"
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
        source = "${var.vault_certificate}"
        destination = "/tmp/vault.crt"
    }

    provisioner "file" {
        source = "${var.vault_key}"
        destination = "/tmp/vault.key"
    }

    provisioner "file" {
        source = "${path.module}/config/consul.service"
        destination = "/tmp/consul.service"
    }

    provisioner "file" {
        source = "${path.module}/config/vault.service"
        destination = "/tmp/vault.service"
    }

    provisioner "file" {
        source = "${path.module}/scripts/install_vault_service.sh"
        destination = "/tmp/install_vault_service.sh"
    }

    provisioner "file" {
        source = "${path.module}/scripts/vaultinit.sh"
        destination = "/tmp/vaultinit.sh"
    }

    provisioner "file" {
        source = "${path.module}/scripts/use_vault_as_ca.sh"
        destination = "/tmp/use_vault_as_ca.sh"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/stop_nginx.sh"
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install_vault_service.sh",
            "/tmp/install_vault_service.sh"
        ]
    }

    provisioner "file" {
        source = "${path.module}/config/dnsmasq.conf"
        destination = "/tmp/dnsmasq.conf"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/setup_certs.sh",
            "${path.module}/scripts/vault_service.sh",
            "${path.module}/scripts/dnsmasq.sh"
        ]
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/use_vault_as_ca.sh",
          "chmod +x /tmp/vaultinit.sh",
          "/tmp/vaultinit.sh ${var.keybase_keys} ${var.key_threshold} ${var.domain_name}",
        ]
    }

}
resource "aws_security_group" "vault_service" {
    name = "${var.tag_name}_security_group"
    description = "Vault internal traffic + maintenance."
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
        protocol    = "tcp"
        from_port   = 8080
        to_port     = 8080
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
