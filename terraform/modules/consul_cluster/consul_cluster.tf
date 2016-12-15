
module "consul" {
    source = "git::ssh://git@gitlab.troweprice.com/security-engineering/terraform-modules.git//terraform//modules//consul_node?ref=master"
    ami = "${var.ami}"
    bastion_host = "${var.bastion_host}"
    bastion_user = "${var.bastion_user}"
    consul_cluster_count = "${var.consul_cluster_count}"
    private_key = "${var.private_key}"
    key_name = "${var.key_name}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_ids = "${var.subnet_ids}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tag_name = "${var.tag_name}"
    tag_finance = "${var.tag_finance}"
    tag_owner_email = "${var.tag_owner_email}"
    tag_schedule = "${var.tag_schedule}"
    tag_business_justification = "${var.tag_business_justification}"
    tag_auto_start = "${var.tag_auto_start}"
}

data "template_file" "template_consul_config" {
    template = "${file("${path.module}/config/consul_config.tpl")}"
    vars {
        retry_join = "${join("\",\"", module.consul.private_server_ips)}"
        datacenter = "${var.datacenter}"
        node_count = "${var.consul_cluster_count}"
        gossip_encryption_key = "${var.gossip_encryption_key}"
    }
}

resource "null_resource" "cluster_configuration" {
    count = "${var.consul_cluster_count}"
    connection {
        host = "${element(module.consul.private_server_ips, count.index)}"
        user = "ubuntu"
        private_key = "${var.private_key}"
        agent        = "false"
        bastion_host = "${var.bastion_host}"
        bastion_user = "${var.bastion_user}"
    }

    provisioner "file" {
        content = "${data.template_file.template_consul_config.rendered}"
        destination = "/tmp/consul.json"
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
        source = "${var.password_file}"
        destination = "/tmp/.htpasswd"
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/scripts/setup_nginx_auth.sh",
            "${path.module}/scripts/setup_certs.sh",
            "${path.module}/scripts/consul_service.sh",
            "${path.module}/scripts/reload_nginx.sh"
        ]
    }
}
