#!/bin/bash
USER="danhumassmed"
TAG="base-conda"
VERSION="1.0.0"
SHORT_DESC="Software for Bioinformatics pipelines Linux, Miniconda, and Python"

echo "********************************************"

echo ../../push_description.py -u \"${USER}\" -i ${USER}/${TAG} -r ../README.md -s \"${SHORT_DESC}\"
echo docker buildx build --platform linux/amd64,linux/arm64 --push -t ${USER}/${TAG}:${VERSION} .

echo "********************************************"
echo docker build -t ${USER}/${TAG}:${VERSION} .
echo docker push ${USER}/${TAG}:${VERSION}
echo "********************************************"
echo docker run -t ${USER}/${TAG}:${VERSION} ${TAG} --version

