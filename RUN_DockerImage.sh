#!/bin/bash

CONTAINER_NAME="AsciiTeaParty"


#!/bin/bash

CONTAINER_NAME="gitea"

# Function to check container status
check_status() {
    CONTAINER_RUNNING=$(sudo docker ps --format '{{.Names}}' | grep "^${CONTAINER_NAME}$")
    if [ -z "$CONTAINER_RUNNING" ]; then
        echo "Container is not running."
    else
        echo "Container is running."
    fi
}

# Check if the --status flag is provided
if [ "$1" == "--status" ]; then
    check_status
    exit 0
fi

# Check if the container exists
CONTAINER_EXISTS=$(sudo docker ps -a --format '{{.Names}}' | grep "^${CONTAINER_NAME}$")

# Check if the container is running
CONTAINER_RUNNING=$(sudo docker ps --format '{{.Names}}' | grep "^${CONTAINER_NAME}$")

if [ -z "$CONTAINER_EXISTS" ]; then
    # If the container does not exist, create and run it
    echo "Starting new container..."
    sudo docker run -d --name $CONTAINER_NAME -p 3000:3000 -p 22:22 asciiteaparty:v1_gitea1-19-0
elif [ -z "$CONTAINER_RUNNING" ]; then
    # If the container exists but is not running, start it
    echo "Starting existing container..."
    sudo docker start $CONTAINER_NAME
else
    # If the container is already running, show a message
    echo "Container is already running."
fi
