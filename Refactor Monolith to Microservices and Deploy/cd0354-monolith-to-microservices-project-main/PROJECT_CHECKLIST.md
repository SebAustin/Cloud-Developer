# Udagram Microservices Project - Submission Checklist

Use this checklist to ensure your project is ready for submission to Udacity.

## Phase 0: Prerequisites ✓

- [ ] Docker Desktop installed and running
- [ ] AWS CLI installed and configured
- [ ] kubectl installed
- [ ] Node.js and npm installed
- [ ] Ionic CLI installed
- [ ] AWS RDS PostgreSQL database created
- [ ] AWS S3 bucket created with CORS enabled
- [ ] DockerHub account created
- [ ] Travis CI account created and linked to GitHub

## Phase 1: Microservices Refactoring ✓

### Feed Service
- [ ] `udagram-api-feed/` directory created
- [ ] Feed-related code copied and modified
- [ ] `src/server.ts` includes only feed models
- [ ] `src/controllers/v0/index.router.ts` includes only feed routes
- [ ] `src/controllers/v0/model.index.ts` exports only FeedItem
- [ ] `Dockerfile` created
- [ ] `.dockerignore` includes `node_modules`

### User Service
- [ ] `udagram-api-user/` directory created
- [ ] User-related code copied and modified
- [ ] `src/server.ts` includes only user models
- [ ] `src/controllers/v0/index.router.ts` includes only user routes
- [ ] `src/controllers/v0/model.index.ts` exports only User
- [ ] `Dockerfile` created
- [ ] `.dockerignore` includes `node_modules`

### Frontend
- [ ] `udagram-frontend/Dockerfile` created (multi-stage build)
- [ ] `.dockerignore` created

### Reverse Proxy
- [ ] `udagram-reverseproxy/` directory created
- [ ] `nginx.conf` routes to feed and user services
- [ ] `Dockerfile` created

## Phase 2: Docker Configuration ✓

- [ ] `docker-compose-build.yaml` created with all 4 services
- [ ] `docker-compose.yaml` created with environment variables
- [ ] All images build successfully locally
- [ ] Application runs with `docker-compose up`
- [ ] Frontend accessible at http://localhost:8100
- [ ] API accessible at http://localhost:8080/api/v0/feed

## Phase 3: Travis CI Pipeline ✓

### DockerHub Setup
- [ ] Created `reverseproxy` repository
- [ ] Created `udagram-api-user` repository
- [ ] Created `udagram-api-feed` repository
- [ ] Created `udagram-frontend` repository

### Travis Configuration
- [ ] `.travis.yml` created in project root
- [ ] All 4 images configured to build
- [ ] Images tagged with version (v1, v2, etc.)
- [ ] Docker login configured with credentials
- [ ] Push to DockerHub configured

### Travis Environment Variables
- [ ] `DOCKER_USERNAME` set in Travis settings
- [ ] `DOCKER_PASSWORD` set in Travis settings

### Build Verification
- [ ] Code pushed to GitHub
- [ ] Travis build triggered automatically
- [ ] All 4 images built successfully
- [ ] All 4 images pushed to DockerHub
- [ ] **Screenshot taken: DockerHub with images**
- [ ] **Screenshot taken: Travis CI successful build**

## Phase 4: Kubernetes Deployment ✓

### EKS Cluster Setup
- [ ] IAM role created for EKS cluster
- [ ] EKS cluster created (via Console or eksctl)
- [ ] IAM role created for Node Group
- [ ] Node Group created (2-3 m5.large nodes)
- [ ] kubectl configured: `aws eks update-kubeconfig`
- [ ] Nodes verified: `kubectl get nodes` shows Ready status

### Kubernetes Configuration Files
- [ ] `udagram-deployment/` directory created
- [ ] `env-configmap.yaml` created and updated with actual values
- [ ] `env-secret.yaml` created with PostgreSQL credentials
- [ ] `aws-secret.yaml` created with Base64 AWS credentials
- [ ] `backend-feed-deployment.yaml` created
- [ ] `backend-user-deployment.yaml` created
- [ ] `reverseproxy-deployment.yaml` created
- [ ] `frontend-deployment.yaml` created
- [ ] `backend-feed-service.yaml` created
- [ ] `backend-user-service.yaml` created
- [ ] `reverseproxy-service.yaml` created
- [ ] `frontend-service.yaml` created
- [ ] All deployment files have correct DockerHub image names
- [ ] All deployment files have correct image tags

### Deployment Execution
- [ ] ConfigMap applied: `kubectl apply -f env-configmap.yaml`
- [ ] Secrets applied: `kubectl apply -f env-secret.yaml` and `aws-secret.yaml`
- [ ] All deployments applied
- [ ] All services applied
- [ ] All pods running: `kubectl get pods` shows Running status
- [ ] LoadBalancer services have External IP assigned

### Frontend Update
- [ ] Reverseproxy External IP obtained
- [ ] `udagram-frontend/src/environments/environment.ts` updated
- [ ] `udagram-frontend/src/environments/environment.prod.ts` updated
- [ ] New frontend image built and tagged (v2)
- [ ] New image pushed to DockerHub
- [ ] Frontend deployment updated with new image

### Autoscaling
- [ ] HPA created: `kubectl autoscale deployment backend-user --cpu-percent=70 --min=3 --max=5`
- [ ] HPA verified: `kubectl get hpa`
- [ ] Deployment replicas set to 2 minimum

### Application Access
- [ ] Frontend External IP obtained
- [ ] Application accessible via browser
- [ ] User can register
- [ ] User can login
- [ ] User can post photos
- [ ] Photos stored in S3

### Screenshots
- [ ] **Screenshot taken: `kubectl get pods`** (all Running)
- [ ] **Screenshot taken: `kubectl describe services`** (no passwords visible)
- [ ] **Screenshot taken: `kubectl describe hpa`** (autoscaling configured)
- [ ] **Screenshot taken: `kubectl logs <pod-name>`** (user activity visible)

## Phase 5: Documentation ✓

- [ ] Main `README.md` updated with project overview
- [ ] `SETUP_GUIDE.md` created with prerequisites
- [ ] `DEPLOYMENT_GUIDE.md` created with deployment steps
- [ ] `KUBECTL_REFERENCE.md` created with helpful commands
- [ ] `screenshots/README.md` updated with requirements
- [ ] `PROJECT_CHECKLIST.md` created (this file)
- [ ] All markdown files reviewed for accuracy

## Phase 6: Security & Git ✓

- [ ] `set_env.sh` added to `.gitignore`
- [ ] `.env` files added to `.gitignore`
- [ ] AWS credentials files added to `.gitignore`
- [ ] `set_env.sh` removed from git tracking: `git rm --cached set_env.sh`
- [ ] No credentials visible in any committed files
- [ ] No hardcoded passwords or secrets
- [ ] Kubernetes secret files use placeholders (YOUR_USERNAME, etc.)

## Phase 7: Final Verification ✓

### Code Quality
- [ ] No linter errors in backend services
- [ ] Code follows TypeScript best practices
- [ ] All services have proper error handling
- [ ] CORS configured correctly

### Repository Structure
- [ ] All microservice directories present
- [ ] All Docker files present
- [ ] All Kubernetes files present
- [ ] Docker compose files present
- [ ] Travis CI configuration present
- [ ] Documentation files present
- [ ] Screenshots directory with all images

### Functionality
- [ ] All Docker images build successfully
- [ ] All containers run locally with docker-compose
- [ ] All Kubernetes pods run successfully
- [ ] Application fully functional in Kubernetes
- [ ] Users can register and login
- [ ] Users can post and view photos
- [ ] Image filtering works

### Screenshots Quality
- [ ] All 6 required screenshots present
- [ ] Screenshots named correctly
- [ ] Screenshots are high resolution and readable
- [ ] Screenshots show recent timestamps
- [ ] No sensitive information visible
- [ ] Screenshots match project requirements

## Submission Requirements ✓

### GitHub Repository
- [ ] Repository is public or access granted to Udacity
- [ ] All code committed and pushed
- [ ] Commit messages are clear and descriptive
- [ ] No large files (> 100MB) committed
- [ ] `.gitignore` properly configured

### Screenshots Location
- [ ] All screenshots in `screenshots/` directory
- [ ] `dockerhub.png` present
- [ ] `travis-ci.png` present
- [ ] `kubectl-get-pods.png` present
- [ ] `kubectl-describe-services.png` present
- [ ] `kubectl-describe-hpa.png` present
- [ ] `kubectl-logs.png` present

### Project Rubric Alignment
Review each criterion from the [Project Rubric](https://review.udacity.com/#!/rubrics/2804/view):

#### Containers and Microservices
- [ ] Application divided into feed and user microservices
- [ ] Dockerfiles successfully create images for all services
- [ ] DockerHub screenshot shows all images

#### Independent Releases and Deployments
- [ ] `.travis.yml` file present and functional
- [ ] Travis CI screenshot shows successful build and deploy

#### Service Orchestration with Kubernetes
- [ ] Frontend and API deployed in Kubernetes
- [ ] Pods running successfully (screenshot)
- [ ] Services properly configured (screenshot)
- [ ] No sensitive data exposed (screenshot verification)

#### Reverse Proxy
- [ ] Reverse proxy directs requests to appropriate backends
- [ ] Nginx configuration correct

#### Scaling and Self-Healing
- [ ] Services replicated (replicas > 1)
- [ ] HPA configured with CPU metrics (screenshot)

#### Logging
- [ ] Pod logs show user activity (screenshot)

## Pre-Submission Final Steps

1. **Clean Build Test**
```bash
# Remove all local images
docker rmi $(docker images -q)

# Rebuild from scratch
docker-compose -f docker-compose-build.yaml build --parallel

# Test locally
docker-compose up
```

2. **Fresh Kubernetes Deploy Test**
```bash
# Delete all resources
kubectl delete all --all

# Reapply everything
kubectl apply -f udagram-deployment/

# Verify
kubectl get pods
kubectl get services
```

3. **Documentation Review**
- [ ] Read through README.md
- [ ] Test commands in DEPLOYMENT_GUIDE.md
- [ ] Verify all links work

4. **Screenshot Review**
- [ ] Open each screenshot
- [ ] Verify quality and readability
- [ ] Check for sensitive information
- [ ] Confirm filenames match requirements

5. **Git Status Check**
```bash
# Ensure no uncommitted changes
git status

# Ensure set_env.sh not tracked
git ls-files | grep set_env.sh  # Should return nothing

# Final push
git push origin main
```

## Submission

- [ ] GitHub repository URL ready
- [ ] All screenshots visible in repository
- [ ] Project submitted to Udacity
- [ ] Confirmation email received

## Post-Submission (Optional)

After receiving grade:
- [ ] Review feedback
- [ ] Make any required changes
- [ ] Resubmit if necessary

## Cleanup (After Approval)

To avoid AWS charges:
- [ ] Delete LoadBalancer services: `kubectl delete service frontend reverseproxy`
- [ ] Delete Node Group (AWS Console)
- [ ] Delete EKS cluster (AWS Console)
- [ ] Delete RDS database
- [ ] Empty and delete S3 bucket
- [ ] Verify no running EC2 instances
- [ ] Verify no orphaned load balancers
- [ ] Check AWS billing dashboard

---

## Notes

- Keep backup of all screenshots
- Document any deviations from standard deployment
- Note any issues encountered and solutions
- Keep Travis CI builds for reference
- Maintain DockerHub images for at least 30 days after submission

---

**Project Status**: Ready for Submission ✓

**Completion Date**: _______________

**Submission Date**: _______________

**Grade Received**: _______________

