terraform destroy -auto-approve -var-file=secrets.tfvars
terraform refresh -var-file=secrets.tfvars
terraform plan -out=tfplan.out -var-file=secrets.tfvars
terraform apply -auto-approve tfplan.out
