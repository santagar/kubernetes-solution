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
SERVICE=$SOLUTION-frontend;

docker pull $DOCKER_ID/$SERVICE:$TAGNAME
docker run -d -p 80:80 $DOCKER_ID/$SERVICE:$TAGNAME

