# Required Screenshots for Udagram Microservices Project

This directory should contain 6 screenshots demonstrating successful deployment of the Udagram microservices application.

## Screenshot Checklist

### 1. DockerHub Repositories (`dockerhub.png`)

**What to capture:**
- Your DockerHub account showing all 4 repositories with pushed images:
  - `reverseproxy`
  - `udagram-api-feed`
  - `udagram-api-user`
  - `udagram-frontend`
- Images should show recent push timestamps
- Each repository should show at least one tagged version (e.g., v1, v2)

**How to get it:**
1. Log into https://hub.docker.com
2. Navigate to your repositories page
3. Take screenshot showing all 4 repositories with tags and last pushed dates

---

### 2. Travis CI Build Success (`travis-ci.png`)

**What to capture:**
- Travis CI dashboard showing successful build and deploy job
- Should show green checkmark/passed status
- Build log showing Docker images being built and pushed

**How to get it:**
1. Log into https://travis-ci.com
2. Navigate to your repository
3. Click on a successful build
4. Take screenshot showing:
   - Green "build passing" status
   - Build steps completed successfully
   - Docker push commands executed

---

### 3. Kubernetes Pods Running (`kubectl-get-pods.png`)

**What to capture:**
- Output of `kubectl get pods` command
- All pods should show `STATUS: Running`
- Should include pods for:
  - backend-feed (2 replicas)
  - backend-user (2 replicas)
  - reverseproxy (2 replicas)
  - frontend (2 replicas)

**Command:**
```bash
kubectl get pods
```

**Expected output format:**
```
NAME                            READY   STATUS    RESTARTS   AGE
backend-feed-xxxxxxxxx-xxxxx    1/1     Running   0          10m
backend-feed-xxxxxxxxx-xxxxx    1/1     Running   0          10m
backend-user-xxxxxxxxx-xxxxx    1/1     Running   0          10m
backend-user-xxxxxxxxx-xxxxx    1/1     Running   0          10m
reverseproxy-xxxxxxxxx-xxxxx    1/1     Running   0          10m
reverseproxy-xxxxxxxxx-xxxxx    1/1     Running   0          10m
frontend-xxxxxxxxx-xxxxx        1/1     Running   0          10m
frontend-xxxxxxxxx-xxxxx        1/1     Running   0          10m
```

---

### 4. Kubernetes Services Configuration (`kubectl-describe-services.png`)

**What to capture:**
- Output of `kubectl describe services` command
- Should show all services with their configurations:
  - backend-feed (ClusterIP)
  - backend-user (ClusterIP)
  - reverseproxy (LoadBalancer with External IP)
  - frontend (LoadBalancer with External IP)
- **Important:** Ensure no sensitive information (passwords) is visible

**Command:**
```bash
kubectl describe services
```

**What to verify:**
- Service names and types are correct
- Port configurations are correct (8080 for backends, 80 for frontend)
- LoadBalancer services have EXTERNAL-IP assigned
- No database passwords or sensitive data visible

---

### 5. Horizontal Pod Autoscaler (`kubectl-describe-hpa.png`)

**What to capture:**
- Output of `kubectl describe hpa` command
- Should show HPA configuration for at least one backend service
- Display metrics like:
  - Min replicas (e.g., 3)
  - Max replicas (e.g., 5)
  - Target CPU utilization (e.g., 70%)
  - Current metrics and replicas

**Command:**
```bash
kubectl describe hpa
```

**Expected information:**
```
Name:                                                  backend-user
Namespace:                                             default
Reference:                                             Deployment/backend-user
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  <unknown> / 70%
Min replicas:                                          3
Max replicas:                                          5
```

**If HPA not created yet, run:**
```bash
kubectl autoscale deployment backend-user --cpu-percent=70 --min=3 --max=5
```

---

### 6. Backend Pod Logs with User Activity (`kubectl-logs.png`)

**What to capture:**
- Output of `kubectl logs <pod-name>` command
- Logs should show user activity such as:
  - User registration
  - User login
  - API requests
  - Database queries
  - JWT token generation

**Commands:**
```bash
# Get pod name
kubectl get pods

# View logs from backend-user pod
kubectl logs <backend-user-pod-name>
```

**How to generate activity:**
1. Access your application via the frontend External IP
2. Register a new user
3. Log in with the user
4. Post a photo or perform other actions
5. Then capture the logs showing these activities

**Expected log content:**
- Server startup messages
- Database connection messages
- API endpoint hits (POST /api/v0/users/auth/login, etc.)
- JWT token generation
- User authentication logs

---

## Screenshot Requirements

### General Guidelines:
- **Format:** PNG format preferred
- **Quality:** High resolution, text should be clearly readable
- **Content:** Full terminal output or browser window
- **Timestamp:** Recent timestamps showing active deployment
- **Security:** No passwords, AWS keys, or sensitive data visible

### Naming Convention:
1. `dockerhub.png` - DockerHub repositories
2. `travis-ci.png` - Travis CI successful build
3. `kubectl-get-pods.png` - Running pods
4. `kubectl-describe-services.png` - Service configurations
5. `kubectl-describe-hpa.png` - Horizontal Pod Autoscaler
6. `kubectl-logs.png` - Pod logs with user activity

### How to Take Screenshots:

**macOS:**
- Full screen: `Cmd + Shift + 3`
- Selected area: `Cmd + Shift + 4`

**Windows:**
- Snipping Tool or `Windows + Shift + S`

**Linux:**
- `gnome-screenshot` or `import` command

### Verification Checklist:

Before submission, verify:
- [ ] All 6 screenshots are present in `screenshots/` directory
- [ ] Files are named correctly (exact names as above)
- [ ] All text is readable and clear
- [ ] No sensitive information (passwords, AWS keys) is visible
- [ ] Screenshots show recent timestamps/dates
- [ ] All pods show "Running" status
- [ ] Services show assigned External IPs
- [ ] HPA shows proper configuration
- [ ] Logs show actual user activity

---

## Additional Optional Screenshots

While not required, these can be helpful:

- Application running in browser (frontend)
- EKS cluster in AWS Console
- DockerHub repository showing multiple tags
- Travis CI build logs detail
- Kubernetes dashboard (if enabled)

---

## Troubleshooting

### If pods are not running:
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### If LoadBalancer has no External IP:
Wait 5-10 minutes for AWS to provision the load balancer.

### If HPA shows unknown metrics:
Wait a few minutes for metrics to be collected, or install metrics-server:
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### If no logs appear:
Generate activity by:
1. Accessing the application
2. Registering/logging in
3. Posting photos
4. Making API requests

---

## Need Help?

Refer to:
- [DEPLOYMENT_GUIDE.md](../DEPLOYMENT_GUIDE.md) - Complete deployment walkthrough
- [KUBECTL_REFERENCE.md](../KUBECTL_REFERENCE.md) - Kubectl commands reference
- [Project Rubric](https://review.udacity.com/#!/rubrics/2804/view) - Grading criteria
