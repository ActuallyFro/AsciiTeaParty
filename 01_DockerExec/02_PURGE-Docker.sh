#!/bin/bash
sudo docker stop $(docker ps -a -q)
sudo docker system prune -a --force
#sudo docker rmi $(docker images -a -q)
sudo docker rmi $(sudo docker images -q)
