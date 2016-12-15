provider "aws" {
    region = "${var.region}"
}

module "consul_certificates" {
    source = "../modules/vault_pki"
    temp_file = "./consul_tmp.json"
    certificate = "${var.consul_certificate}"
    private_key = "${var.consul_key}"
    issuer_certificate = "${var.consul_root_certificate}"
    common_name = "${var.common_name}"
    ip_sans = "${var.ip_sans}"
    alt_names = "${var.alt_names}"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "vault_certificates" {
    source = "../modules/vault_pki"
    temp_file = "./vault_tmp.json"
    certificate = "${var.vault_certificate}"
    private_key = "${var.vault_key}"
    issuer_certificate = "${var.vault_root_certificate}"
    common_name = "${var.common_name}"
    ip_sans = "${var.ip_sans}"
    alt_names = "${var.alt_names}"
    vault_token = "${var.vault_token}"
    vault_addr = "${var.vault_addr}"
}

module "bastion" {
    source = "../modules/bastion"
    ami = "${var.ami}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tag_name = "${var.unique_prefix}_bastion"
    tag_finance = "${var.tag_finance}"
    tag_owner_email = "${var.tag_owner_email}"
    tag_schedule = "${var.tag_schedule}"
    tag_business_justification = "${var.tag_business_justification}"
    tag_auto_start = "${var.tag_auto_start}"
}

module "consul_cluster" {
    source = "../modules/consul_cluster"
    ami = "${var.ami}"
    consul_cluster_count = "${var.consul_cluster_count}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_host = "${module.bastion.private_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tag_name = "${var.unique_prefix}_consul"
    tag_finance = "${var.tag_finance}"
    tag_owner_email = "${var.tag_owner_email}"
    tag_schedule = "${var.tag_schedule}"
    tag_business_justification = "${var.tag_business_justification}"
    tag_auto_start = "${var.tag_auto_start}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul_certificates.certificate}"
    consul_key = "${module.consul_certificates.private_key}"
    consul_root_certificate = "${module.consul_certificates.issuer_certificate}"
    password_file = "${var.password_file}"
}

module "vault_service" {
    source = "../modules/vault_service"
    instance_type = "t2.nano"
    consul_cluster_ips = "${module.consul_cluster.private_server_ips}"
    ami = "${var.ami}"
    service_count = "2"
    domain_name="${var.domain_name}"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    keybase_keys  = "${var.keybase_keys}"
    key_threshold = "${var.key_threshold}"
    bastion_host = "${module.bastion.private_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tag_name = "${var.unique_prefix}_vault"
    tag_finance = "${var.tag_finance}"
    tag_owner_email = "${var.tag_owner_email}"
    tag_schedule = "${var.tag_schedule}"
    tag_business_justification = "${var.tag_business_justification}"
    tag_auto_start = "${var.tag_auto_start}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul_certificates.certificate}"
    consul_key = "${module.consul_certificates.private_key}"
    vault_certificate = "${module.vault_certificates.certificate}"
    vault_key = "${module.vault_certificates.private_key}"
    consul_root_certificate = "${module.consul_certificates.issuer_certificate}"
    vault_root_certificate = "${module.vault_certificates.issuer_certificate}"
}

resource "aws_iam_server_certificate" "vault_service_certificate" {
    name_prefix      = "consul"
    certificate_body = "${module.consul_certificates.certificate_body}"
    private_key      = "${module.consul_certificates.private_key_body}"

    lifecycle {
        create_before_destroy = true
    }
}

module "vault_service_ui_elb" {
    vpc_id = "${var.vpc_id}"
    subnet_ids = "${var.subnet_id}"
    source = "../modules/load_balancer"
    tag_name = "${var.unique_prefix}_consul_ui"
    tag_finance = "${var.tag_finance}"
    tag_owner_email = "${var.tag_owner_email}"
    tag_schedule = "${var.tag_schedule}"
    tag_business_justification = "${var.tag_business_justification}"
    tag_auto_start = "${var.tag_auto_start}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    ssl_certificate_id = "${aws_iam_server_certificate.vault_service_certificate.arn}"
    instance_ids = ["${module.consul_cluster.instance_ids}"]
}

resource "aws_route53_record" "vault_service_ui" {
   zone_id = "${var.aws_route53_zone_id}"
   name = "vault_service.${var.domain_name}"
   type = "CNAME"
   ttl = "10"
   records = ["${module.vault_service_ui_elb.dns_name}"]
}

data "terraform_remote_state" "vault_infrastructure" {
    backend = "s3"
    config {
        bucket = "${var.s3_tfstate_bucket}"
        key = "vault_infrastructure/env_development/terraform.tfstate"
        region = "${var.region}"
        encrypt = "true"
    }
}


module "fabio" {
    source = "../modules/fabio"
    consul_cluster_ips = "${module.consul_cluster.private_server_ips}"
    ami = "${var.ami}"
    fabio_cluster_count = "2"
    private_key = "${file(var.private_key)}"
    key_name = "${var.key_name}"
    bastion_host = "${module.bastion.private_ip}"
    bastion_user = "${module.bastion.user}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    subnet_id = "${var.subnet_id}"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
    tag_name = "${var.unique_prefix}-fabio"
    tag_finance = "${var.tag_finance}"
    tag_owner_email = "${var.tag_owner_email}"
    tag_schedule = "${var.tag_schedule}"
    tag_business_justification = "${var.tag_business_justification}"
    tag_auto_start = "${var.tag_auto_start}"
    datacenter = "${var.datacenter}"
    gossip_encryption_key = "${var.gossip_encryption_key}"
    consul_certificate = "${module.consul_certificates.certificate}"
    fabio_url = "${var.fabio_url}"
    consul_key = "${module.consul_certificates.private_key}"
    consul_root_certificate = "${module.consul_certificates.issuer_certificate}"
    password_file = "${var.password_file}"
}

resource "aws_route53_record" "fabio_a" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "fabio.${var.domain_name}"
    type = "A"
    ttl = "10"
    weighted_routing_policy {
      weight = 50
    }
    set_identifier = "fabio_a"
    records = ["${element(module.fabio.private_server_ips, 0)}"]
}

resource "aws_route53_record" "fabio_b" {
    zone_id = "${var.aws_route53_zone_id}"
    name = "fabio.${var.domain_name}"
    type = "A"
    ttl = "10"
    weighted_routing_policy {
      weight = 50
    }
    set_identifier = "fabio_b"
    records = ["${element(module.fabio.private_server_ips, 1)}"]
}
