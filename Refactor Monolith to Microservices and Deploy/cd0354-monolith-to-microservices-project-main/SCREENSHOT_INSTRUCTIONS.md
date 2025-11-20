# Screenshot Instructions for Reviewer Submission

## ✅ Current Status
All infrastructure is deployed and working correctly:
- ✅ EKS Cluster running with 2 nodes
- ✅ RDS PostgreSQL database connected
- ✅ All pods running (8 total)
- ✅ HPAs configured and showing NUMERIC CPU metrics (not <unknown>)
- ✅ User activity generated (registrations, logins, signed URLs)
- ✅ Metrics Server fully operational

## 📸 Screenshots Needed

You need to take **2 screenshots** and replace the existing files:

### Screenshot 1: HPA with Numeric CPU Metrics
**File**: `screenshots/hpa.png`

**Command to run**:
```bash
kubectl describe hpa
```

**What to capture**: The entire terminal output showing all 4 HPAs with:
- ✅ **backend-feed-hpa**: Shows `cpu: 0% (1m) / 70%` (numeric value)
- ✅ **backend-user-hpa**: Shows `cpu: 2% (6m) / 70%` (numeric value)
- ✅ **frontend-hpa**: Shows `cpu: 0% (0) / 70%` (numeric value)
- ✅ **reverseproxy-hpa**: Shows `cpu: 1% (1m) / 70%` (numeric value)

**Key points for reviewer**:
- All HPAs show NUMERIC CPU percentages (not `<unknown>`)
- This proves the Metrics Server is working correctly
- HPAs can successfully scale based on CPU utilization

---

### Screenshot 2: Backend Logs with User Activity
**File**: `screenshots/logs.png`

**Command to run**:
```bash
kubectl logs deployment/backend-user --tail=100
```

Or for a specific pod with good activity:
```bash
kubectl logs pod/backend-user-5c8f7dd546-vp2vp --tail=100
```

**What to capture**: Backend logs showing:
- ✅ Database initialization
- ✅ **User registration** (INSERT INTO "Users" statements)
- ✅ **User login** (SELECT FROM "Users" WHERE email = statements)
- ✅ Multiple user activities (testuser@example.com, user1@test.com, user2@test.com, user3@test.com)

**Key points for reviewer**:
- Logs show actual user activity (not just startup logs)
- Registration operations are visible (INSERT statements)
- Authentication operations are visible (SELECT statements)
- Database connectivity is working across services

---

## 🎯 How to Take Screenshots

### Option 1: macOS (Recommended)
1. Run the command in your terminal
2. Press **Cmd + Shift + 4**
3. Drag to select the terminal window area
4. Screenshot saves to Desktop
5. Rename and move to `screenshots/` folder

### Option 2: Use Terminal Screenshot Tool
```bash
# For HPA
kubectl describe hpa > hpa_output.txt
# Take screenshot of the text file opened in an editor

# For Logs  
kubectl logs deployment/backend-user --tail=100 > logs_output.txt
# Take screenshot of the text file opened in an editor
```

### Option 3: Use `screencapture` (macOS Terminal)
```bash
# Run the command, then:
screencapture -w screenshots/hpa.png
# Click on the terminal window showing the HPA output

screencapture -w screenshots/logs.png
# Click on the terminal window showing the logs
```

---

## 🔍 Quick Verification

Before taking screenshots, verify everything is correct:

```bash
# Verify HPAs show numeric values
kubectl get hpa
# Should show: backend-feed-hpa, backend-user-hpa, frontend-hpa, reverseproxy-hpa
# All with numeric CPU percentages like "0%/70%", "2%/70%", etc.

# Verify backend logs show activity
kubectl logs deployment/backend-user --tail=50 | grep -E "(INSERT|SELECT|Users)"
# Should show multiple INSERT and SELECT statements for user operations
```

---

## ✅ Checklist

- [ ] Screenshot 1: `screenshots/hpa.png` - Shows `kubectl describe hpa` with numeric CPU metrics
- [ ] Screenshot 2: `screenshots/logs.png` - Shows backend logs with user registration/login activity
- [ ] Both screenshots are clear and readable
- [ ] File names are exactly as specified

---

## 📋 Current Output Saved

For reference, the current output has been saved to:
- `/tmp/hpa_output.txt` - HPA description
- `/tmp/backend_logs.txt` - Backend logs with user activity

You can view these files to see what the screenshots should contain:
```bash
cat /tmp/hpa_output.txt
cat /tmp/backend_logs.txt
```

---

## 🚀 Deployment Summary

**Application URLs**:
- Frontend: http://a9c4b6dd23f7547b48c4630c621e21fa-338768861.us-east-1.elb.amazonaws.com:8100
- API: http://afd2acce063a64dcda39f835a1c0a3e1-1832179754.us-east-1.elb.amazonaws.com:8080

**Resources Deployed**:
- EKS Cluster: `udagram-cluster` (us-east-1)
- RDS Database: `udagram-db.cqsztjfp6yxe.us-east-1.rds.amazonaws.com`
- S3 Bucket: `udagram-shenry-13277`
- Pods: 8 running (backend-feed: 5, backend-user: 3, frontend: 2, reverseproxy: 2)
- HPAs: 4 configured and working with numeric CPU metrics

---

## 🎓 Reviewer Requirements Met

✅ **HPA Requirement**: HPAs show numeric CPU metrics (not `<unknown>`)
- Metrics Server installed and operational
- All 4 services have working HPAs
- CPU percentages visible (0%/70%, 2%/70%, etc.)

✅ **Logs Requirement**: Backend logs show actual user activity
- User registration events (INSERT INTO Users)
- User authentication events (SELECT FROM Users)
- Multiple users registered and logged in
- Database queries executed successfully

---

**Once you've taken and saved both screenshots, you're ready to resubmit the project!**

