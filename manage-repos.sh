#!/bin/bash

WORKSPACE="cloudwalker7605"
BITBUCKET_USER="cloudwalker7605-admin"
APP_PASSWORD="<APP_PASSWORD>"

for REPO_NAME in */; do
  # Remove trailing slash
  REPO_NAME="${REPO_NAME%/}"

  # Skip . and ..
  if [[ $REPO_NAME == "." || $REPO_NAME == ".." ]]; then
    continue
  fi
  LOWERCASE_REPO_NAME=$(echo $REPO_NAME | tr '[:upper:]' '[:lower:]')

  curl -s -u "$BITBUCKET_USER:$APP_PASSWORD" -X PUT \
    "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$LOWERCASE_REPO_NAME" \
    -H "Content-Type: application/json" \
    -d '{"scm": "git", "is_private": true}' | jq .
done
