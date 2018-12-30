Installation
============
This instruction will be useful to create a Kubernetes Cluster.

Option 1. Locally with Minikube
-------------------------------

Minikube is a Kubernetes environment in a virtual machine. It is not meant for production but to test Kubernetes or
for developer environments. Also must be installed kubectl, the command line interface for Kubernetes.

Please see how install [Minikube](https://github.com/kubernetes/minikube/releases) and [kubectl](https://kubernetes.io/docs/tasks/kubectl/install/) before continuing.

- Create a cluster set memory to 4.096 MB - which should be enough for most experiments:
```
$ minikube start --memory=4096
Starting local Kubernetes v1.7.5 cluster...
Starting VM...
Getting VM IP address...
Moving files into cluster...
Setting up certs...
Connecting to cluster...
Setting up kubeconfig...
Starting cluster components...
Kubectl is now configured to use the cluster.
```
You can type following commands to stop minikube `$ minikube stop` or delete cluster `$ minikube delete`

Option 2. On Cloud with kops and AWS
------------------------------------
See [How to create cluster on AWS](HOW-TO-AWS.md).

Kubernetes Managed
==================
- You can get a list of the services:
```
$ kubectl describe services
...
Name:			frontend-api-lb
Namespace:		default
Labels:			run=order
Annotations:		<none>
Selector:		run=order
Type:			LoadBalancer
IP:			10.0.0.21
Port:			<unset>	8080/TCP
NodePort:		<unset>	30616/TCP
Endpoints:		172.17.0.7:8080
Session Affinity:	None
Events:			<none>
```
- You can also get a list of the pods:
```
$ kubectl get pods
NAME                                READY     STATUS    RESTARTS   AGE
frontend-3412280829-k5z5p           1/1       Running   0          2m
frontend-269679894-60dr0            1/1       Running   0          2m
frontend-api-1984516559-1ffjk       1/1       Running   0          2m
frontend-api-859915717-f0sxg        1/1       Running   0          2m
microservice-2204540131-nks5s       1/1       Running   0          2m
```
- ...and you can see the logs of a pod:
```
$ kubectl logs frontend-api-1984516559-1ffjk 

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::        (v1.4.5.RELEASE)
...
2018-12-30 18:11:06.128  INFO 7 --- [           main] o.s.j.e.a.AnnotationMBeanExporter        : Registering beans for JMX exposure on startup
2018-12-30 18:11:06.158  INFO 7 --- [           main] o.s.c.support.DefaultLifecycleProcessor  : Starting beans in phase 0
2018-12-30 18:11:06.746  INFO 7 --- [           main] s.b.c.e.t.TomcatEmbeddedServletContainer : Tomcat started on port(s): 8080 (http)
2018-12-30 18:11:06.803  INFO 7 --- [           main] c.e.frontend.api.App                     : Started App in 3.532 seconds (JVM running for 4.296)
...
```
- You can also run commands in a pod:
```
$ kubectl exec frontend-api-1984516559-1ffjk  /bin/ls
bin
dev
etc
home
lib
lib64
media
frontend-api-0.0.1-SNAPSHOT.jar
mnt
proc
root
run
sbin
srv
sys
tmp
usr
var
```
- You can even open a shell in a pod:
```
$ kubectl exec frontend-api-1984516559-1ffjk -it /bin/sh
/ # ls
bin                                                      proc
dev                                                      root
etc                                                      run
home                                                     sbin
lib                                                      srv
lib64                                                    sys
media                                                    tmp
frontend-api-0.0.1-SNAPSHOT.jar                          usr
mnt                                                      var
/ # 
```
- To remove all services and deployments run `kubernetes-remove.sh`:
```
$ ./kubernetes-remove.sh 
```
