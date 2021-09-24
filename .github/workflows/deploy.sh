#!/usr/bin/env bash
set -e
HERE=$(cd $(dirname $0 ) && pwd )
NS=cnj
APP_NAME=customers
MANIFESTS_DIR=$HERE/k8s/manifests
IMAGE_NAME=gcr.io/bootiful/${APP_NAME}:latest
cd $HERE/../..
mvn clean package spring-boot:build-image -Dspring-boot.build-image.imageName=${IMAGE_NAME}
docker push $IMAGE_NAME
mkdir -p $MANIFESTS_DIR
kubectl apply -f k8s/

curl -H "Accept: application/vnd.github.everest-preview+json" -H "Authorization: token ${GH_PAT}" \
 --request POST  --data '{"event_type": "update-event"}' https://api.github.com/repos/cloud-native-java-with-k8s-livelessons/continuous-orders-dependent/dispatches
echo "triggered an update-event"

