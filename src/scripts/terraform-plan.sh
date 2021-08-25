#!/usr/bin/env bash
set -euo pipefail

cd src
terraform plan -var-file=deployment/$CLIENT_ENVIRONMENT/$CLIENT_ENVIRONMENT.tfvars -var "administrator_login_password=$ADMINISTRATOR_LOGIN_PASSWORD" -out ${BUILD_BUILDNUMBER}-$CLIENT_ENVIRONMENT.tfplan
terraform show -json ${BUILD_BUILDNUMBER}-$CLIENT_ENVIRONMENT.tfplan > ${BUILD_BUILDNUMBER}-$CLIENT_ENVIRONMENT.json
cat ${BUILD_BUILDNUMBER}-$CLIENT_ENVIRONMENT.json