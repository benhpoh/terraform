#!/usr/bin/env bash
set -euo pipefail

cd src
terraform validate -var-file=deployment/$CLIENT_ENVIRONMENT/$CLIENT_ENVIRONMENT.tfvars