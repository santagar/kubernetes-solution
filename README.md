Kubernetes Solution
===================
This project creates a demo polyglot system in Docker containers, the application consists of three microservices. Each has one specific functionality:
- `Frontend` a Nginx web server that serves our ReactJS static files.
- `Frontend-api` a Java Web Application that handles requests from the frontend.
- `Microservice` a Python application that performs Sentiment Analysis.

In this demo, the application is not too important because the real motivation will be expose how to run any microservice architecture solution with [Kubernetes](https://kubernetes.io/).

Therefore, let's start:
- Running locally the Microservice based solution on your computer.
- Deploying a Microservice based solution into a Kubernetes Managed Cluster.

Running Locally
================
To test locally the solution we could to start up all three microservices. 

Run instructions under **Starting Locally** section on each `README.md` by microservice.

Deploying into Kubernetes
=========================
Previous running or any basic Docker Container architecture is not scalable or resilient and Kubernetes resolves these issues. 

In continuation we will migrate our services toward the end result as shown in following figure, where the Containers are orchestrated by Kubernetes.

![](static/k8s-diagram.png?raw=true)

Step 1. Kubernetes Cluster
--------------------------

Firstly we need to create a cluster and we can perform it:

   1. **Locally**, with Minikube
   2. **On cloud**, using kops and AWS

See [How to run](HOW-TO-RUN.md) to proceed.

Once cluster is running next step will be upload the microservices Docker images.


Step 2. Delivery
----------------

Now, we're going to create Docker images and upload them to a Container Registry:

* We're going to use public [Docker Hub](https://docs.docker.com/docker-hub/), so we need to create an account.

* Log in to your Docker Hub account by entering `docker login` on the command
line.

* Set the environment variable `DOCKER_ID` to the name of the account.

* Run `docker-push.sh` in each micro-service directory. It builds the images and uploads them to the
Docker Hub using your account. Of course uploading the images takes
some time:

```
$ export DOCKER_ACCOUNT=santagar

$ echo $DOCKER_ACCOUNT
santagar

$ ./docker-push.sh 
...
Removing intermediate container 36e9b0c2ac0e
Successfully built b76261d1e4ee
Successfully tagged kubernetes-solution-frontend:latest
The push refers to a repository [docker.io/santagar/kubernetes-solution-frontend]
f4ffcb9c643d: Pushed 
14c5bfa09694: Mounted from santagar/kubernetes-solution-frontend
41a5c76632fc: Mounted from santagar/kubernetes-solution-frontend
5bef08742407: Mounted from santagar/kubernetes-solution-frontend 
latest: digest: sha256:36d87ea5c8628da9a6677c1eafb9009c8f99310f5376872e7b9a1edace37d1a0 size: 1163
```

Step 3. Deployment
------------------
This command takes the description of the
services and deployments from the file `deployment.yaml` and
creates them if they do not already exist. 

Use only for a *complete deployment* and go ahead *step-by-step* for a better understanding Kubernetes capabilities.
```
$ kubectl apply -f deployment.yaml
```

Step-by-step Deployment:

## Frontend-api
* Apply Rolling Update Deployment:
```
$ kubectl apply -f frontend-api/k8s/deployment.yaml --record
deployment "frontend-api" created
```

* Create Load Balancer Service:
```
$ kubectl create -f frontend-api/k8s/load-balancer.yaml
service "frontend-api-lb" created
```
You can check out the state of the service by executing the following command:

```
$ kubectl get svc
NAME               TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
frontend-api-lb    LoadBalancer   10.101.244.40   <pending>     80:30708/TCP   7m
```

The External-IP is in pending state (and don’t wait, as it’s not going to change). This is only because we are using Minikube. If we would have executed this in a cloud provider, we would get a Public IP, which makes our services worldwide accessible.
Despite that, Minikube doesn’t let us hanging it provides a useful command for local debugging, execute the following command:

```
$ minikube service frontend-api-lb
Opening kubernetes service default/frontend-api-lb in default browser...
```

#### Scaling Deployment

You can scale a Deployment by using the following command:
```
$ kubectl scale frontend-api --replicas=5
frontend-api scaled
```

Assuming [horizontal pod autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough) is enabled in your cluster, you can setup an autoscaler for your Deployment and choose the minimum and maximum number of Pods you want to run based on the CPU utilization of your existing Pods.

**Example:**  HPA will increase and decrease the number of replicas (via the deployment) to maintain an average CPU utilization across all Pods of 50%
```
$ kubectl autoscale deployment frontend-api --min=2 --max=5 --cpu-percent=50
frontend-api autoscaled
```
We may check the current status of autoscaler by running:
```
$ kubectl get hpa
NAME           REFERENCE                       TARGET    MINPODS   MAXPODS   REPLICAS   AGE
frontend-api   Deployment/frontend-api/scale   0% / 50%  2         5         1          18s
```

## Frontend
When we built the container image was pointing to our Frontend-api in http://localhost:8080/sentiment. But now we need to update it to point to the IP Address of the Frontend-api Load Balancer.

```
$ minikube service list
|-------------|----------------------|-----------------------------|
|  NAMESPACE  |         NAME         |             URL             |
|-------------|----------------------|-----------------------------|
| default     | kubernetes           | No node port                |
| default     | frontend-api-lb      | http://192.168.99.100:31691 |
| kube-system | kube-dns             | No node port                |
| kube-system | kubernetes-dashboard | http://192.168.99.100:30000 |
|-------------|----------------------|-----------------------------|
```
So use the **frontend-api-lb** IP in the file `frontend/src/Config.js` and execute `./docker-push` to build and push image.

Once image was shipped we can continue with Deployment.

* Create Load Balancer Service:
```
$ kubectl create -f frontend/k8s/load-balancer.yaml
service "frontend-lb" created
```

Public endpoint can be retrieves with `minikube service list`.

* Apply Rolling Update Deployment:
```
$ kubectl apply -f frontend/k8s/deployment.yaml --record
deployment "frontend" created
```

As always let’s verify that everything went as planned:
```
$ kubectl get pods
NAME                           READY     STATUS    RESTARTS   AGE
frontend-5d5987746c-ml6m4      1/1       Running   0          1m
frontend-5d5987746c-mzsgg      1/1       Running   0          1m
```

Deleting one pod `kubectl delete pod <pod-name>` made the Deployment notice that the current state (1 pod running) is different from the desired state (2 pods running) so it started another pod.

* Apply Rolling Update Deployment (minor changes):
```
$ kubectl apply -f frontend/k8s/deployment-green.yaml --record
deployment "frontend" configured
```

#### Rolling Back Deployment

In case we find a bug, we can review history deployments:
```
$ kubectl rollout history deployment frontend
deployments "frontend"
REVISION  CHANGE-CAUSE
1         <none>         
2         kubectl.exe apply --filename=frontend-deployment-green.yaml --record=true
```

and perform rollback to last success version:
```
$ kubectl rollout undo deployment frontend --to-revision=1
deployment "frontend" rolled back
```

## Microservice
* Apply Load Balancer Deployment:
```
$ kubectl apply -f microservice/k8s/deployment.yaml --record
deployment "microservice" created
```

* Below service acts as an entry point (internal) that we will use in the Frontend-api pods, so in this case we don't use Load Balancer Service and only we need configuration with Kube-DNS:
```
$ kubectl apply -f microservice/k8s/service.yaml
service "microservice" created
```

Summary
=======
What we covered in this series:
 * Building / Packaging / Running polyglot applications
 * Docker Containers; how to define and build them using Dockerfiles
 * Container Registries; we used the Docker Hub as a repository for our containers
 * We covered the most important parts of Kubernetes:
    * Pods
    * Services
    * Deployments
    * HPA (Horizontal Pod Autoscaler)
 * Zero-Downtime deployments
 * Scalable / Autoscalable apps
 * Migrate the whole micro-service application to a Kubernetes Cluster
