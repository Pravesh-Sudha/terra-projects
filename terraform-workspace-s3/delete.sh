#!/bin/bash

set -e

echo "🚫 Deleting the Dev Env"
terraform workspace select dev
terraform destroy --auto-approve
terraform workspace select stage
terraform workspace delete dev

echo "🚫 Deleting the Stage Env"
terraform destroy --auto-approve
terraform workspace select prod
terraform workspace delete stage

echo "🚫 Deleting the Prod Env"
terraform destroy --auto-approve
terraform workspace select default
terraform workspace delete prod