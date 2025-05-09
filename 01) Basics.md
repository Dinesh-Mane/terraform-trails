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

