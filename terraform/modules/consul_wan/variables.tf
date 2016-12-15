
variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "private_key" {
    description = "Path to the private key specified by key_name."
}

variable "bastion_host" {
    description = "Bastion host IP."
}

variable "bastion_user" {
    description = "Bastion host user."
}

variable "retry_join_wan" {
    type = "list"
    description = "The IP addresses of all consul servers."
}
