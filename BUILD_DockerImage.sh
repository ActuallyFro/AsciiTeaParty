#!/bin/bash

#MUST BE LOWERCASE!
imageName="asciiteaparty"
VersionTag="v1_gitea1-19-0"

# Function to check container status
list_images() {
  sudo docker images
}

get_image_id(){
  #echo "RUNNING: sudo docker images | grep -i "$imageName" | grep -i "$VersionTag" | awk '{print \$3}'"
  sudo docker images | grep "$imageName" | grep "$VersionTag" | awk '{print $3}'
}

if [ "$1" == "--help" ]; then
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --list            Show Docker Images on this machine"
  echo "  --rebuild         Remove and rebuild the $imageName:$VersionTag Docker image"
  echo "  --remove          Remove the $imageName:$VersionTag Docker image"
  echo "  --help            Print this help message and exit"
  echo ""
  echo "Example:"
  echo "  $0 --list"
  exit 0

# Check if the --list flag is provided
elif [ "$1" == "--list" ]; then
  list_images
  exit 0

# Check if the --rebuild flag is provided with a container name
elif [ "$1" == "--rebuild" ]; then
  # imageID=$(get_image_id)
  # sudo docker rm $imageID
  sudo docker rmi $imageName:$VersionTag

elif [ "$1" == "--remove" ]; then
  sudo docker rmi $imageName:$VersionTag
  exit 0

elif [ "$1" != "" ]; then
  echo "[ERROR] Unknown flag '$1'"
  exit 1
fi

sudo docker build -t $imageName:$VersionTag .
echo ""
echo ""
echo "Current Docker Images:"
list_images
