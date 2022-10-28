#!/usr/bin/env bash
readonly PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$0")")")"
readonly RELEASE_NAME=volume-manual

cleanup() {
    pushd "${PROJECT_ROOT}" > /dev/null || exit
    helm uninstall ${RELEASE_NAME} ${RELEASE_NAME}-disk --wait --timeout 1m
    gcloud compute disks delete ${RELEASE_NAME} --quiet
}

cleanup
