deploy:
	ansible-playbook ansible/playbook.yml -i ansible/inventory.ini

terraform-sercrets:
	echo 'yc_token = "<yandex cloud Auth0 Token>"' > secrets.auto.tfvars
	echo 'db_name = "<DB name>"' >> secrets.auto.tfvars
	echo 'db_user = "<DB user name>"' >> secrets.auto.tfvars
	echo 'db_password = "<BB user password>"' >> secrets.auto.tfvars
	echo 'ssh_key = "SSH key for VM's"' >> secrets.auto.tfvars