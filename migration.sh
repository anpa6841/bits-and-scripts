#!/bin/bash

# Bitbucket credentials
WORKSPACE="<your-workspace>"
BITBUCKET_USER="<your-bitbucket-user-admin>"
APP_PASSWORD="<APP_PASSWORD>"

for dir in */; do
  # Remove trailing slash
  REPO_NAME="${dir%/}"

  # Skip . and ..
  if [[ $REPO_NAME == "." || $REPO_NAME == ".." ]]; then
    continue
  fi

  echo "Migrating $REPO_NAME..."

  # Create a new empty repository in Bitbucket
  LOWERCASE_REPO_NAME=$(echo $REPO_NAME | tr '[:upper:]' '[:lower:]')

  RESPONSE=$(curl -s -u $BITBUCKET_USER:$APP_PASSWORD -o /dev/null -w "%{http_code}" -X POST \
    https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$LOWERCASE_REPO_NAME \
    -H "Content-Type: application/json" \
    -d '{"scm": "git", "is_private": false}')

  if [ $RESPONSE -eq 201 ]; then
    echo "Repository $REPO_NAME created successfully."
  elif [ $RESPONSE -eq 400 ]; then
    echo "Repository $REPO_NAME already exists. Skipping creation."
  fi

  echo "Pushing to Bitbucket..."

  # Add Bitbucket as a remote (if it doesn't already exist)
  if ! git -C $REPO_NAME remote | grep -q '^bitbucket$'; then
    git -C $REPO_NAME remote add bitbucket git@bitbucket.org:$WORKSPACE/$LOWERCASE_REPO_NAME
  else
    echo "Remote 'bitbucket' already exists for $REPO_NAME. Skipping remote add."
  fi

  # Push the repository
  git -C $REPO_NAME push --mirror bitbucket
done

