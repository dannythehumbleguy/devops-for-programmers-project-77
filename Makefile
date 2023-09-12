deploy-full:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file .vaultpassword

deploy-datadog:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --tags "datadog" --vault-password-file .vaultpassword

deploy-book-api:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --tags "book-api"  --vault-password-file .vaultpassword

docker:
	ansible-playbook ansible/docker.yml -i ansible/inventory.ini --vault-password-file .vaultpassword

local: 
	docker-compose up

resources:
	terraform -chdir=terraform apply

destroy:
	terraform -chdir=terraform destroy

vault:
	echo 'secret_db_password: "$(db_pass)"' > ansible/group_vars/all/vault.yml
	echo 'secret_datadog_api_key: "$(dd_api_key)"' >> ansible/group_vars/all/vault.yml
	echo 'sercet_datadog_app_key: "$(dd_app_key)"' >> ansible/group_vars/all/vault.yml
	echo 'sercet_yc_token: "$(yc_token)"' >> ansible/group_vars/all/vault.yml
	ansible-vault encrypt ansible/group_vars/all/vault.yml
	echo "your vault password" > .vaultpassword

terraform:
	echo 'yc_token = "<yandex cloud Auth0 Token>"' > secrets.auto.tfvars
	echo 'db_password = "<BB user password>"' >> secrets.auto.tfvars
	echo 'datadog_api_key = "<Datadog API key>"' >> secrets.auto.tfvars
	echo 'datadog_app_key = "<Datadog Application key>"' >> secrets.auto.tfvars
	echo 'ssh_key = "<ssh key for VM>"' >> secrets.auto.tfvars
	terraform -chdir=terraform init