#!/bin/bash

CONTAINER_NAME="AsciiTeaParty"

imageName="asciiteaparty"
VersionTag="v1_gitea1-19-0"

isInteractive="FALSE"

check_status_running() {
    sudo docker ps | grep "$CONTAINER_NAME"
}

check_status_exists() {
    sudo docker ps -a | grep "$CONTAINER_NAME"
}

print_status_running(){
    CONTAINER_RUNNING=$(check_status_running)

    if [ -z "$CONTAINER_RUNNING" ]; then
        echo "Container ($CONTAINER_NAME) is not running."
    else
        echo "Container ($CONTAINER_NAME) is running."
    fi

}

if [ "$1" == "--help" ]; then
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --logs         Display logs for the $CONTAINER_NAME container"
  echo "  --status       Show the running status of the $CONTAINER_NAME container"
  echo "  --remove       Remove the $CONTAINER_NAME Docker container if not running"
  echo "  --help         Print this help message and exit"
  echo "  --stop         Stop the $CONTAINER_NAME container if it's running"
  echo "  --interactive  Start interactive mode"
  echo ""
  echo "Example:"
  echo "  $0 --logs"
  exit 0

elif [ "$1" == "--logs" ]; then
  sudo docker logs $CONTAINER_NAME
  exit 0

elif [ "$1" == "--status" ]; then
    print_status_running
    exit 0

elif [ "$1" == "--remove" ]; then
    CONTAINER_RUNNING=$(check_status_running)

    if [ -z "$CONTAINER_RUNNING" ]; then
        echo "Container ($CONTAINER_NAME) is not running... removing"
        echo "Original Containers List"
        sudo docker rm $CONTAINER_NAME
        echo ""
        echo "Removed Container List"
        sudo docker ps -a
    else
        echo "Container ($CONTAINER_NAME) is running. NOT REMOVING! --stop first!"
    fi
    
    exit 0

elif [ "$1" == "--stop" ]; then
    CONTAINER_RUNNING=$(check_status_running)

    if [ -z "$CONTAINER_RUNNING" ]; then
        echo "Container ($CONTAINER_NAME) is not running."
    else
        echo "Container ($CONTAINER_NAME) is running...stopping"
        sudo docker stop $CONTAINER_NAME
        print_status_running
    fi
    exit 0

elif [ "$1" == "--interactive" ]; then
    echo "[DEBUG] Starting interactive mode"
    isInteractive="TRUE"

else
    echo "[ERROR] Unknown flag '$1'"
    exit 1
fi

CONTAINER_EXISTS=$(check_status_exists)
CONTAINER_RUNNING=$(check_status_running)
if [ -z "$CONTAINER_EXISTS" ]; then
    echo "Starting new container..."

    if [ "$isInteractive" == "TRUE" ]; then
        sudo docker run -it --name $CONTAINER_NAME --user 1000:1000 -p 3000:3000 -p 222:22 $imageName:$VersionTag /bin/bash
    else
        sudo docker run -d --name $CONTAINER_NAME --user 1000:1000 -p 3000:3000 -p 222:22 $imageName:$VersionTag
    fi

elif [ -z "$CONTAINER_RUNNING" ]; then
    echo "Starting existing container..."

    sudo docker start $CONTAINER_NAME

else
    if [ "$isInteractive" == "FALSE" ]; then
        echo "Container is already running."
    fi
fi

if [ "$isInteractive" == "TRUE" ]; then
    sudo docker exec -it $CONTAINER_NAME /bin/bash
fi

