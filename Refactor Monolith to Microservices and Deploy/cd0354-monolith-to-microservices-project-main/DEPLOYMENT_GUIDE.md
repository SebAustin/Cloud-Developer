# Udagram Microservices Deployment Guide

This guide walks you through deploying the Udagram application as microservices using Docker and Kubernetes.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Local Development with Docker Compose](#local-development-with-docker-compose)
3. [CI/CD with Travis CI](#cicd-with-travis-ci)
4. [Kubernetes Deployment on AWS EKS](#kubernetes-deployment-on-aws-eks)
5. [Troubleshooting](#troubleshooting)

## Prerequisites

Before starting, ensure you have completed the setup steps in `SETUP_GUIDE.md`:
- AWS resources created (RDS, S3)
- Environment variables configured in `set_env.sh`
- Docker Desktop installed and running
- AWS CLI configured
- kubectl installed
- DockerHub account created
- Travis CI account created

## Local Development with Docker Compose

### Step 1: Load Environment Variables

```bash
source set_env.sh
```

### Step 2: Build Docker Images

```bash
# Build all images
docker-compose -f docker-compose-build.yaml build --parallel

# Or build individually
docker build -t udagram-api-feed ./udagram-api-feed
docker build -t udagram-api-user ./udagram-api-user
docker build -t udagram-frontend ./udagram-frontend
docker build -t reverseproxy ./udagram-reverseproxy
```

### Step 3: Run Containers

```bash
docker-compose up
```

### Step 4: Test the Application

- Frontend: http://localhost:8100
- API via Reverse Proxy: http://localhost:8080/api/v0/feed

### Step 5: Stop Containers

```bash
docker-compose down
```

## CI/CD with Travis CI

### Step 1: Create DockerHub Repositories

Go to https://hub.docker.com and create 4 public repositories:
- `reverseproxy`
- `udagram-api-user`
- `udagram-api-feed`
- `udagram-frontend`

### Step 2: Configure Travis CI

1. Go to https://travis-ci.com and sign in with GitHub
2. Activate your repository
3. Go to repository settings and add environment variables:
   - `DOCKER_USERNAME`: Your DockerHub username
   - `DOCKER_PASSWORD`: Your DockerHub password

### Step 3: Update .travis.yml

Update the `.travis.yml` file to use your DockerHub username:
- Replace `YOUR_DOCKERHUB_USERNAME` with your actual DockerHub username

### Step 4: Push to GitHub

```bash
git add .
git commit -m "Add microservices implementation"
git push origin main
```

### Step 5: Monitor Build

- Go to Travis CI dashboard
- Watch the build process
- After successful build, verify images in DockerHub

**Screenshot Required:** DockerHub showing pushed images and Travis CI successful build

## Kubernetes Deployment on AWS EKS

### Step 1: Create EKS Cluster

#### Using AWS Console:

1. **Create IAM Role for EKS:**
   - Go to IAM → Roles → Create role
   - Select EKS as the service
   - Attach policies:
     - AmazonEKSClusterPolicy
     - AmazonEC2ContainerServiceFullAccess
     - AmazonEKSServicePolicy
   - Name: `eksClusterRole`

2. **Create EKS Cluster:**
   - Go to EKS → Clusters → Create cluster
   - Name: `udagram-cluster`
   - Kubernetes version: Latest stable
   - Cluster service role: `eksClusterRole`
   - VPC: Select existing or create new
   - Cluster endpoint access: Public
   - Wait ~20 minutes for creation

#### Or Using eksctl:

```bash
eksctl create cluster \
  --name udagram-cluster \
  --region us-east-1 \
  --nodes-min=2 \
  --nodes-max=3 \
  --node-type=m5.large
```

### Step 2: Create Node Group

1. **Create IAM Role for Node Group:**
   - Go to IAM → Roles → Create role
   - Select EC2 as the service
   - Attach policies:
     - AmazonEKSWorkerNodePolicy
     - AmazonEC2ContainerRegistryReadOnly
     - AmazonEKS_CNI_Policy
   - Name: `eksNodeRole`

2. **Create Node Group:**
   - Go to EKS → Clusters → udagram-cluster → Compute → Add Node Group
   - Name: `udagram-nodes`
   - Node IAM role: `eksNodeRole`
   - Instance type: m5.large
   - Disk size: 20 GB
   - Scaling configuration:
     - Minimum: 2
     - Maximum: 3
     - Desired: 2

### Step 3: Configure kubectl

```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name udagram-cluster

# Verify connection
kubectl get nodes
```

You should see 2 nodes in Ready status.

### Step 4: Update Kubernetes Configuration Files

Navigate to `udagram-deployment/` and update the following:

1. **env-configmap.yaml:**
   - Replace `YOUR-BUCKET-NAME` with your S3 bucket name
   - Replace `YOUR-RDS-ENDPOINT` with your RDS endpoint

2. **env-secret.yaml:**
   - Replace `YOUR_POSTGRES_USERNAME` with your PostgreSQL username
   - Replace `YOUR_POSTGRES_PASSWORD` with your PostgreSQL password

3. **aws-secret.yaml:**
   - Generate Base64 encoded AWS credentials:
   ```bash
   cat ~/.aws/credentials | tail -n 5 | head -n 2 | base64
   ```
   - Replace `___INSERT_AWS_CREDENTIALS_FILE__BASE64____` with the output

4. **All deployment files:**
   - Replace `YOUR_DOCKERHUB_USERNAME` with your DockerHub username
   - Ensure image tags match what you pushed (e.g., `:v1`)

### Step 5: Deploy to Kubernetes

```bash
cd udagram-deployment

# Apply secrets and configmap
kubectl apply -f env-secret.yaml
kubectl apply -f env-configmap.yaml
kubectl apply -f aws-secret.yaml

# Apply deployments
kubectl apply -f backend-feed-deployment.yaml
kubectl apply -f backend-user-deployment.yaml
kubectl apply -f reverseproxy-deployment.yaml
kubectl apply -f frontend-deployment.yaml

# Apply services
kubectl apply -f backend-feed-service.yaml
kubectl apply -f backend-user-service.yaml
kubectl apply -f reverseproxy-service.yaml
kubectl apply -f frontend-service.yaml
```

### Step 6: Wait for Services to Start

```bash
# Check pods status (wait until all are Running)
kubectl get pods

# Check services
kubectl get services
```

Wait for LoadBalancer services to get an EXTERNAL-IP (may take 5-10 minutes).

### Step 7: Update Frontend Environment

1. Get the reverseproxy External IP:
```bash
kubectl get service reverseproxy
```

2. Update `udagram-frontend/src/environments/environment.ts`:
```typescript
export const environment = {
  production: false,
  appName: 'Udagram',
  apiHost: 'http://YOUR_REVERSEPROXY_EXTERNAL_IP:8080/api/v0'
};
```

3. Update `udagram-frontend/src/environments/environment.prod.ts` similarly

4. Rebuild and push frontend image:
```bash
cd udagram-frontend
docker build -t YOUR_DOCKERHUB_USERNAME/udagram-frontend:v2 .
docker push YOUR_DOCKERHUB_USERNAME/udagram-frontend:v2
```

5. Update frontend deployment:
```bash
kubectl set image deployment frontend frontend=YOUR_DOCKERHUB_USERNAME/udagram-frontend:v2
```

### Step 8: Configure Autoscaling

```bash
# Create HPA for backend-user
kubectl autoscale deployment backend-user --cpu-percent=70 --min=3 --max=5

# Verify HPA
kubectl get hpa
```

**Screenshot Required:** `kubectl describe hpa`

### Step 9: Access the Application

Get the frontend External IP:
```bash
kubectl get service frontend
```

Open your browser and go to the frontend EXTERNAL-IP.

### Step 10: Capture Screenshots

**Required Screenshots (save to `screenshots/` directory):**

1. **kubectl-get-pods.png**
```bash
kubectl get pods
```

2. **kubectl-describe-services.png**
```bash
kubectl describe services
```

3. **kubectl-describe-hpa.png**
```bash
kubectl describe hpa
```

4. **kubectl-logs.png** - After performing user actions (register, login, post photo):
```bash
# Get pod name
kubectl get pods

# View logs
kubectl logs <backend-user-pod-name>
```

## Troubleshooting

### Pods Not Starting

```bash
# Check pod status
kubectl get pods

# Describe a specific pod
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

Common issues:
- **ImagePullBackOff**: Wrong image name or repository is private
- **CrashLoopBackOff**: Application error, check logs
- **Pending**: Insufficient cluster resources

### Database Connection Issues

Check environment variables in pods:
```bash
kubectl exec -it <backend-pod-name> -- printenv | grep POSTGRES
```

Verify RDS security group allows connections from EKS cluster.

### AWS Credentials Issues

```bash
# Check if AWS secret is created
kubectl get secret aws-secret

# Check if credentials are mounted
kubectl exec -it <backend-feed-pod-name> -- ls -la /root/.aws/
```

### Service Not Accessible

```bash
# Check service status
kubectl get services

# Check endpoints
kubectl get endpoints
```

For LoadBalancer services, wait 5-10 minutes for AWS to provision the load balancer.

### Application Logs

```bash
# Stream logs from a pod
kubectl logs -f <pod-name>

# View logs from previous pod instance
kubectl logs <pod-name> -p
```

## Cleanup

After project submission, clean up AWS resources:

```bash
# Delete Kubernetes services (this deletes load balancers)
kubectl delete service frontend
kubectl delete service reverseproxy

# Delete the node group (via AWS Console)
# Delete the EKS cluster (via AWS Console)

# Delete RDS database
aws rds delete-db-instance --db-instance-identifier udagram-db --skip-final-snapshot

# Empty and delete S3 bucket
aws s3 rm s3://your-bucket-name --recursive
aws s3 rb s3://your-bucket-name
```

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Docker Documentation](https://docs.docker.com/)
- [Travis CI Documentation](https://docs.travis-ci.com/)

