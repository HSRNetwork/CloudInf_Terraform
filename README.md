# CloudInf_Terraform
Docker Swarm Cluster on Digital Ocean with Terraform

## Preparing

### DigitalOcean
Before you can start with this lab you have to create a [DigitalOcean](https://m.do.co/c/2983f9d0dc6d) account. When you have created an account you have to generate an API token (make sure you enable read and write access). Please write down you API token because [DigitalOcean](https://m.do.co/c/2983f9d0dc6d) will not show you the token again.

### SSH Key
When you not already have a SSH key then you can create one with the following command:
```
ssh-keygen -o -a 100 -t cloudinf -C cloudinf@digitalocean
```
Once the keys are generated use the following command to add the private key to your SSH Agent:
```
ssh-add ~/.ssh/id_cloudinf
```

### Clone
Clone this repository to your computer:
```
git clone https://github.com/HSRNetwork/CloudInf_Terraform.git
```

## Exercise
### Create the Terraform Variables File
Create a new file named `terraform.tfvars` and add the following lines:
```
do_token="YOUR DIGITALOCEAN API TOKEN"
public_key_path="PATH TO YOUR PUBLIC KEY FILE"
```

### Edit Deployment File




```
sudo apt install jq
```
