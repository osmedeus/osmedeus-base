#!/bin/bash

docker build --no-cache -t j3ssie/osmedeus:latest .
docker push j3ssie/osmedeus:latest


docker buildx create --use --name arm-builder
docker buildx build --no-cache --platform linux/arm64 --builder arm-builder -t j3ssie/osmedeus:latest .
docker buildx build --platform linux/arm64 --builder arm-builder -t j3ssie/osmedeus:latest-arm . --push

