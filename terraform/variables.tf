# AWS provider

variable "ami" {
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "vpc_cidr"       {
    description = "The VPC CIDR block."
}

variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "private_key" {
    description = "Path to the private key specified by key_name."
}

variable "associate_public_ip_address" {
    description = "Create public IP."
    default = false
}

variable "region" {
    default = "us-east-1"
    description = "The region of AWS, for AMI lookups."
}

variable "subnet_id" {
    description = "The Subnet to use for the consul cluster."
}

# PKI

variable "vault_token" {
    description = "The vault token."
}

variable "vault_addr" {
    description = "The vault address."
}

# Consul variables

variable "consul_cluster_count" {
    default = "3"
    description = "The number of Consul servers to launch."
}

variable "datacenter" {
    description = "Name of consul datacenter."
}

variable "gossip_encryption_key" {
    description = "Result of consul keygen."
}

variable "password_file" {
    description = "Result sudo htpasswd -c .htpasswd admin."
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


# Vault variables
variable "vault_root_certificate" {
    description = "The root certificate for the vault cluster."
}

variable "vault_certificate" {
    description = "The certificate use for the vault cluster."
}

variable "vault_key" {
    description = "The key to use for the vault cluster."
}

variable "common_name" {
    description = "The CN for the certificate."
}

variable "alt_names" {
    description = "The Subject Alt Names for the certificate."
}

variable "ip_sans" {
    description = "The Subject Alt Names (IP) for the certificate."
}

variable "keybase_keys" {
    description = "Names of Keybase keys to encrypt unseal keys."
}

variable "key_threshold" {
    description = "Number of unseal keys to require."
}

# Conventions

variable "tag_name" {
    description = "Name tag for the servers"
}

variable "unique_prefix" {
    default = "unset_unique_prefix"
    description = "Prefix for all resources"
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

# DNS

variable "aws_route53_zone_id" {
    description = "The Hosted Zone ID."
}

variable "domain_name" {
    description = "The domain name."
}

#Fabio

variable "fabio_release_url" {
    description = "The url of the service single file executable (think golang)."
}

# Terraform
variable "s3_tfstate_bucket" {
  description = "Bucket for remote tfstate"
}
