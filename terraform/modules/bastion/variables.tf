variable "key_name" {
}

variable "ami" {
}

variable "vpc_id" {
}

variable "vpc_cidr" {
}

variable "instance_type" {
    default = "t2.micro"
    description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}
variable "tag_name" {
    default = "bastion-host"
    description = "Name tag for the servers"
}

variable "subnet_id" {
    description = "The Subnet to use for the consul cluster."
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
