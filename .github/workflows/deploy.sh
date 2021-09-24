#!/usr/bin/env bash
set -e
HERE=$(cd $(dirname $0 ) && pwd )
NS=cnj
APP_NAME=customers
MANIFESTS_DIR=$HERE/k8s/manifests
IMAGE_NAME=gcr.io/bootiful/${APP_NAME}:latest
cd $HERE/../..
mvn -DskipTests=true clean package spring-boot:build-image -Dspring-boot.build-image.imageName=${IMAGE_NAME}
docker push $IMAGE_NAME
mkdir -p $MANIFESTS_DIR
kubectl apply -f k8s/
sleep 5
kubectl -n $NS port-forward deployment/$APP_NAME 8080:8080  &
curl -s localhost:8080/actuator/health/liveness | jq

