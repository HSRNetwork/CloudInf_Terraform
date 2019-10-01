# CloudInf_Terraform
Docker Swarm Cluster on Digital Ocean with Terraform

## Preparing

### DigitalOcean
Before you can start with this lab you have to create a DigitalOcean account. When you have created an account you have to generate an API token (make sure you enable read and write access). Please write down you API token because DigitalOcean will not show you the token again.

### SSH Key
Use the following command to generate a new SSH key:
```
ssh-keygen -o -a 100 -t ed25519 -C cloudinf@digitalocean
```

### Clone
Clone this repository to your computer:
```
git clone https://github.com/HSRNetwork/CloudInf_Terraform.git
```

## Exercise
### Edit the Terraform Variables File
Edit the `terraform.tfvars` file an fill in your keys and data.
