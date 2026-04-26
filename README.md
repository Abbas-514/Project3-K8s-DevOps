# Project 3: Automated Multi-Tier Application Deployment

This repository contains a full deployment pipeline for a multi-tier calculator application, utilizing Docker, Terraform, Ansible, Kubernetes, GitHub Actions, and ArgoCD.

## Application Architecture

- **Frontend**: A simple HTML/JS UI served using an Nginx container. It communicates with the backend via an Nginx reverse proxy.
- **Backend**: A Node.js Express API that performs calculator operations (`add`, `subtract`, `multiply`, `divide`).

## Deployment Steps

### 1. Infrastructure Provisioning (Terraform)
Navigate to the `terraform` directory to provision the AWS EC2 instance.
```bash
cd terraform
terraform init
terraform apply -auto-approve
```
This provisions a VPC, Subnet, Security Group, and an EC2 instance. The output will provide the public IP of your new EC2 instance.

### 2. Configuration Management (Ansible)
Wait for the EC2 instance to initialize. Update the `ansible/inventory.ini` file with the public IP address of your EC2 instance.
```bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```
This playbook installs required dependencies, installs MicroK8s, and enables essential addons (dns, storage, ingress).

### 3. CI/CD Pipeline (GitHub Actions)
Ensure you have added the following secrets to your GitHub repository (Settings > Secrets and variables > Actions):
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_PASSWORD`

When you push to the `main` branch, the GitHub Action automatically builds the Docker images for both the frontend and backend, and pushes them to DockerHub (`abbas514/frontend:latest` and `abbas514/backend:latest`).

### 4. Continuous Deployment (ArgoCD)
1. SSH into the EC2 instance and install ArgoCD on your MicroK8s cluster:
```bash
microk8s enable argocd
```
2. Apply the ArgoCD application manifest. The `argocd/application.yaml` is already configured to point to `https://github.com/Abbas-514/Project3-K8s-DevOps.git`:
```bash
kubectl apply -f argocd/application.yaml
```
ArgoCD will continuously monitor the `k8s/` directory in this repository and automatically sync your deployment manifests to the cluster.

### Accessing the Application
Once deployed, the application will be accessible via the public IP of the EC2 instance on port 80 (routed by Ingress) or port 30080 (via NodePort).
