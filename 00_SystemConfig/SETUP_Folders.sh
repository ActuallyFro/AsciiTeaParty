#!/bin/bash

#Source:
# https://www.ibm.com/docs/en/cloud-private/3.1.1?topic=pyci-specifying-default-docker-storage-directory-by-using-bind-mount

sudo mount --rbind /run/media/mmcblk0p1/DockerData /var/lib/docker
