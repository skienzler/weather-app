#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

function config() {

    # the image we want to deploy
    IMAGE=simonkienzler/weather-app

    # the image tag that is new
    TAG=$PULL_BASE_SHA

    # url of the deployment repo
    REPO=https://$GIT_USER:$GIT_TOKEN@github.com/skienzler/weather-app-deployment.git

    # location of the cloned repo
    REPO_DIR=deployment
}

function docker_tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}

function check_env_vars() {
    if [ -z "${PULL_BASE_SHA}" ]
    then
        echo "Environment variable PULL_BASE_SHA is not set. Exiting."
        exit 1
    else
        config
    fi
}

function wait_for_image() {
    IMAGE_FOUND=false
    COUNTER=0
    while [ $IMAGE_FOUND != true ]
    do
        COUNTER=$((COUNTER + 1))
        if [ $COUNTER -gt 10 ]
        then
            echo "Image $IMAGE:$TAG still doesn't exist. Exiting."
            exit 2
        fi
        if docker_tag_exists $IMAGE $TAG;
        then
            IMAGE_FOUND=true
        else 
            echo "Image $IMAGE:$TAG not found. Waiting 5 seconds ($COUNTER)"
            sleep 5
        fi
    done

    echo "Image $IMAGE:$TAG found"
}

function clone_deployment_repo() {
    git clone $REPO $REPO_DIR
    cd $REPO_DIR
}

function configure_git_user() {
    git config user.name "${GIT_USER}"
    git config user.email "${GIT_EMAIL}"
}

function alter_yaml_file() {
    echo "Now altering YAML file"
    ~/yq w -i deployment.yaml spec.template.spec.containers[0].image $IMAGE:$TAG
}

function commit_and_push() {
    git commit -am "Update deployment with image ${IMAGE}:${TAG}"
    git config credential.helper store
    git push
}

# here we go:
check_env_vars
wait_for_image
clone_deployment_repo
configure_git_user
alter_yaml_file
commit_and_push

exit 0