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
3. Run command with your credentials.
```
make vault db_pass=<DB password> \
	   dd_api_key=<Datadog API key> \
	   dd_app_key=<Datadog Application key> \
	   yc_token=<Yandex clound Auth0 token>
```
4. Put entered password into `.vaultpassword`.
5. Set up IP's of VM's in `ansible/inventory.ini` and Database Id in `ansible/group_vars/all/environments.yml`
6. Set up docker on VM's 
```
make docker
```
7. Deploy to servers
```
make deploy-full
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
* Deploy Datadog
```
make deploy-datadog
```
* Deploy Book API
```
make deploy-book-api
```
