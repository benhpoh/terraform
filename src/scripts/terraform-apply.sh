#!/usr/bin/env bash
set -euo pipefail

cd src
terraform apply -auto-approve ${BUILD_BUILDNUMBER}-$CLIENT_ENVIRONMENT.tfplan 