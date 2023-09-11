### Hexlet tests and linter status:
[![Actions Status](https://github.com/dannycyberwalker/devops-for-programmers-project-77/workflows/hexlet-check/badge.svg)](https://github.com/dannycyberwalker/devops-for-programmers-project-77/actions)

### [API Status](https://statuspage.freshping.io/67786-Nothing)

### Pre conditions
1. User system requirements: 
    * Ansible 
    * Trerraform CLI
2. Log in to Terraform by CLI [(Guide)](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login/).

### Guide to deploy
1. Run command below and set sensetive data to `terraform/secrets.auto.tfvars` for prepare terraform.
```
make terraform-sercrets
```
2. Allocate resources
```
make resources
```
3. Run command with DB password which was in `terraform/secrets.auto.tfvars`.
```
make vault dbpass=<DB password>
```
4. Put entered password into `.vaultpassword`.
5. Set up docker on VM's 
```
make docker
```
6. Deploy to servers
```
make deploy
```

### Other commands 
* Destroy a infrastructure
```
make destroy
```
* Bring up a application locally
```
make local
```
