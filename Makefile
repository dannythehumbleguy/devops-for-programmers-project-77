deploy:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --vault-password-file .vaultpassword

docker:
	ansible-playbook ansible/docker.yml -i ansible/inventory.ini --vault-password-file .vaultpassword

local: 
	docker-compose up

vault:
	echo "secret_db_password: $(dbpass)" > ansible/group_vars/all/vault.yml
	ansible-vault encrypt ansible/group_vars/all/vault.yml
	echo "your vault password" > .vaultpassword

terraform-sercrets:
	echo 'yc_token = "<yandex cloud Auth0 Token>"' > secrets.auto.tfvars
	echo 'db_name = "<DB name>"' >> secrets.auto.tfvars
	echo 'db_user = "<DB user name>"' >> secrets.auto.tfvars
	echo 'db_password = "<BB user password>"' >> secrets.auto.tfvars
	echo 'ssh_key = "SSH key for VM's"' >> secrets.auto.tfvars