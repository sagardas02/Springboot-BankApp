# Create Cluster on EKS

```bash
 eksctl create cluster --name=bankapp-cluster --region=eu-west-1 --version=1.31 --without-nodegroup
 ```

# Install Kubectl on linux

$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

$ chmod +x kubectl
$ mkdir -p ~/.local/bin
$ mv ./kubectl ~/.local/bin/kubectl

$ kubectl version --client

# OpenID Connect

$ eksctl utils associate-iam-oidc-provider --region=eu-west-1 --cluster=bankapp-cluster --approve


# Creating EKS Node Group

$ eksctl create nodegroup --cluster=bankapp-cluster --region=eu-west-1 --name=bankapp-ng --node-type=t2.micro --nodes=2 --nodes-min=1 --nodes-max=2 --node-volume-size=15 --ssh-access --ssh-public-key=bankapp-automate-key

# Apply namespace

$ kubectl apply -f bankapp-namespace.yml

# Create ArgoCD namespace

$ kubectl create namespace argocd

# Apply argocd menifest files

$ kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable

# Install ArgoCD CLI

$ curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64

$ sudo chmod +x /usr/local/bin/argocd

$ argocd version

$ kubectl get svc -n argocd

$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Update the inbound rules in ec2 instance

# Password of argocd and the default username is admin

$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Login argocd in ec2 instance

$ argocd login [ec2 ip address] --username admin

# Check the argocd default cluster list

$ argocd cluster list

# Check your cluster name

$ kubectl config get-contexts

# Add cluster in your argocd

$ argocd cluster add [cluster name] --name [cluster name you want to set]

# Connect repo in argocd ui [2:32:40]

# Installing helm 

$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh

# installing controller for nginx through helm

$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

$ helm repo update

$ helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# Check the ingress nginx pod && svc of nginx

$ kubectl get pods -n ingress-nginx

$ kubectl get svc -n ingress-nginx

# Check the ip address in the browser

# Apply the ingress yaml file

$ kubectl apply -f bankapp-ingress.yml

# Add DNS record in godaddy add CName = bankapp.sagardevops.xyz and value = [ip address of ingress controller]

# Install cert manager in cluster

$ kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.0/cert-manager.yaml

# Create a cert-issuer.yml file

# Apply the cert-issuer.yml

$ kubectl apply -f cert-issuer.yml

$ kubectl describe certificate bankapp-tls-secret -n bankapp-namespace

# Install java for jenkins

$ sudo apt update
$ sudo apt install fontconfig openjdk-21-jre
$ java -version

# Install jenkins

$ sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key

$ echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

$ sudo apt-get update
$ sudo apt-get install jenkins

# Change the jenkins port 

$ sudo vim /usr/lib/systemd/system/jenkins.service     #change the Environment="JENKINS_PORT=8080" [default]

# Restart jenkins and daemon-reload

$ sudo systemctl daemon-reload

$ sudo systemctl restart jenkins

$ systemctl status jenkins

# Allow inbound rules in ec2 instance of jenkins port

# Add credentials of dockerhub and others in jenkins UI in browser

# Add jenkins user to docker group to get access

$ sudo usermod -aG docker jenkins && newgrp docker

$sudo systemctl restart jenkins