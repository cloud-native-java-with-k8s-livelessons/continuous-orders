#!/usr/bin/env bash
set -e
HERE=$(cd $(dirname $0 ) && pwd )
NS=cnj
APP_NAME=customers
MANIFESTS_DIR=$HERE/k8s/manifests
IMAGE_NAME=gcr.io/bootiful/${APP_NAME}:latest
mvn -DskipTests=true clean package spring-boot:build-image -Dspring-boot.build-image.imageName=${IMAGE_NAME}
docker push $IMAGE_NAME
mkdir -p $MANIFESTS_DIR
kubectl create ns $NS  -o yaml > $MANIFESTS_DIR/namespace.yaml
kubectl -n $NS create deployment  --image=$IMAGE_NAME $APP_NAME -o yaml > $MANIFESTS_DIR/deployment.yaml
kubectl -n $NS expose deployment $APP_NAME --port=8080 -o yaml > $MANIFESTS_DIR/service.yaml
sleep 5
kubectl -n $NS port-forward deployment/$APP_NAME 8080:8080  &
curl -s localhost:8080/actuator/health/liveness | jq
#kubectl logs -n cnj deployments/$APP_NAME
