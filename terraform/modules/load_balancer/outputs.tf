
output "dns_name" {
    value = "${aws_elb.load_balancer.dns_name}"
}
