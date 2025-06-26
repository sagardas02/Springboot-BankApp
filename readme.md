# Install java for jenkins
```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version
```
# Install jenkins
```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```
# Change the jenkins port 
```bash
sudo vim /usr/lib/systemd/system/jenkins.service     #change the Environment="JENKINS_PORT=8080" [default]
```
# Restart jenkins and daemon-reload
```bash
sudo systemctl daemon-reload
```
```bash
sudo systemctl restart jenkins
```
```bash
systemctl status jenkins
```
# Allow inbound rules in ec2 instance of jenkins port

# Add credentials of dockerhub and others in jenkins UI in browser

# Add jenkins user to docker group to get access
```bash
sudo usermod -aG docker jenkins && newgrp docker
```
```bash
sudo systemctl restart jenkins
```

# Install AWS CLI 
```bash
sudo apt  install awscli
```
# Configure the aws configure file 
```bash
aws configure
```
# Create a install_eksctl.sh file and paste this command

```bash
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin
```
# Give permission to install_eksctl.sh file
```bash
sudo 700 install_eksctl.sh
./install_eksctl.sh
```
# Create Cluster on EKS

```bash
eksctl create cluster --name=bankapp-cluster --region=eu-west-1 --version=1.31 --without-nodegroup
 ```

# Install Kubectl on linux
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
```
```bash
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
```
```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
```bash
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
```
```bash
kubectl version --client
```
# OpenID Connect
```bash
eksctl utils associate-iam-oidc-provider --region=eu-west-1 --cluster=bankapp-cluster --approve
```

# Creating EKS Node Group
```bash
eksctl create nodegroup --cluster=bankapp-cluster --region=eu-west-1 --name=bankapp-ng --node-type=t2.medium --nodes=2 --nodes-min=1 --nodes-max=2 --node-volume-size=20 --ssh-access --ssh-public-key=bank-app-terra-key
```
# Apply namespace
```bash
kubectl apply -f bankapp-namespace.yml
```
# Create ArgoCD namespace
```bash
kubectl create namespace argocd
```
# Apply argocd menifest files
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
# Install ArgoCD CLI
```bash
curl --silent --location -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.4.7/argocd-linux-amd64
```
```bash
sudo chmod +x /usr/local/bin/argocd
```
```bash
argocd version
```
```bash
kubectl get svc -n argocd
```
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
```
# Update the inbound rules in ec2 instance

# Password of argocd and the default username is admin
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
# Login argocd in ec2 instance
```bash
argocd login [ec2 ip address] --username admin
```
# Check the argocd default cluster list
```bash
argocd cluster list
```
# Check your cluster name
```bash
kubectl config get-contexts
```
# Add cluster in your argocd
```bash
argocd cluster add [cluster name] --name [cluster name you want to set]
```
# Connect repo in argocd ui [2:32:40]

<!-- # Installing helm 
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
# installing controller for nginx through helm
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```
```bash
helm repo update
```
```bash
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```
# Check the ingress nginx pod && svc of nginx
```bash
kubectl get pods -n ingress-nginx
```
```bash
kubectl get svc -n ingress-nginx
```
# Check the ip address in the browser

# Apply the ingress yaml file
```bash
kubectl apply -f bankapp-ingress.yml
```
# Add DNS record in godaddy add CName = bankapp.sagardevops.xyz and value = [ip address of ingress controller]

# Install cert manager in cluster
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.0/cert-manager.yaml
```
# Create a cert-issuer.yml file

# Apply the cert-issuer.yml
```bash
kubectl apply -f cert-issuer.yml
```
```bash
kubectl describe certificate bankapp-tls-secret -n bankapp-namespace
``` -->
