
variable "bastion_host" {
    description = "IP of the bastion host"
}

variable "bastion_user" {
    description = "user of the bastion host"
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "keybase_keys" {
    description = "Names of Keybase keys to encrypt unseal keys."
}

variable "key_threshold" {
    description = "Number of unseal keys to require."
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

variable "vault_root_certificate" {
    description = "The root certificate for the vault cluster."
}

variable "vault_certificate" {
    description = "The certificate use for vault."
}

variable "vault_key" {
    description = "The key to use for the vault."
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
    description = "The Subnets to use for the service."
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "vpc_cidr" {
}

variable "tag_name" {
    default = "consul-service"
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

variable "domain_name" {
    description = "The domain name that vault issues certificates for."
}
