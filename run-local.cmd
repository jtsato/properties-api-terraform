@echo on

:: terraform state rm google_cloud_run_service.default projects/duckhome-firebase/locations/southamerica-east1/services/properties-api-service
:: terraform state rm google_service_account.default_service_account projects/duckhome-firebase/serviceAccounts/properties-api-service@duckhome-firebase.iam.gserviceaccount.com
:: terraform state rm google_secret_manager_secret.mongodb_url projects/duckhome-firebase/secrets/mongodb_url
:: terraform state rm google_secret_manager_secret.mongodb_database projects/duckhome-firebase/secrets/mongodb_database
:: terraform state rm google_secret_manager_secret.property_collection_name projects/duckhome-firebase/secrets/property_collection_name
:: terraform state rm google_secret_manager_secret.property_sequence_collection_name projects/duckhome-firebase/secrets/property_sequence_collection_name

terraform plan -destroy

terraform destroy -auto-approve -var-file=secrets.tfvars

pause

:: terraform import google_cloud_run_service.default projects/duckhome-firebase/locations/southamerica-east1/services/properties-api-service
:: terraform import google_service_account.default_service_account projects/duckhome-firebase/serviceAccounts/properties-api-service@duckhome-firebase.iam.gserviceaccount.com
:: terraform import google_secret_manager_secret.mongodb_url projects/duckhome-firebase/secrets/mongodb_url
:: terraform import google_secret_manager_secret.mongodb_database projects/duckhome-firebase/secrets/mongodb_database
:: terraform import google_secret_manager_secret.property_collection_name projects/duckhome-firebase/secrets/property_collection_name
:: terraform import google_secret_manager_secret.property_sequence_collection_name projects/duckhome-firebase/secrets/property_sequence_collection_name          

:: terraform refresh -var-file=secrets.tfvars

terraform state list

terraform plan -out=tfplan.out -var-file=secrets.tfvars

terraform apply -auto-approve tfplan.out
