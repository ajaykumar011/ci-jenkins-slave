#!/bin/bash
container="jenkins-docker-agent"
image="jenkins-docker-agent"

jenkinsDiscovery="http://159.65.156.108:8080"
jenkinsUrl="http://159.65.156.108:8080"
secretToken="longsecretalphanumericaltokenfromjenkins"

docker build --no-cache -t $image https://raw.githubusercontent.com/AckeeDevOps/jenkins-android-docker-slave/master/Dockerfile
docker stop $container
docker rm $container
docker -- run --restart=always -d \
  --name $container \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $image \
  -headless -tunnel $jenkinsDiscovery -url $jenkinsUrl $secretToken $container
