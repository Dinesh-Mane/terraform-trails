# What is Terraform?
Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp.  
It allows users to define and provision infrastructure in a declarative configuration language. --> **HCL (HashiCorp Configuration Language)**
With Terraform, you can describe the desired state of your infrastructure, including resources such as virtual machines, networks, and storage, in code.  
Terraform then automates the process of provisioning and managing these resources, enabling infrastructure changes through version-controlled configuration files.  

**Simple Definition:** Terraform is a tool that lets you define cloud infrastructure (like servers, networks, databases) in code, and then automatically create and manage it using that code. 

# Why do we use Terraform?
Terraform is used to automate the provisioning and management of cloud infrastructure using code.  
**Main Reasons:**  
1) Infrastructure as Code (IaC) – Manje tumhi AWS, Azure, GCP, etc. madhil servers, networks, DBs, sagla infrastructure code madhun define karu shakta.
2) Automation & Repeatability – Once code lihila ki multiple environments (dev, test, prod) same banavta yetat without manual setup.
3) Version Control – Code `.tf` files Git repo madhye store kela ki infra change history track karu shakta.
4) Multi-cloud support – Terraform allows you to work across AWS, Azure, GCP, etc. using the same syntax.
5) Collaboration & Team workflows – Teams can collaborate better on infrastructure via shared codebase + remote state.

Terraform हे Infrastructure as Code (IaC) साठी वापरलं जातं.  
Infrastructure म्हणजे —  
✅ AWS मधलं EC2 instance,  
✅ VPC, Subnet, Security Groups,  
✅ Azure VM,  
✅ GCP Kubernetes cluster,  
✅ DB instances, Load Balancers... etc.  
हे सगळं आपण जर manually create केलं, तर human errors होतात, repeatable नाही, आणि time-consuming आहे.  

| Feature                          | Description                                                                          |
| -------------------------------- | ------------------------------------------------------------------------------------ |
| **Declarative Language (HCL)**   | Uses **HCL (HashiCorp Configuration Language)** – a declarative language. तुम्ही सांगता "मला हे पाहिजे", Terraform internally ठरवतो "कसं करायचं". |
| **IaC (Infrastructure as Code)** | You write `.tf` files to define your infrastructure instead of manually creating it. |
| **Multi-cloud support**               | Terraform allows you to work across AWS, Azure, GCP, etc. using the same syntax. कारण te `plugin-based architecture` वापरतं. |
| **Execution Phases**             | Uses **terraform plan → terraform apply → terraform destroy** workflow. |
| **Execution Plan (terraform plan)** | Preview of changes before applying. Saangta ki “kay badal honar aahe.” Apply करण्यापूर्वी काय काय changes होतील ते दाखवतं — जसं dry run. |
| **Modules**                         | Reusable chunks of code. Like "functions" in infra. Reusable code blocks — तुम्ही एकदा module लिहिला की पुन्हा पुन्हा वापरू शकता. उदा: reusable VPC, EC2 module.|
| **State Management**             | Keeps track of infrastructure using a **state file** (terraform.tfstate). Terraform प्रत्येक resource चं "state" track करतं. म्हणजे तो ओळखतो की कोणता resource already आहे, कोणता बदललाय, कोणता नविन करायचा आहे.         |
| **Dependency Management**           | Automatically understands what needs to be created first. Terraform internally समजून घेतं की कोणता resource आधी लागेल. उदा: Subnet बनवायचं तर VPC आधीच बनलेलं पाहिजे — हे तो ओळखतो.|
| **Immutable Infra**                 | Always creates *new infra* for big changes instead of mutating. बदल झाल्यास जुनं resource destroy करून नवीन तयार केलं जातं. म्हणून production मध्ये stability येते.|

# What are Terraform alternatives? How is Terraform different?
| Tool                            | Description                                                  | Terraform Comparison                                                   |
| ------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------------------- |
| **AWS CloudFormation**          | AWS-specific IaC tool                                        | Terraform is *multi-cloud* and has better modularity                   |
| **Pulumi**                      | IaC with real languages (Python, JS, Go)                     | Pulumi is imperative; Terraform uses *HCL* (declarative)               |
| **Ansible**                     | Mainly config management (can do IaC)                        | Terraform is *infra provisioning focused*, Ansible is *config-focused* |
| **Chef / Puppet**               | Traditional config mgmt tools                                | Terraform is more modern, *easier to start*, and cloud-first           |
| **CDK (Cloud Development Kit)** | AWS tool for writing infra using real code (Python, TS, etc) | Terraform is *more widely used* and has a bigger ecosystem             |

### Summary:
Terraform हे एक modern, cloud-agnostic, powerful IaC tool आहे.  
हे repeatable, scalable, आणि version-controlled infrastructure साठी वापरलं जातं.  
Terraform ला alternatives आहेत, पण multi-cloud, HCL simplicity, आणि community ecosystem मुळे ते अजूनही industry-standard tool आहे.  

# What is `terraform.tfstate`?
The `terraform.tfstate` file is the **central component** of Terraform's infrastructure management.  
It keeps track of:    
- What resources already exist.  
- What changes have been made.  
- What Terraform thinks your infrastructure currently looks like.

Without this file, Terraform cannot correctly apply changes — it won’t know what to create, update, or destroy.  

# Where do tech companies store the `terraform.tfstate` file?
Professional companies never store the `terraform.tfstate` file locally.  
Instead, they use remote backends so the state is shared, secure, and recoverable.  
### Common Remote Storage Options:
| Storage Location                   | When Used / Purpose                                             |
| ---------------------------------- | --------------------------------------------------------------- |
| **Amazon S3 (with DynamoDB lock)** | Most common when working in AWS. Locking prevents collisions.   |
| **Terraform Cloud / Enterprise**   | Official backend by HashiCorp for team collaboration & history. |
| **Azure Blob Storage**             | Used in Azure-based environments.                               |
| **Google Cloud Storage (GCS)**     | For GCP-based infrastructure.                                   |
| **Consul Backend**                 | For very dynamic, distributed setups.                           |
| **Git backend (rare)**             | Rare and not recommended for tfstate files.                     |

# Why use Remote Storage instead of local?
### 1. Team Collaboration
- If stored locally, multiple people can accidentally run terraform apply at the same time, causing state conflicts.
- Remote backends (like S3 + DynamoDB) support locking, so only one person can modify the infrastructure at a time.

### 2. Consistency and Single Source of Truth
- Everyone refers to the same state file.
- There’s no confusion about which version is the most up-to-date.

### 3. Disaster Recovery
- If the local system crashes or deletes the file, it's gone forever.
- In remote storage like S3 with versioning, you can recover older versions of the state.

### 4. Automation-Friendly
In CI/CD pipelines, Terraform must use a remote state to:
- Avoid collisions
- Integrate secrets management
- Support locking and audit logging

# Real-world Example: Using AWS (S3 + DynamoDB)
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "prod/app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
```
### In this setup:
`bucket`: Where the state file is stored.  
`key`: File path inside the bucket.  
`region`: AWS region.  
`dynamodb_table`: Used for state locking.  
`encrypt`: Ensures data is encrypted at rest.  

# Why is S3 + Versioning Important?
Terraform overwrites the `terraform.tfstate` file every time you run `terraform apply`.  
If this file gets accidentally corrupted, deleted, or modified incorrectly, it could lead to loss of state awareness — which is critical for managing infrastructure.  
That’s why enabling versioning in S3 is considered a best practice for backing up and recovering previous state versions.  
# How to Enable S3 Versioning?
### Step 1: Create the S3 bucket
```bash
aws s3api create-bucket --bucket my-terraform-states --region us-east-1
```
This will return all available Version IDs of the file.
### Step 2: Restore a specific version
```bash
aws s3api copy-object \
  --bucket my-terraform-states \
  --copy-source my-terraform-states/path/to/terraform.tfstate?versionId=PREVIOUS_VERSION_ID \
  --key path/to/terraform.tfstate
```
This command copies the older version and overwrites the current one, effectively restoring it.
## Benefits of S3 Versioning for Terraform State
Accidental corruption? Easily roll back.  
Mistaken terraform destroy? Recover previous working state.  
Like Git for your infrastructure state.  

**Tip:** Not every company enables versioning — but those who care about state recovery and disaster preparedness always do, especially in production. It’s a recommended best practice for all real-world Terraform projects.

