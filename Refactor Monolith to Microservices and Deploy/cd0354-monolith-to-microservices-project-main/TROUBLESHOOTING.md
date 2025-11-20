# Troubleshooting Guide

## Current Issue: "Http failure response... Unknown Error"

### What's Happening

You're seeing these errors in the Udagram frontend:
- `Http failure response for http://localhost:8080/api/v0/feed: 0 Unknown Error`
- `Http failure response for http://localhost:8080/api/v0/users/auth/: 0 Unknown Error`

### Root Causes

1. **Backend services are not running** - The containers crashed due to:
   - Missing environment variables
   - TypeScript compilation errors
   - No database to connect to

2. **Environment variables not set** - Running `docker-compose up` without setting environment variables causes the backend to fail

3. **No AWS RDS database** - The application requires a real PostgreSQL database to function

### What Was Fixed ✅

1. **TypeScript Error Fixed:**
   - Fixed `sequelize.ts` in both `udagram-api-feed` and `udagram-api-user`
   - Changed `'dialect': config.dialect` to `'dialect': 'postgres'`

2. **Test Script Created:**
   - Created `run-local-test.sh` for quick testing
   - Sets temporary environment variables
   - Rebuilds and runs containers

## Solutions

### Option 1: Quick Test (See If Containers Start)

Run the test script:

```bash
./run-local-test.sh
```

**What to expect:**
- ✅ Frontend loads at http://localhost:8100
- ✅ Reverse proxy starts
- ⚠️ Backend services will show database connection errors (expected!)
- ❌ You won't be able to register/login (no database)

**This is useful to verify:**
- Docker images build correctly
- Containers can start
- Frontend serves properly
- Reverse proxy routes correctly

### Option 2: Full Setup with Real AWS Resources (Required for Submission)

To get the application fully working, you **must** create AWS resources:

#### Step 1: Create AWS RDS PostgreSQL Database

Follow `SETUP_GUIDE.md` section "Create AWS Resources" → "2. Create RDS PostgreSQL Database"

**Quick steps:**
1. Go to AWS Console → RDS → Create database
2. Choose PostgreSQL (version 12-15)
3. Settings:
   - DB identifier: `udagram-db`
   - Master username: `udagramadmin`
   - Create strong password
4. **Important:** Set "Public access" to **Yes**
5. Create database (takes ~10 minutes)
6. Note the **Endpoint URL** (e.g., `udagram-db.xxxxx.us-east-1.rds.amazonaws.com`)
7. Edit security group to allow connections on port 5432

#### Step 2: Create AWS S3 Bucket

Follow `SETUP_GUIDE.md` section "3. Create S3 Bucket"

**Quick steps:**
1. Go to AWS Console → S3 → Create bucket
2. Choose unique name: `udagram-YOUR-NAME-RANDOM-NUMBER`
3. Uncheck "Block all public access"
4. Create bucket
5. Configure CORS (see SETUP_GUIDE.md for JSON)
6. Add bucket policy for public read access

#### Step 3: Update set_env.sh with Real Credentials

```bash
# Edit the file
nano set_env.sh

# Update with YOUR actual values:
export POSTGRES_USERNAME=udagramadmin
export POSTGRES_PASSWORD=YOUR_RDS_PASSWORD
export POSTGRES_HOST=YOUR-RDS-ENDPOINT.us-east-1.rds.amazonaws.com
export POSTGRES_DB=postgres
export AWS_BUCKET=YOUR-BUCKET-NAME
export AWS_REGION=us-east-1
export AWS_PROFILE=default
export JWT_SECRET=$(openssl rand -base64 32)
export URL=http://localhost:8100
```

#### Step 4: Run with Real Credentials

```bash
# Load real environment variables
source set_env.sh

# Verify they're loaded
echo $POSTGRES_HOST  # Should show your RDS endpoint

# Rebuild images (code was fixed)
docker-compose -f docker-compose-build.yaml build

# Start services
docker-compose up
```

**Now you should see:**
- ✅ Backend connects to database
- ✅ You can register new users
- ✅ You can login
- ✅ You can post photos (uploaded to S3)

## Common Errors and Solutions

### Error: "ECONNREFUSED" or "Connection refused"

**Cause:** Backend services aren't running or crashed

**Solution:**
```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs backend-user
docker-compose logs backend-feed

# Restart
docker-compose down
docker-compose up
```

### Error: "Connection timeout" to database

**Causes:**
1. RDS security group doesn't allow your IP
2. Wrong RDS endpoint in environment variables
3. Database not publicly accessible

**Solutions:**
1. Go to AWS RDS → Your DB → Security group → Edit inbound rules
2. Add rule: PostgreSQL (port 5432), Source: 0.0.0.0/0
3. Verify POSTGRES_HOST in `set_env.sh` matches RDS endpoint exactly

### Error: "Access Denied" to S3

**Causes:**
1. AWS credentials not configured
2. S3 bucket policy not set correctly

**Solutions:**
```bash
# Configure AWS CLI
aws configure

# Test access
aws s3 ls s3://YOUR-BUCKET-NAME

# If fails, check bucket policy in AWS Console
```

### Error: Frontend loads but shows login errors

**Cause:** Backend services aren't healthy

**Check backend health:**
```bash
# Test backend directly
curl http://localhost:8080/api/v0/feed

# Should return JSON (empty array is ok)
# If no response, backend is down
```

### Error: "Unknown Error" in browser console

**Causes:**
1. Backend not running
2. CORS issues
3. Wrong API endpoint

**Solutions:**
1. Check browser console (F12) for detailed errors
2. Verify reverseproxy is running: `docker-compose ps`
3. Test API directly in browser: http://localhost:8080/api/v0/feed

## Debugging Commands

### Check Container Status
```bash
# List running containers
docker-compose ps

# Expected output: All 4 services "Up"
```

### View Container Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs backend-user
docker-compose logs backend-feed
docker-compose logs reverseproxy
docker-compose logs frontend

# Follow logs (live)
docker-compose logs -f backend-user
```

### Test Backend Directly
```bash
# Feed endpoint
curl http://localhost:8080/api/v0/feed

# Should return: [] or array of posts

# Users endpoint (should fail without auth)
curl http://localhost:8080/api/v0/users/auth/
```

### Restart Everything
```bash
# Stop all containers
docker-compose down

# Remove volumes
docker-compose down -v

# Rebuild images
docker-compose -f docker-compose-build.yaml build --no-cache

# Start fresh
docker-compose up
```

### Check Environment Variables in Container
```bash
# Get running container name
docker-compose ps

# Check environment variables
docker-compose exec backend-user printenv | grep POSTGRES
```

## What You Should See When Working Correctly

### Terminal Output
```
backend-user-1  | server running http://localhost:8100
backend-user-1  | press CTRL+C to stop server
backend-feed-1  | server running http://localhost:8100
backend-feed-1  | press CTRL+C to stop server
reverseproxy-1  | [notice] 1#1: start worker processes
frontend-1      | [notice] 1#1: start worker processes
```

### Browser
- Frontend loads at http://localhost:8100
- You can click "Register" and create account
- You can login with credentials
- You can post photos
- No error messages in browser console

### Testing Flow
1. Go to http://localhost:8100
2. Click "Register"
3. Fill in: Name, Email, Password
4. Click "Register" button
5. Should redirect to feed page
6. No errors should appear

## Still Not Working?

### If Containers Won't Start:
1. Check Docker Desktop is running
2. Check you have enough disk space
3. Try: `docker system prune -a` (removes all unused images)
4. Rebuild: `docker-compose -f docker-compose-build.yaml build --no-cache`

### If Database Errors Persist:
1. Verify RDS database is running in AWS Console
2. Test connection from your computer:
   ```bash
   psql -h YOUR-RDS-ENDPOINT -U udagramadmin -d postgres
   # Enter password when prompted
   ```
3. If connection fails, check RDS security group settings

### If Still Stuck:
1. Read `SETUP_GUIDE.md` for detailed AWS setup
2. Read `IMPLEMENTATION_SUMMARY.md` for project status
3. Read `DEPLOYMENT_GUIDE.md` for deployment steps

## Important Notes

⚠️ **The application REQUIRES real AWS resources to function:**
- AWS RDS PostgreSQL database
- AWS S3 bucket
- AWS IAM credentials

⚠️ **Environment variables MUST be set before running:**
```bash
source set_env.sh  # Always run this first!
docker-compose up
```

⚠️ **Local testing without AWS resources will show errors:**
- Backend will fail to connect to database
- Photo uploads will fail
- User registration will fail

✅ **For project submission, you need:**
- Real AWS RDS and S3
- Environment variables configured
- Travis CI pipeline
- Kubernetes deployment on EKS

## Next Steps

1. **If you want to test Docker setup only:**
   - Run `./run-local-test.sh`
   - Expect database errors (normal)
   - Verify containers can start

2. **If you want full functionality:**
   - Follow `SETUP_GUIDE.md` to create AWS resources
   - Update `set_env.sh` with real credentials
   - Run `source set_env.sh && docker-compose up`
   - Everything should work

3. **For project submission:**
   - Complete AWS setup
   - Test locally until working
   - Deploy to Kubernetes (see `DEPLOYMENT_GUIDE.md`)
   - Capture screenshots

---

**Current Status:**
- ✅ Code fixed (TypeScript error resolved)
- ✅ Docker images build successfully
- ✅ Test script created
- ⚠️ Needs AWS resources for full functionality

**What you saw (Http failure errors) is expected without AWS resources!**

