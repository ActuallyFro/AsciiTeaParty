#!/bin/bash

CONTAINER_NAME="AsciiTeaParty"
CONTAINER_RUNNER_NAME="ATPRunner"

imageName="atp/asciiteaparty"
VersionTag="v1_gitea1-19-0"

imageRunnerName="atp/act_runner"
VersionRunnerTag="v1_gitea1-19-0_0-1-7"
GiteaInstance="http://172.17.0.2:3000"
GiteaRunnerToken="sKYsGhOkzWiGp2HPAakAx7qCFUCCe521YOHWBFOl"

isRunnerBuild="FALSE"
isInteractive="FALSE"
isRoot="FALSE"
isRunnerRegister="FALSE"
isRunnerDaemonStart="FALSE"

check_status_running() {
    sudo docker ps | grep "$CONTAINER_NAME"
}

check_status_exists() {
    sudo docker ps -a | grep "$CONTAINER_NAME"
}


check_status_runner_running() {
    sudo docker ps | grep "$CONTAINER_RUNNER_NAME"
}

check_status_runner_exists() {
    sudo docker ps -a | grep "$CONTAINER_RUNNER_NAME"
}

print_status_running(){
    CONTAINER_RUNNING=$(check_status_running)

    if [ -z "$CONTAINER_RUNNING" ]; then
        echo "Container ($CONTAINER_NAME) is not running."
    else
        echo "Container ($CONTAINER_NAME) is running."
    fi

}

print_status_runner_running(){
    CONTAINER_RUNNING=$(check_status_runner_running)

    if [ -z "$CONTAINER_RUNNING" ]; then
        echo "Container ($CONTAINER_RUNNER_NAME) is not running."
    else
        echo "Container ($CONTAINER_RUNNER_NAME) is running."
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
  echo "  --interactive-root  Start interactive mode as root"
  echo "  --list              Show $CONTAINER_NAME containers on this machine"
  echo "  --list-all          Show ALL containers on this machine"
  echo ""
  echo "  --stop-runner       Stop the $CONTAINER_RUNNER_NAME container if it's running"
  echo "  --logs-runner       Display logs for the $CONTAINER_NAME container"
  echo "  --status-runner     Show the running status of the $CONTAINER_RUNNER_NAME container"
  echo "  --remove-runner     Remove the $CONTAINER_RUNNER_NAME Docker container if not running"
  echo "  --interact-runner   Start interactive mode for the runner"
  echo "  --runner            Start the $CONTAINER_RUNNER_NAME container"
  echo "  --runner-register   Register the $CONTAINER_RUNNER_NAME to the $CONTAINER_NAME"
  echo "  --runner-daemon     Load the $CONTAINER_RUNNER_NAME's runner daemon"
  echo ""
  echo "Example:"
  echo "  $0 --logs"
  exit 0

elif [ "$1" == "--logs" ]; then
  sudo docker logs $CONTAINER_NAME
  exit 0

elif [ "$1" == "--logs-runner" ]; then
    sudo docker logs $CONTAINER_RUNNER_NAME
    exit 0

elif [ "$1" == "--status" ]; then
    print_status_running
    exit 0

elif [ "$1" == "--status-runner" ]; then
    print_status_runner_running
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

elif [ "$1" == "--remove-runner" ]; then
    CONTAINER_RUNNER_RUNNING=$(check_status_runner_running)

    if [ -z "$CONTAINER_RUNNER_RUNNING" ]; then
        echo "Container ($CONTAINER_RUNNER_NAME) is not running..."

        CONTAINER_EXISTS=$(check_status_runner_exists)
        if [ -z "$CONTAINER_EXISTS" ]; then
            echo "Container ($CONTAINER_RUNNER_NAME) does not exist... halting"
            exit 0
        fi
        echo "Trying to remove container ($CONTAINER_RUNNER_NAME)"
        echo "$CONTAINER_RUNNER_NAME Containers List"
        print_containers
        sudo docker rm $CONTAINER_RUNNER_NAME
        echo ""
        echo "System Container List:"
        print_system_containers
    else
        echo "Container ($CONTAINER_RUNNER_NAME) is running. NOT REMOVING! --stop first!"
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

elif [ "$1" == "--stop-runner" ]; then
    CONTAINER_RUNNER_RUNNING=$(check_status_runner_running)

    if [ -z "$CONTAINER_RUNNER_RUNNING" ]; then
        echo "Container ($CONTAINER_RUNNER_NAME) is not running."
    else
        echo "Container ($CONTAINER_RUNNER_NAME) is running...stopping"
        sudo docker stop $CONTAINER_RUNNER_NAME > /dev/null
        print_status_runner_running
    fi
    exit 0

elif [ "$1" == "--interactive" ]; then
    echo "[DEBUG] Starting interactive mode"
    isInteractive="TRUE"

elif [ "$1" == "--interact-runner" ]; then
    echo "[DEBUG] Starting interactive mode for runner"
    isInteractive="TRUE"
    #The 0.1.7 image ONLY HAS root (and nobody)
    isRoot="TRUE" 
    isRunnerBuild="TRUE"

# elif [ "$1" == "--interactive-root" ]; then
#     echo "[DEBUG] Starting interactive mode"
#     isInteractive="TRUE"
#     isRoot="TRUE"

elif [ "$1" == "--list" ]; then
    print_containers
    exit 0

elif [ "$1" == "--list-all" ]; then
    print_system_containers
    exit 0

elif [ "$1" == "--runner" ]; then
    echo "Starting Gitea runner!"
    isRunnerBuild="TRUE"
    #The 0.1.7 image ONLY HAS root (and nobody)
    isRoot="TRUE"

elif [ "$1" == "--runner-register" ]; then
    echo "Registering Gitea runner!"
    isRunnerBuild="TRUE"
    isRunnerRegister="TRUE"
    #The 0.1.7 image ONLY HAS root (and nobody)
    isRoot="TRUE"

elif [ "$1" == "--runner-daemon" ]; then
    echo "Starting Gitea runner daemon!"
    isRunnerBuild="TRUE"
    isRunnerDaemon="TRUE"
    #The 0.1.7 image ONLY HAS root (and nobody)
    isRoot="TRUE"

elif [ "$1" == "--help" ]; then
    print_help
    exit 0

else
    if [ ! -z "$1" ]; then
        echo "[ERROR] Unknown flag '$1'"
        exit 1
    fi
fi

CONTAINER_EXISTS=$(check_status_exists)
CONTAINER_RUNNING=$(check_status_running)

CONTAINER_RUNNER_EXISTS=$(check_status_runner_exists)
CONTAINER_RUNNER_RUNNING=$(check_status_runner_running)

# if NOT runner
if [ "$isRunnerBuild" == "FALSE" ]; then
    if [ -z "$CONTAINER_EXISTS" ]; then
        echo "Starting new container..."

        sudo docker run -d --name $CONTAINER_NAME --user 1000:1000 -p 3000:3000 -p 222:22 $imageName:$VersionTag

        #WHAT THE HELL DOCKER...
        sudo docker exec -u root -d $CONTAINER_NAME chown -R git:git /data
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
else
    if [ -z "$CONTAINER_RUNNER_EXISTS" ]; then
        echo "Starting new container..."   
        sudo docker run -e GITEA_INSTANCE_URL=$GiteaInstance -e GITEA_RUNNER_REGISTRATION_TOKEN=$GiteaRunnerToken -v /var/run/docker.sock:/var/run/docker.sock -d --name $CONTAINER_RUNNER_NAME $imageRunnerName:$VersionRunnerTag

    elif [ -z "$CONTAINER_RUNNER_RUNNING" ]; then
        if [ "$isRunnerRegister" == "TRUE" ]; then
            echo "HALTING register -- start the runner!"
            exit 0
        fi

        echo "Starting existing container..."

        sudo docker start $CONTAINER_RUNNER_NAME > /dev/null
        print_status_running
        sudo docker logs $CONTAINER_RUNNER_NAME     

    else
        if [ "$isInteractive" == "FALSE" ]; then
            echo "Container is already running."

            if [ "$isRunnerRegister" == "TRUE" ]; then
                echo "Registering runner..."
                echo "Running: sudo docker exec -u root -d $CONTAINER_RUNNER_NAME /usr/local/bin/act_runner register --no-interactive --instance $GiteaInstance --token $GiteaRunnerToken"

                sudo docker exec -u root -d $CONTAINER_RUNNER_NAME /usr/local/bin/act_runner register --no-interactive --instance $GiteaInstance --token $GiteaRunnerToken
            
            elif [ "$isRunnerDaemon" == "TRUE" ]; then
                echo "Starting runner daemon..."
                echo "Running: sudo docker exec -u root -d $CONTAINER_RUNNER_NAME /usr/local/bin/act_runner daemon"

                sudo docker exec -u root -d $CONTAINER_RUNNER_NAME /usr/local/bin/act_runner daemon

            fi
        fi

    fi

    if [ "$isInteractive" == "TRUE" ]; then
        if [ "$isRoot" == "TRUE" ]; then
            sudo docker exec -it --user root $CONTAINER_RUNNER_NAME /bin/bash
        # else
        #     sudo docker exec -it $CONTAINER_RUNNER_NAME /bin/bash
        fi
    fi
fi


#Run with data volume on host, idea:
#mkdir gitea-data
#docker run -d -p 222:22 -p 3000:3000 -v ./gitea-data:/app/gitea/data --name $CONTAINER_NAME $imageName:$VersionTag
