# [Terraform](https://www.terraform.io)

## [Terraform Getting Started](https://www.terraform.io/intro/getting-started/install.html)

### [Build Infrastructure](https://www.terraform.io/intro/getting-started/build.html)

* [Configuration Syntax](https://www.terraform.io/docs/configuration/syntax.html)
* [Providers](https://www.terraform.io/docs/providers/index.html)
* [Remote State](https://www.terraform.io/docs/state/remote.html)

```bash
# downloading plugin for provider & ooss
$ terraform init
# Initializing the backend...
# Initializing provider plugins...
# - downloading plugin for provider "aws"...

# execution plan
terraform plan  
terraform plan  -out config.out.result  

# apply to provider, create/modify resources
terraform apply  
terraform apply  "config.out.result"
# terraform.tfstate file  

# Refreshing
terraform refresh

# Show current state
terraform show
```

* Aws AMIs on eu-west-1
  - ami-2a7d75c0	Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
  - ami-466768ac	Amazon Linux 2 AMI (HVM), SSD Volume Type


### Change Infrastructure
Change `.tf` file with other Aws AMI and run `terraform apply`.

### Destroy Infrastructure
`terraform destroy`

### Resource Dependencies
* Implicit dependency
  ```bash
  resource "aws_eip" "ip" {
    instance = "${aws_instance.example.id}"
  }
  ```
* Explicit dependency  
  ```bash
  resource "aws_instance" "example" {
    ami           = "ami-2a7d75c0"
    instance_type = "t2.micro"
    depends_on    = ["aws_s3_bucket.example"]
  }
  ```

### Provision
* To creacte an AMI  -  [Packer - Hashicorp](https://www.packer.io/)
* Provisioner to include **User Data**
  ```bash
  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
  ```
* For configuration management, you should use Terraform provisioning to invoke a real configuration management solution
* Failed Provisioners and Tainted Resources 
  - On next execution, Terraform will remove any tainted resources and create new resources, attempting to provision them again.
* If when = "destroy" is specified, the provisioner will run when the resource it is defined within is destroyed.
* `on_failure = "continue"`

### Input Variables 
* Specifying variables
```bash
$ terraform apply \
  -var 'access_key=foo' \
  -var 'secret_key=bar'
# ...
```
* From File: `terraform.tfvars` or `*.auto.tfvars` in current directory
* Different files even
```bash
$ terraform apply \
  -var-file="secret.tfvars" \
  -var-file="production.tfvars"
```
* From environment variables like `TF_VAR_access_key`

* Lists
```bash
# implicitly by using brackets [...]
variable "cidrs" { default = [] }

# explicitly
variable "cidrs" { type = "list" }

#On .tfvars file
cidrs = [ "10.0.0.0/16", "10.1.0.0/16" ]
```

* Maps
```bash
variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-2" = "ami-4b32be2b"
  }
}

# Map usage
resource "aws_instance" "example" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
}

# Assigning Maps
$ terraform apply -var 'amis={ us-east-1 = "foo", us-west-2 = "bar" }'
```

### Output Variables
```bash
$ terraform apply
# ...
# Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
# Outputs:
#  ip = 50.17.232.209

$ terraform output ip
# 50.17.232.209
```

### Modules
* [Terraform Module Registry](https://registry.terraform.io/)
* `$ terraform init -upgrade`
* https://registry.terraform.io/modules/hashicorp/consul/aws/0.3.5

### Remote Backends
* Run Terraform in a remote environment with shared access to state
* Configure the backend in your configuration file
```bash
terraform {
  backend "consul" {
    address = "demo.consul.io"
    path    = "getting-started-RANDOMSTRING"
    lock    = false
    scheme  = "https"
  }
}
```
* [Terraform Enterprise ](https://www.hashicorp.com/products/terraform?utm_source=oss&utm_medium=getting-started&utm_campaign=terraform)
* Although Terraform Enterprise can act as a standard remote backend to support Terraform runs on local machines, it works even better as a remote run environment
* Supports two main workflows
  - A VCS-driven workflow
  - API-driven workflow

### Next Steps
* [Documentation](https://www.terraform.io/docs/index.html)
* [Examples](https://www.terraform.io/intro/examples/index.html)
* [Import](https://www.terraform.io/docs/import/index.html)

The End