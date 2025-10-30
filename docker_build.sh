#!/bin/bash

#Push to github
docker build -t "ghcr.io/r26d/sops-action/sops-action:v${1}" .
docker push "ghcr.io/r26d/sops-action/sops-action:v${1}"

##Push to docker
docker build -t "delmendo/sops-action:v${1}" .
docker build -t delmendo/sops-action:latest .
docker push delmendo/sops-action:latest
docker push "delmendo/sops-action:v${1}"
