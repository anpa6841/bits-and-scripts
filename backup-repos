#!/bin/bash

ARCHIVE=0  # Default: Do not archive

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--archive) ARCHIVE=1 ;;  # Enable archive mode
        -h|--help)
            echo "Usage: $0 [-a | --archive]"
            echo "  -a, --archive   Create a Zip-protected Archive of the cloned repository"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

curl https://api.github.com/users/anpa6841/repos?per_page=100 | jq '.[].name' | tr -d '"' > repos.txt

# Read repos.txt and clone each repository
while IFS= read -r repo; do
	repo_path=$(pwd)/$repo

	LOCAL_COMMIT=$(git -C $repo rev-parse HEAD | awk '{print $1}')
	REMOTE_COMMIT=$(git -C $repo ls-remote origin HEAD | awk '{print $1}')

	# Check if the directory exists and contains a Git repository
	if [ -d "$repo_path" ] && [ -d "$repo_path/.git" ]; then
		if [ "$LOCAL_COMMIT" == "$REMOTE_COMMIT" ]; then
			echo "Repository $repo already exists and up-to-date. Skipping clone."
		else
			# echo "Latest local commit: $LOCAL_COMMIT\n";
			# echo "Latest remote commit: $REMOTE_COMMIT\n"
			echo "Local repository of $repo is outdated. Pulling latest changes."
			git -C $repo pull
		fi
	else
		echo "Cloning repository..."
		git clone "git@github.com:anpa6841/$repo"
	fi
done < repos.txt

echo "All repositories have been cloned."

rm repos.txt

if [ $ARCHIVE -eq 1 ]; then
	echo "Creating a Zip-protected Archive..."
	zip -e -r github-projects.zip * 
fi
