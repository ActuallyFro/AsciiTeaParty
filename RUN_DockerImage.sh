#!/bin/bash

CONTAINER_NAME="AsciiTeaParty"

imageName="asciiteaparty"
VersionTag="v1_gitea1-19-0"

isInteractive="FALSE"
isRoot="FALSE"

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

print_system_containers(){
    sudo docker ps -a 
}

print_containers(){
    print_system_containers | grep "$CONTAINER_NAME"
}

if [ "$1" == "--help" ]; then
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --logs              Display logs for the $CONTAINER_NAME container"
  echo "  --status            Show the running status of the $CONTAINER_NAME container"
  echo "  --remove            Remove the $CONTAINER_NAME Docker container if not running"
  echo "  --help              Print this help message and exit"
  echo "  --stop              Stop the $CONTAINER_NAME container if it's running"
  echo "  --interactive       Start interactive mode"
  echo "  --interactive-root  Start interactive mode"
  echo "  --list              Show $CONTAINER_NAME containers on this machine"
  echo "  --list-all          Show ALL containers on this machine"
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
        echo "Container ($CONTAINER_NAME) is not running..."

        CONTAINER_EXISTS=$(check_status_exists)
        if [ -z "$CONTAINER_EXISTS" ]; then
            echo "Container ($CONTAINER_NAME) does not exist... halting"
            exit 0
        fi
        echo "Trying to remove container ($CONTAINER_NAME)"
        echo "$CONTAINER_NAME Containers List"
        print_containers
        sudo docker rm $CONTAINER_NAME
        echo ""
        echo "System Container List:"
        print_system_containers
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
        sudo docker stop $CONTAINER_NAME > /dev/null
        print_status_running
    fi
    exit 0

elif [ "$1" == "--interactive" ]; then
    echo "[DEBUG] Starting interactive mode"
    isInteractive="TRUE"

elif [ "$1" == "--interactive-root" ]; then
    echo "[DEBUG] Starting interactive mode"
    isInteractive="TRUE"
    isRoot="TRUE"

elif [ "$1" == "--list" ]; then
    print_containers
    exit 0

elif [ "$1" == "--list-all" ]; then
    print_system_containers
    exit 0

else
    if [ ! -z "$1" ]; then
        echo "[ERROR] Unknown flag '$1'"
        exit 1
    fi
fi

CONTAINER_EXISTS=$(check_status_exists)
CONTAINER_RUNNING=$(check_status_running)
if [ -z "$CONTAINER_EXISTS" ]; then
    echo "Starting new container..."

    sudo docker run -d --name $CONTAINER_NAME --user 1000:1000 -p 3000:3000 -p 222:22 $imageName:$VersionTag

    #WHAT THE HELL DOCKER...
    sudo docker exec -d $CONTAINER_NAME --user root chown -R git:git /data
    #The /data folder will NOT accept permission changes while the image is being built.

elif [ -z "$CONTAINER_RUNNING" ]; then
    echo "Starting existing container..."

    sudo docker start $CONTAINER_NAME > /dev/null
    print_status_running

else
    if [ "$isInteractive" == "FALSE" ]; then
        echo "Container is already running."
    fi
fi

if [ "$isInteractive" == "TRUE" ]; then
    if [ "$isRoot" == "TRUE" ]; then
        sudo docker exec -it --user root $CONTAINER_NAME /bin/bash
    else
        sudo docker exec -it $CONTAINER_NAME /bin/bash
    fi
fi

#Run with data volume on host, idea:
#mkdir gitea-data
#docker run -d -p 222:22 -p 3000:3000 -v ./gitea-data:/app/gitea/data --name $CONTAINER_NAME $imageName:$VersionTag
