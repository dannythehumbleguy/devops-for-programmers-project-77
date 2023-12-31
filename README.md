### Pre conditions
1. User system requirements: 
    * Ansible 
    * Trerraform CLI
    * openssl
2. Log in to Terraform by CLI [(Guide)](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login/).

### Guide to deploy
1. Run command with your credentials. Your vault password will be in `.vaultpassword` file. 
```
make vault db_pass=<DB password> \
	   dd_api_key=<Datadog API key> \
	   dd_app_key=<Datadog Application key> \
	   yc_token=<Yandex clound Auth0 token> \
	   yc_cloud_id=<Yandex cloud id> \
	   yc_folder_id=<Yandex account folder id>
```
2. Run command below for initializing terraform.
```
make terraform
```
3. Allocate resources
```
make resources
```
4. Deploy to servers
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
* Set up or update Datadog
```
make datadog
```
* Deploy Book API
```
make deploy-book-api
```
* Set up Docker
```
make docker
```
