#!/bin/bash

MODE=${MODE:-production}
BRANCH=${BRANCH:-master}

#Build
docker build -t twigjs-rhino . --build-arg MODE=${MODE} --build-arg BRANCH=${BRANCH}
docker rm  twigjs-rhino
docker create --name twigjs-rhino twigjs-rhino
docker cp twigjs-rhino:/twig.js/dist .

#Cleanup
docker rm  twigjs-rhino
docker rmi -f twigjs-rhino
