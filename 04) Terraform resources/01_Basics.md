# What is a Terraform Resource?
In Terraform, a resource represents a single infrastructure object—like an EC2 instance, an S3 bucket, a VPC, a DB instance, etc.—that you want to create, manage, or destroy using your `.tf` files.  

### Syntax of a Resource Block:
```hcl
resource "<PROVIDER>_<RESOURCE_TYPE>" "<LOCAL_NAME>" {
  # Configuration arguments
}
```
Example: Create an AWS EC2 instance
```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "MyWebServer"
  }
}
```

### Common Terraform Resource Types (AWS Example)
| Resource Type         | What it Does                              |
| --------------------- | ----------------------------------------- |
| `aws_instance`        | Launches an EC2 instance                  |
| `aws_s3_bucket`       | Creates an S3 bucket                      |
| `aws_vpc`             | Creates a new Virtual Private Cloud       |
| `aws_security_group`  | Defines firewall rules for EC2, RDS, etc. |
| `aws_iam_role`        | Creates IAM roles for permissions         |
| `aws_lambda_function` | Deploys a serverless Lambda function      |
| `aws_db_instance`     | Creates an RDS database instance          |

### How Terraform Manages Resources (CRUD Lifecycle)
When you run Terraform commands:  
1. terraform plan: Previews what will be created/updated/destroyed
2. terraform apply: Applies the changes (creates/updates/destroys resources)
3. terraform destroy: Deletes the resources you’ve declared


### Example: S3 Bucket + EC2 + Security Group
`main.tf`
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "logs" {
  bucket = "enterprise-logs-2025"
  acl    = "private"
  tags = {
    Name = "Logging Bucket"
    Env  = "prod"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "Web Server"
  }
}
```

### Resource Dependencies
Terraform understands dependencies automatically.  
In the example:  
- EC2 depends on the security group.
- Terraform will create the security group first, then the EC2.

You can also manually force dependencies using `depends_on`:
```hcl
resource "aws_instance" "web" {
  ...
  depends_on = [aws_s3_bucket.logs]
}
```
### Accessing Resource Outputs
You can reference one resource’s values in another:
```hcl
output "web_ip" {
  value = aws_instance.web.public_ip
}
```

### Best Practices for Terraform Resources
| Practice                                         | Why It Matters                             |
| ------------------------------------------------ | ------------------------------------------ |
| Use tags                                         | Helps in cost tracking and management      |
| Use `depends_on` only when needed                | Terraform usually understands dependencies |
| Use variables instead of hardcoding              | For flexibility across environments        |
| Use modules for repeated resources               | DRY and scalable structure                 |
| Use `count` or `for_each` for multiple resources | Easily create multiple EC2s, SGs, etc.     |
















