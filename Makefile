deploy:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file .vaultpassword

docker:
	ansible-playbook ansible/docker.yml -i ansible/inventory.ini --vault-password-file .vaultpassword

local: 
	docker-compose up

resources:
	terraform -chdir=terraform apply

destroy:
	terraform -chdir=terraform destroy

vault:
	echo "secret_db_password: $(dbpass)" > ansible/group_vars/all/vault.yml
	ansible-vault encrypt ansible/group_vars/all/vault.yml
	echo "your vault password" > .vaultpassword

terraform:
	echo 'yc_token = "<yandex cloud Auth0 Token>"' > secrets.auto.tfvars
	echo 'db_password = "<BB user password>"' >> secrets.auto.tfvars
	echo 'ssh_key = "<ssh key for VM>"' >> secrets.auto.tfvars
	terraform -chdir=terraform init