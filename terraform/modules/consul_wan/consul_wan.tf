
data "template_file" "template_consul_join" {
    template = "${file("${path.module}/scripts/consul_join.sh")}"
    vars {
        retry_join_wan = "${join(" ", var.retry_join_wan)}"
    }
}

resource "null_resource" "consul_join" {
    count = "${length(var.retry_join_wan)}"
    connection {
        host = "${element(var.retry_join_wan, count.index)}"
        user = "ubuntu"
        private_key = "${var.private_key}"
        agent        = "false"
        bastion_host = "${var.bastion_host}"
        bastion_user = "${var.bastion_user}"
    }

    provisioner "file" {
        content = "${data.template_file.template_consul_join.rendered}"
        destination = "/tmp/consul_join.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/consul_join.sh",
          "/tmp/consul_join.sh"
        ]
    }
}
