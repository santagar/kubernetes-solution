#!/bin/sh
if [ -z "$DOCKER_ID" ]; then
    DOCKER_ID=santagar
fi;
if [ -z "$SOLUTION" ]; then
    SOLUTION=kubernetes-solution
fi;
if [ -z "$TAGNAME" ]; then
    TAGNAME=latest
fi;
SERVICE=$SOLUTION-frontend-api;

docker pull $DOCKER_ID/$SERVICE:$TAGNAME
docker run -d -p 8080:8080 -e SERVICE_URL='http://localhost:5000' $DOCKER_ID/$SERVICE:$TAGNAME
