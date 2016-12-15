variable "ami" {
}

variable "bastion_host" {
    description = "IP of the bastion host"
}

variable "bastion_user" {
    description = "user of the bastion host"
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

variable "subnet_ids" {
    type = "list"
    description = "The Subnets to use for the consul cluster."
}

variable "vpc_id" {
    description = "The VPC to use for the consul cluster."
}

variable "vpc_cidr" {
}

variable "consul_cluster_count" {
    default = "3"
    description = "The number of Consul servers to launch."
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tag_name" {
    default = "consul-server-node"
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
