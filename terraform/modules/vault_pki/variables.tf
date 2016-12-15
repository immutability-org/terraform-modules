variable "issuer_certificate" {
    description = "The path to the issuer certificate."
}

variable "certificate" {
    description = "The path to the certificate."
}

variable "private_key" {
    description = "The path to the private key."
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

variable "vault_token" {
    description = "The vault token."
}

variable "temp_file" {
    description = "The name of the temp file."
}

variable "vault_addr" {
    default = "https://127.0.0.1:8200"
    description = "The vault address."
}
