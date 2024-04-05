#!/bin/bash

docker build --platform linux/amd64 --no-cache -t j3ssie/osmedeus:latest .
docker push j3ssie/osmedeus:latest

docker build --platform linux/arm64 --no-cache -t j3ssie/osmedeus:latest-arm .
docker push j3ssie/osmedeus:latest-arm

# docker buildx create --use --name arm-builder
# docker buildx build --no-cache --platform linux/arm64 --builder arm-builder -t j3ssie/osmedeus:latest .
# docker buildx build --platform linux/arm64 --builder arm-builder -t j3ssie/osmedeus:latest-arm . --push

