
variable "bastion_host" {
    description = "IP of the bastion host"
}

variable "bastion_user" {
    description = "user of the bastion host"
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "consul_root_certificate" {
    description = "The root certificate for the consul cluster."
}

variable "consul_certificate" {
    description = "The certificate use for the consul cluster."
}

variable "consul_key" {
    description = "The key to use for the consul cluster."
}

variable "service_root_certificate" {
    description = "The root certificate for the services."
}

variable "service_certificate" {
    description = "The certificate use for the services."
}

variable "service_key" {
    description = "The key to use for the services."
}

variable "consul_cluster_ips" {
    type = "list"
    description = "List of consul cluster IPs."
}

variable "associate_public_ip_address" {
    description = "Create public IP."
    default = false
}

variable "datacenter" {
    description = "Name of consul datacenter."
}

variable "private_key" {
    description = "Path to the private key specified by key_name."
}

variable "gossip_encryption_key" {
    description = "Result of consul keygen."
}

variable "ami" {
}

variable "service_count" {
    description = "Number of instances."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "subnet_ids" {
    type = "list"
    description = "The Subnets to use for the consul cluster."
}

variable "rest_service_url" {
    description = "The url of the service single file executable (think golang)."
}

variable "rest_service_conf" {
    default = "scripts/rest_service.service"
    description = "The name/path of the service config (health check)."
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "vpc_cidr" {
}

variable "tag_name" {
    description = "Name tag for the servers"
}

variable "tag_finance" {
    description = "Finance tag for the servers"
}

variable "tag_owner_email" {
    description = "Email tag for the servers"
}

variable "tag_schedule" {
    default = "AlwaysUp"
    description = "Schedule tag for the servers"
}

variable "tag_business_justification" {
    default = "Short lived instance that will auto terminate"
    description = "BusinessJustification tag for the servers"
}

variable "tag_auto_start" {
    default = "Off"
    description = "AutoStart tag for the servers"
}
