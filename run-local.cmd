@echo off
terraform destroy -auto-approve -var-file=secrets.tfvars

terraform refresh -var-file=secrets.tfvars

terraform import google_service_account.default_service_account projects/duckhome-firebase/serviceAccounts/properties-api-service@duckhome-firebase.iam.gserviceaccount.com
terraform import google_secret_manager_secret.mongodb_url projects/duckhome-firebase/secrets/mongodb_url
terraform import google_secret_manager_secret.mongodb_database projects/duckhome-firebase/secrets/mongodb_database
terraform import google_secret_manager_secret.property_collection_name projects/duckhome-firebase/secrets/property_collection_name
terraform import google_secret_manager_secret.property_sequence_collection_name projects/duckhome-firebase/secrets/property_sequence_collection_name

terraform state list

terraform plan -out=tfplan.out -var-file=secrets.tfvars

terraform apply -auto-approve tfplan.out
