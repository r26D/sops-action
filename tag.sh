#!/bin/bash

sed -i  "s/sops-action:v.*/sops-action:v${2}\"/" action.yml
git commit -a -m "${1}"
git tag -a -m "${1}" "v${2}"
git push --follow-tags

./docker_build.sh $2
