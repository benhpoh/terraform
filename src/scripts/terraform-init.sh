#!/usr/bin/env bash
set -euo pipefail

cd src
terraform init -var-file=deployment/$CLIENT_ENVIRONMENT/$CLIENT_ENVIRONMENT.tfvars -backend-config="container_name=$CLIENT_ID-$CLIENT_ENVIRONMENT" -backend-config="key=$CLIENT_PROJECT_ID-$CLIENT_ENVIRONMENT.tfstate" -backend-config="sas_token=$SAS_TOKEN"