variable "tag_name" {
    default = "elb"
    description = "Name tag for the elb"
}

variable "vpc_id" {
    description = "The VPC to use."
}

variable "subnet_ids" {
    type = "list"
    description = "Subnet for your elb."
}

variable "vpc_cidr" {
}

variable "ssl_certificate_id" {
    description = "The ARN to the certificate"
}

variable "instance_ids" {
    type = "list"
    description = "The instance_ids to use for the ELB."
}

variable "instance_port" {
    default = "443"
    description = "The instance port to use for the back end of the ELB."
}

variable "instance_protocol" {
    default = "https"
    description = "The protocol for the back end of the ELB"
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

variable "health_check_target" {
    default = "HTTPS:443/index.html"
    description = "The ping target for health checking"
}
