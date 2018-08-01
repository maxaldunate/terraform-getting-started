variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "eu-west-1"
}

module "consul" {
  source = "hashicorp/consul/aws"

  #  aws_region  = "eu-west-1" # should match provider region
  num_servers = "3"
}

output "consul_server_asg_name" {
  value = "${module.consul.asg_name_servers}"
}
