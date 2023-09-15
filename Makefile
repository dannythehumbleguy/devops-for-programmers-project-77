deploy-full:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file .vaultpassword

datadog:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --tags "datadog" --vault-password-file .vaultpassword

deploy-book-api:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --tags "book-api"  --vault-password-file .vaultpassword

docker:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --tags "docker"  --vault-password-file .vaultpassword

local: 
	docker-compose up

resources:
	terraform -chdir=terraform apply

destroy:
	terraform -chdir=terraform destroy

vault:
	openssl rand -hex 12 > .vaultpassword
	echo 'secret_db_password: "$(db_pass)"' > ansible/group_vars/all/vault.yml
	echo 'secret_datadog_api_key: "$(dd_api_key)"' >> ansible/group_vars/all/vault.yml
	echo 'secret_datadog_app_key: "$(dd_app_key)"' >> ansible/group_vars/all/vault.yml
	echo 'secret_yc_token: "$(yc_token)"' >> ansible/group_vars/all/vault.yml
	echo 'secret_yc_cloud_id: "$(yc_cloud_id)"' >> ansible/group_vars/all/vault.yml
	echo 'secret_yc_folder_id: "$(yc_folder_id)"' >> ansible/group_vars/all/vault.yml
	ansible-vault encrypt ansible/group_vars/all/vault.yml --vault-password-file .vaultpassword
	
terraform:
	terraform -chdir=terraform init