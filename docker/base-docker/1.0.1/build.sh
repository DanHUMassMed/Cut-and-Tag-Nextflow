#!/bin/bash
USER="danhumassmed"
TAG="base-conda"
VERSION="1.0.1"
SHORT_DESC="Software for Bioinformatics pipelines Linux, Miniconda, and Python"

# Build the Docker container and push to dockerhub including the README.md
echo "********************************************"
echo docker buildx build --platform linux/amd64,linux/arm64 --push -t ${USER}/${TAG}:${VERSION} .
echo ../../push_description.py -u \"${USER}\" -i ${USER}/${TAG} -r ../README.md -s \"${SHORT_DESC}\"

# Run an interactive container for debugging purposes 
echo "********************************************"
echo "docker run --rm -v /Users/dan/delme:/home/dan -it ${USER}/${TAG}:${VERSION} /bin/bash"