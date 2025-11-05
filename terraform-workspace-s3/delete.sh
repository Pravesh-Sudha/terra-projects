#!/bin/bash

terraform workspace select dev
terraform destroy --auto-approve

terraform workspace select stage
terraform destroy --auto-approve

terraform workspace select prod
terraform destroy --auto-approve