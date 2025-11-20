# Kubectl Commands Quick Reference

Essential kubectl commands for managing your Udagram microservices deployment.

## Cluster Connection

```bash
# Configure kubectl for your EKS cluster
aws eks update-kubeconfig --region us-east-1 --name udagram-cluster

# View cluster information
kubectl cluster-info

# View cluster nodes
kubectl get nodes

# Detailed node information
kubectl describe nodes
```

## Deployments

```bash
# Apply all configurations from directory
kubectl apply -f udagram-deployment/

# Apply individual file
kubectl apply -f udagram-deployment/backend-feed-deployment.yaml

# List all deployments
kubectl get deployments

# Detailed deployment information
kubectl describe deployment backend-feed

# Scale a deployment
kubectl scale deployment backend-feed --replicas=3

# Update image for a deployment
kubectl set image deployment/frontend frontend=YOUR_USERNAME/udagram-frontend:v2

# Rollback deployment
kubectl rollout undo deployment/frontend

# Check rollout status
kubectl rollout status deployment/frontend

# Delete deployment
kubectl delete deployment backend-feed
```

## Pods

```bash
# List all pods
kubectl get pods

# List pods with more details
kubectl get pods -o wide

# Detailed pod information
kubectl describe pod <pod-name>

# Get pod logs
kubectl logs <pod-name>

# Follow pod logs (stream)
kubectl logs -f <pod-name>

# Get logs from previous pod instance
kubectl logs <pod-name> -p

# Execute command in pod
kubectl exec -it <pod-name> -- /bin/bash

# Execute single command
kubectl exec <pod-name> -- printenv

# Delete pod (will be recreated by deployment)
kubectl delete pod <pod-name>
```

## Services

```bash
# List all services
kubectl get services

# Detailed service information
kubectl describe service backend-feed

# Get service endpoints
kubectl get endpoints

# Expose deployment as service
kubectl expose deployment frontend --type=LoadBalancer --name=publicfrontend

# Delete service
kubectl delete service publicfrontend
```

## ConfigMaps and Secrets

```bash
# List configmaps
kubectl get configmaps

# View configmap contents
kubectl describe configmap env-config

# List secrets
kubectl get secrets

# View secret (values will be base64 encoded)
kubectl describe secret env-secret

# Delete configmap
kubectl delete configmap env-config

# Delete secret
kubectl delete secret env-secret
```

## Horizontal Pod Autoscaler (HPA)

```bash
# Create HPA
kubectl autoscale deployment backend-user --cpu-percent=70 --min=3 --max=5

# List HPAs
kubectl get hpa

# Detailed HPA information
kubectl describe hpa backend-user

# Delete HPA
kubectl delete hpa backend-user
```

## Namespace Operations

```bash
# List namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace udagram

# Set default namespace
kubectl config set-context --current --namespace=udagram

# Delete namespace (deletes all resources in it)
kubectl delete namespace udagram
```

## Troubleshooting Commands

```bash
# Check pod events
kubectl get events --sort-by=.metadata.creationTimestamp

# Check resource usage
kubectl top nodes
kubectl top pods

# Get all resources
kubectl get all

# Describe multiple resources
kubectl describe pods
kubectl describe services

# Check pod resource limits
kubectl describe pod <pod-name> | grep -A 5 "Limits"

# Port forward for local testing
kubectl port-forward pod/<pod-name> 8080:8080

# View pod YAML
kubectl get pod <pod-name> -o yaml

# View service YAML
kubectl get service <service-name> -o yaml
```

## Required Commands for Screenshots

### 1. Get Pods Status
```bash
kubectl get pods
```
**Save as:** `screenshots/kubectl-get-pods.png`

### 2. Describe Services
```bash
kubectl describe services
```
**Save as:** `screenshots/kubectl-describe-services.png`

### 3. Describe HPA
```bash
kubectl describe hpa
```
**Save as:** `screenshots/kubectl-describe-hpa.png`

### 4. Get Pod Logs
```bash
# First, get the pod name
kubectl get pods

# Then get logs from backend pod
kubectl logs <backend-user-pod-name>

# Or follow logs while performing actions
kubectl logs -f <backend-user-pod-name>
```
**Save as:** `screenshots/kubectl-logs.png`

## Cleanup Commands

```bash
# Delete all resources in current namespace
kubectl delete all --all

# Delete specific resource types
kubectl delete deployments --all
kubectl delete services --all
kubectl delete configmaps --all
kubectl delete secrets --all

# Delete everything from directory
kubectl delete -f udagram-deployment/
```

## Useful Filters and Formats

```bash
# Filter by label
kubectl get pods -l app=backend-feed

# Output as JSON
kubectl get pods -o json

# Output as YAML
kubectl get pods -o yaml

# Custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

# Watch for changes
kubectl get pods --watch

# Show labels
kubectl get pods --show-labels
```

## Quick Diagnostics

```bash
# Check if pod is running
kubectl get pod <pod-name> --output=jsonpath='{.status.phase}'

# Check pod restart count
kubectl get pods --output=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.containerStatuses[0].restartCount}{"\n"}{end}'

# Get pod IP addresses
kubectl get pods -o wide --output=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'

# Check service external IP
kubectl get service frontend --output=jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Tips

1. **Use aliases for frequent commands:**
```bash
alias k=kubectl
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
```

2. **Enable kubectl autocompletion (zsh):**
```bash
source <(kubectl completion zsh)
```

3. **Use dry-run to preview changes:**
```bash
kubectl apply -f deployment.yaml --dry-run=client
```

4. **Use explain to understand resource fields:**
```bash
kubectl explain pod.spec.containers
```

5. **Context management:**
```bash
# View current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <context-name>
```

