
output "private_server_ips" {
  value = ["${aws_instance.consul_service.*.private_ip}"]
}
