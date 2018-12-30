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

docker build -t $SERVICE:$TAGNAME .
docker tag $SERVICE:$TAGNAME $DOCKER_ID/$SERVICE:$TAGNAME
docker push $DOCKER_ID/$SERVICE:$TAGNAME
