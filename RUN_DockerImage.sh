#!/bin/bash

CONTAINER_NAME="AsciiTeaParty"

imageName="asciiteaparty"
VersionTag="v1_gitea1-19-0"


# Function to check container status
check_status() {
    CONTAINER_RUNNING=$(sudo docker ps | grep "^${CONTAINER_NAME}$")
    if [ -z "$CONTAINER_RUNNING" ]; then
        echo "Container ($CONTAINER_NAME) is not running."
    else
        echo "Container ($CONTAINER_NAME) is running."
    fi
}

# Print help, then quit
if [ "$1" == "--help" ]; then
  echo "--logs - Reports running status"
  echo "--status - Shows logs for a container"
  echo "--remove - Removes the $CONTAINER_NAME Docker container"
  echo "--help - Prints this message"
  exit 0
fi

if [ "$1" == "--logs" ]; then
  sudo docker logs $CONTAINER_NAME
  exit 0
fi

# Check if the --status flag is provided
if [ "$1" == "--status" ]; then
    check_status
    exit 0
fi

# Remove image?
if [ "$1" == "--remove" ]; then
    echo "Original Containers List"
    sudo docker rm $CONTAINER_NAME
    echo ""
    echo "Removed Container List"
    sudo docker ps -a
    exit 0
fi


# Check if the container exists
CONTAINER_EXISTS=$(sudo docker ps -a | grep "^${CONTAINER_NAME}$")

if [ -z "$CONTAINER_EXISTS" ]; then
    # If the container does not exist, create and run it
    echo "Starting new container..."
    sudo docker run -d --name $CONTAINER_NAME -p 3000:3000 -p 22:22 $imageName:$VersionTag

elif [ -z "$CONTAINER_RUNNING" ]; then
    # If the container exists but is not running, start it
    echo "Starting existing container..."
    sudo docker start $CONTAINER_NAME
else
    # If the container is already running, show a message
    echo "Container is already running."
fi
