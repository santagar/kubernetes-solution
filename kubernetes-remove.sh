#!/bin/sh
kubectl delete service frontend-lb frontend-api-lb microservice
kubectl delete deployments frontend frontend-api microservice
