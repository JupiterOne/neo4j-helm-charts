#!/bin/sh
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile -t ryanmcafee/neo4j-helm-charts-backup:5.25.1 --build-arg IMAGE="neo4j:5.25.1-enterprise" --build-arg DISTRIBUTION="debian" --push .
