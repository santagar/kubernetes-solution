How to Create a Kubernetes Cluster on AWS
=========================================

This is a step-by-step guide how to run the example:

Steps to Follow
---------------
- First we need an AWS account and access keys to start with
- Install AWS CLI by following its 
  [official installation guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).
```
# OSX using Homebrew
$ brew install awscli

# Linux
$ pip install awscli --upgrade --user
```
- Install kops by following its [official installation guide](https://github.com/kubernetes/kops#installing):
```
# OSX using Homebrew
$ brew install kops

# Linux
$ curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
$ chmod +x kops-linux-amd64
$ sudo mv kops-linux-amd64 /usr/local/bin/kops
```
- Create a new IAM user or use an existing IAM user and grant following permissions:
```
AmazonEC2FullAccess
AmazonRoute53FullAccess
AmazonS3FullAccess
AmazonVPCFullAccess
```
- Configure the AWS CLI by providing the Access Key, Secret Access Key and the AWS region that you want the Kubernetes cluster to be installed:
```
$ aws configure
AWS Access Key ID [None]: AccessKeyValue
AWS Secret Access Key [None]: SecretAccessKeyValue
Default region name [None]: eu-west-1
Default output format [None]:
```
- Create an AWS S3 bucket for kops to persist its state:
```
$ aws s3api create-bucket \
    --bucket kops-state-config \
    --create-bucket-configuration LocationConstraint=eu-west-1
```
- Enable versioning for the above S3 bucket:
```
$ aws s3api put-bucket-versioning \
    --bucket kops-state-config \
    --versioning-configuration Status=Enabled
```
- Provide a name for the Kubernetes cluster and set the S3 bucket URL in the following environment variables:
```
$ export KOPS_CLUSTER_NAME=kubernetes-solution-cluster.k8s.local
$ export KOPS_STATE_STORE=s3://kops-state-config
```

If the Kubernetes cluster name ends with **k8s.local**, Kubernetes will create a gossip-based cluster.

- Create a Kubernetes cluster definition using kops by providing the required node count, node size, and AWS zones. The node size or rather the [EC2 instance type](https://aws.amazon.com/ec2/instance-types/) would need to be decided according to the workload that you are planning to run on the Kubernetes cluster:
```
$ kops create cluster \
    --name ${KOPS_CLUSTER_NAME} \
    --node-count 2 \
    --node-size t2.micro \
    --master-size t2.micro \
    --zones eu-west-1a
```
- Now, let’s create the Kubernetes cluster on AWS by executing kops update command:
```
$ kops update cluster --name ${KOPS_CLUSTER_NAME} --yes
```
- Delete cluster and all resources
```
$ kops delete cluster --name ${KOPS_CLUSTER_NAME} --yes
```
- Above command may take some time to create the required infrastructure resources on AWS. Execute the validate command to check its status and wait until the cluster becomes ready:
```
$ kops validate cluster

Validating cluster kubernetes-solution-cluster.k8s.local

INSTANCE GROUPS
NAME                    ROLE    MACHINETYPE     MIN     MAX     SUBNETS
master-eu-west-1a       Master  t2.micro        1       1       eu-west-1a
nodes                   Node    t2.micro        2       2       eu-west-1a

NODE STATUS
NAME                                            ROLE    READY
ip-172-20-36-128.eu-west-1.compute.internal     node    True
ip-172-20-45-32.eu-west-1.compute.internal      node    True
ip-172-20-51-39.eu-west-1.compute.internal      master  True

Your cluster kubernetes-solution-cluster.k8s.local is ready
```
Once the above process completes, kops will configure the Kubernetes CLI (kubectl) with Kubernetes cluster API endpoint and user credentials.

- Now, you may need to deploy the [Kubernetes dashboard](https://github.com/kubernetes/dashboard) to access the cluster via its web based user interface:
```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
```
- Execute the below command to find the Kubernetes master hostname:
```
$ kubectl cluster-info

Kubernetes master is running at https://api-kubernetes-solution-cluster-<dynamic-id>.eu-west-1.elb.amazonaws.com
KubeDNS is running at https://api-kubernetes-solution-cluster-<dynamic-id>.eu-west-1.elb.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```
- Access the Kubernetes dashboard using the following URL:
```
https://<kubernetes-master-hostname>/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/ui
```
- Execute the below command to find the 'admin' user’s password:
```
$ kops get secrets kube --type secret -oplaintext
```

Provide the username as admin and the password obtained above on the browser’s login page.

Execute the below command to find the admin service account token. Note the secret name used here is different from the previous one.
```
$ kops get secrets admin --type secret -oplaintext
```

Provide the above service account token on the service token request page.

More info about Kubernetes and AWS: [Getting Started](https://github.com/kubernetes/kops/blob/master/docs/aws.md#prepare-local-environment)
