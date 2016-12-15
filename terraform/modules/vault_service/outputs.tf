
output "private_server_ips" {
  value = ["${aws_instance.vault_service.*.private_ip}"]
}

output "public_server_ips" {
  value = ["${aws_instance.vault_service.*.public_ip}"]
}
