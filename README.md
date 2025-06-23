# Static Site IaC

Deploy a static website to AWS EC2 using Terraform and Ansible.

## What You Need

- AWS account
- Terraform installed
- Ansible installed
- AWS CLI configured

## Quick Start

1. **Clone and setup**
   ```bash
   git clone https://github.com/qtnick/static_site_iac.git
   cd static_site_iac
   ```

2. **Deploy infrastructure**
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

3. **Configure server**
   ```bash
   cd ../ansible
   ansible-playbook playbook.yml
   ```

## What It Does

- **Terraform**: Creates EC2 instance + security groups
- **Ansible**: Installs web server + deploys your site

## Files

```
terraform/     # AWS infrastructure
ansible/       # Server configuration  
static_files/  # Your website files
```

## Cleanup

```bash
terraform destroy
```

That's it!
