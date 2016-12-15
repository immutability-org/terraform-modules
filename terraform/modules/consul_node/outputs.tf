
output "private_server_ips" {
  value = ["${aws_instance.consul_node.*.private_ip}"]
}

output "instance_ids" {
  value = ["${aws_instance.consul_node.*.id}"]
}
