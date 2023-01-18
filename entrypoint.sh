#!/bin/bash

# Required variables:
#   GCLOUD_SA_KEY: base64 encoded string with service account key (cat /pat/to/key | base64 -w0)

# load NVM
source /usr/local/nvm/nvm.sh

# Run the original enrypoint
exec /usr/local/bin/jenkins-slave "$@"
