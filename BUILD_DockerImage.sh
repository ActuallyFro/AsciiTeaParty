#!/bin/bash

#MUST BE LOWERCASE!
imageName="atp/asciiteaparty"
VersionTag="v1_gitea1-19-0"
imageDockerfile="Dockerfile"

imageRunnerName="atp/act_runner"
VersionRunnerTag="v1_gitea1-19-0_0-1-7"
imageRunnerDockerfile="ATP_Act-Runner.dockerfile"


imageCoreName="atp/core"
VersionCoreTag="v1_gitea1-19-0_0-1-7"
imageCoreDockerfile="ATP_core.dockerfile"


isCoreBuild="FALSE"
isRunnerBuild="FALSE"

# Function to check container status
list_images() {
  sudo docker images
}

get_image_id(){
  #echo "RUNNING: sudo docker images | grep -i "$imageName" | grep -i "$VersionTag" | awk '{print \$3}'"
  sudo docker images | grep "$imageName\|$imageRunnerName\|$imageCoreName" | grep "$VersionTag\|$VersionRunnerTag\|$VersionCoreTag" | awk '{print $3}'

}

if [ "$1" == "--help" ]; then
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --build-runner    Build the $imageRunnerName:$VersionRunnerTag Docker image"
  # echo "  --build-core      Build the $imageCoreName:$VersionCoreTag Docker image"
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
  sudo docker rmi $imageRunnerName:$VersionRunnerTag
  # sudo docker rmi $imageCoreName:$VersionCoreTag

elif [ "$1" == "--remove" ]; then
  sudo docker rmi $imageName:$VersionTag
  sudo docker rmi $imageRunnerName:$VersionRunnerTag
  # sudo docker rmi $imageCoreName:$VersionCoreTag
  exit 0

elif [ "$1" == "--build-runner" ]; then
  isRunnerBuild="TRUE"
  echo "Building $imageRunnerName:$VersionRunnerTag"

# elif [ "$1" == "--build-core" ]; then
#   isCoreBuild="TRUE"
#   echo "Building $imageCoreName:$VersionCoreTag"

elif [ "$1" != "" ]; then
  echo "[ERROR] Unknown flag '$1'"
  exit 1
fi



# if [ "$isCoreBuild" == "TRUE" ]; then
#   sudo docker build -t $imageCoreName:$VersionCoreTag -f $imageCoreDockerfile .

if [ "$isRunnerBuild" == "TRUE" ]; then
  sudo docker build -t $imageRunnerName:$VersionRunnerTag -f $imageRunnerDockerfile .

else 
  echo "Building $imageName:$VersionTag"
  sudo docker build -t $imageName:$VersionTag .
fi

echo ""
echo ""
echo "Current Docker Images:"
list_images
