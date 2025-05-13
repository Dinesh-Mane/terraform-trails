# What is a Terraform Module?
A Terraform module is a collection of .tf files grouped together that perform a specific task and can be reused.  
Think of it like a function in programming:
```python
def create_vm():
    # code to create VM
```
In Terraform:
```hcl
module "create_ec2" {
  source = "./modules/ec2"
  instance_type = "t2.micro"
  ...
}
```
So, a module:
- is a folder with .tf files
- Can be reused across different environments
- Makes your Terraform code clean, modular, and DRY (Don’t Repeat Yourself)

# Basic Module Structure Example
Suppose we want to create EC2 using a module:
### Folder Structure:
```css
terraform-root/
├── main.tf
├── provider.tf
└── modules/
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```
### `terraform-root/main.tf` (Calling module)
```hcl
provider "aws" {
  alias  = "dev"
  region = "us-west-2"
  profile = "dev-profile"
}

module "dev_instance" {
  source         = "./modules/ec2"
  instance_name  = "DevVM"
  instance_type  = "t2.micro"
  aws_region     = "us-west-2"
  providers = {
    aws = aws.dev
  }
}
```

### `modules/ec2/main.tf` (Inside the module)
```hcl
provider "aws" {
  alias = "dev"
}

resource "aws_instance" "this" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}
```

### `modules/ec2/variables.tf`
```hcl
variable "instance_name" {}
variable "instance_type" {}
variable "aws_region" {}
```
---

## Why Use provider with Alias Inside Module?
When you use aliased providers in root, modules don’t automatically inherit the alias.  
So you must pass the provider manually like this:  
```hcl
providers = {
  aws = aws.dev
}
```
Then in module:
```hcl
provider "aws" {
  alias = "dev"
}
```








