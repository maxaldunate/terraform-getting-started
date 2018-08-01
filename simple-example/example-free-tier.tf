variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "eu-west-1"
}

variable "amis" {
  type = "map"
}

output "ami" {
  value = "${lookup(var.amis, var.region)}"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  depends_on    = ["aws_s3_bucket.example"]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

resource "aws_s3_bucket" "example" {
  bucket = "terraform-getting-started-guide-max-aldunate"
  acl    = "private"
}
