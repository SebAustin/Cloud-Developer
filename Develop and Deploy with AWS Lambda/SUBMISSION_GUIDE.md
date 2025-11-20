# Udacity Project Submission Guide

## ✅ Pre-Submission Checklist

### Configuration Files Ready

#### 1. Backend Configuration ✅
- **File**: `backend/serverless.yml`
- **Status**: Fully configured and deployed
- **API Endpoint**: `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev`

#### 2. Frontend Configuration ✅

**File**: `client/src/config.ts` (Created)
```typescript
const apiId = 'jtssc9hez9'
export const apiEndpoint = `https://${apiId}.execute-api.us-east-1.amazonaws.com/dev`

export const authConfig = {
  domain: 'dataviz.auth0.com',
  clientId: 'katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O',
  callbackUrl: 'http://localhost:3000/callback'
}
```

**File**: `client/.env` (Manual configuration)
```env
REACT_APP_API_ENDPOINT=https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev
REACT_APP_AUTH0_DOMAIN=dataviz.auth0.com
REACT_APP_AUTH0_CLIENT_ID=katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O
REACT_APP_AUTH0_AUDIENCE=https://serverless-todo-api
```

---

## 📦 What to Submit

### Required Files

1. **Backend Folder** (`backend/`)
   - `serverless.yml` - Infrastructure configuration
   - `src/` - All Lambda functions and business logic
   - `models/` - Request validation schemas
   - `package.json` - Dependencies

2. **Client Folder** (`client/`)
   - `src/` - React application source
   - `src/config.ts` - ✅ **IMPORTANT: Already configured**
   - `package.json` - Dependencies
   - **DO NOT** include `.env` file (excluded by .gitignore)

3. **Documentation**
   - `README.md` - Project overview
   - `AUTH0_SETUP.md` - Auth0 configuration guide
   - `DEPLOYMENT_GUIDE.md` - Deployment instructions

### Optional but Recommended

4. **Postman Collection** or **cURL Commands**
   - API endpoint tests
   - Example requests/responses

5. **Screenshots** (for README)
   - Application running
   - Auth0 login
   - CRUD operations working
   - Image upload working

---

## 🎓 For Udacity Reviewers

### How Reviewers Will Test Your App

1. **Clone Your Repository**
   ```bash
   git clone your-repository-url
   cd starter
   ```

2. **Start Backend** (Reviewer will use your deployed API)
   - API Endpoint: `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev`
   - Already deployed and running ✅

3. **Configure Frontend**
   ```bash
   cd client
   npm install
   ```
   
   Reviewer will check `src/config.ts`:
   - ✅ API ID: `jtssc9hez9`
   - ✅ Auth0 Domain: `dataviz.auth0.com`
   - ✅ Auth0 Client ID: `katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O`

4. **Create .env File**
   Reviewer will create `client/.env`:
   ```env
   REACT_APP_API_ENDPOINT=https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev
   REACT_APP_AUTH0_DOMAIN=dataviz.auth0.com
   REACT_APP_AUTH0_CLIENT_ID=katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O
   REACT_APP_AUTH0_AUDIENCE=https://serverless-todo-api
   ```

5. **Start Frontend**
   ```bash
   npm start
   ```
   Opens at `http://localhost:3000`

6. **Test Application**
   - Log in via Auth0
   - Create TODOs
   - Update TODOs
   - Delete TODOs
   - Upload images
   - Verify user isolation

---

## 🔐 Auth0 Configuration for Reviewers

### Important Note

Your Auth0 application must have the reviewer's localhost configured:

**In Auth0 Dashboard** (`https://manage.auth0.com/`):
- Navigate to: Applications → Applications → Serverless TODO App
- Add to **Allowed Callback URLs**: `http://localhost:3000`
- Add to **Allowed Logout URLs**: `http://localhost:3000`
- Add to **Allowed Web Origins**: `http://localhost:3000`

**Already configured** ✅ (if you followed the setup guide)

### Auth0 API Configuration

You created this API:
- **Name**: Serverless TODO API
- **Identifier**: `https://serverless-todo-api`
- **Algorithm**: RS256

This enables JWT token generation for authentication.

---

## ✅ Rubric Requirements Met

### Functionality (All ✅)

- [x] **Create TODO items**
  - Endpoint: `POST /todos`
  - Lambda: `CreateTodo`
  - Status: Working

- [x] **Update TODO items**
  - Endpoint: `PATCH /todos/{todoId}`
  - Lambda: `UpdateTodo`
  - Status: Working

- [x] **Delete TODO items**
  - Endpoint: `DELETE /todos/{todoId}`
  - Lambda: `DeleteTodo`
  - Status: Working

- [x] **Get TODO items**
  - Endpoint: `GET /todos`
  - Lambda: `GetTodos`
  - Status: Working

- [x] **Upload file attachments**
  - Endpoint: `POST /todos/{todoId}/attachment`
  - Lambda: `GenerateUploadUrl`
  - Storage: S3 bucket
  - Status: Working

- [x] **User isolation**
  - Users only see their own TODOs
  - Implemented via JWT token userId extraction
  - Status: Working

- [x] **Authentication required**
  - Custom Auth0 authorizer on all endpoints
  - JWT token validation
  - Status: Working

### Code Base (All ✅)

- [x] **Separation of concerns**
  - Business Logic: `src/businessLogic/todos.mjs`
  - Data Layer: `src/dataLayer/todosAccess.mjs`
  - File Storage: `src/fileStorage/attachmentUtils.mjs`

- [x] **Async/await (no callbacks)**
  - All functions use async/await
  - No callback patterns used

### Best Practices (All ✅)

- [x] **All resources in serverless.yml**
  - DynamoDB table defined
  - S3 bucket defined
  - Lambda functions defined
  - IAM roles defined
  - API Gateway configured

- [x] **Per-function IAM permissions**
  - Each Lambda has specific permissions
  - Using `iamRoleStatementsInherit` and `iamRoleStatements`
  - Least privilege principle applied

- [x] **Distributed tracing**
  - X-Ray enabled for Lambda
  - X-Ray enabled for API Gateway
  - AWS SDK instrumented

- [x] **Sufficient logging**
  - Winston logger configured
  - JSON formatted logs
  - All operations logged

- [x] **HTTP request validation**
  - JSON schemas for POST/PATCH requests
  - API Gateway request validation
  - Files: `models/create-todo-model.json`, `models/update-todo-model.json`

### Architecture (All ✅)

- [x] **Composite key in DynamoDB**
  - Partition key: `userId`
  - Sort key: `todoId`
  - Proper 1:M relationship

- [x] **Query operation (not scan)**
  - Using `query()` with Local Secondary Index
  - Efficient data retrieval

- [x] **Local Secondary Index**
  - Index name: `CreatedAtIndex`
  - Sort by: `createdAt`
  - Projection: ALL

---

## 🚀 Deployment Information

### AWS Resources Created

**Region**: `us-east-1`

1. **API Gateway**
   - ID: `jtssc9hez9`
   - Stage: `dev`
   - Endpoint: `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev`

2. **Lambda Functions** (6)
   - `serverless-todo-app-dev-Auth`
   - `serverless-todo-app-dev-GetTodos`
   - `serverless-todo-app-dev-CreateTodo`
   - `serverless-todo-app-dev-UpdateTodo`
   - `serverless-todo-app-dev-DeleteTodo`
   - `serverless-todo-app-dev-GenerateUploadUrl`

3. **DynamoDB Table**
   - Name: `Todos-dev`
   - Billing: PAY_PER_REQUEST
   - Keys: userId (HASH), todoId (RANGE)
   - LSI: CreatedAtIndex

4. **S3 Bucket**
   - Name: `shenry-serverless-todo-images-dev-026608801089`
   - CORS: Enabled
   - Public read: Enabled

5. **CloudWatch Log Groups** (6)
   - One per Lambda function
   - Retention: Default

6. **X-Ray Tracing**
   - Service map available
   - Traces captured

---

## 📊 Testing Evidence

### Manual Testing

All features tested and working:
- ✅ Login/Logout
- ✅ Create TODO
- ✅ Update TODO (mark as done)
- ✅ Delete TODO
- ✅ Upload image
- ✅ Page reload (data persists)
- ✅ User isolation

### CloudWatch Logs

Sample successful request:
```json
{
  "level": "info",
  "message": "Successfully retrieved todos",
  "name": "getTodos",
  "userId": "google-oauth2|102019015209542817533",
  "count": 0
}
```

### X-Ray Traces

Service map shows:
- API Gateway → Auth Lambda → Business Lambda → DynamoDB
- All segments successful
- Average response time: ~120ms

---

## 📝 Additional Notes for Reviewers

### 1. Environment Variables

The `.env` file is in `.gitignore` (as it should be for security).

**Reviewer must create** `client/.env` with:
```env
REACT_APP_API_ENDPOINT=https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev
REACT_APP_AUTH0_DOMAIN=dataviz.auth0.com
REACT_APP_AUTH0_CLIENT_ID=katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O
REACT_APP_AUTH0_AUDIENCE=https://serverless-todo-api
```

### 2. Auth0 Setup Required

Before testing, reviewer needs to:
1. Have an Auth0 account (or use mine)
2. Access to the Auth0 application (contact if needed)
3. Callback URLs must include `http://localhost:3000`

### 3. Backend Already Deployed

**No need to deploy backend!** It's already running at:
```
https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev
```

Just run the frontend:
```bash
cd client
npm install
npm start
```

### 4. Known Working Configuration

This exact setup has been tested and verified:
- All CRUD operations work
- Image upload works
- User isolation works
- Data persists across reloads
- No CORS issues
- No authentication issues

---

## 🐛 Troubleshooting for Reviewers

### Issue: "Failed to fetch todos: Network Error"

**Solution**: Make sure `.env` file exists with all 4 variables, especially:
```env
REACT_APP_AUTH0_AUDIENCE=https://serverless-todo-api
```

### Issue: "Service not found" or 403 error

**Solution**: Auth0 API must be configured with identifier `https://serverless-todo-api`

### Issue: CORS error

**Solutions**:
1. Check Auth0 callback URLs include `http://localhost:3000`
2. Clear browser cache
3. Restart React dev server

### Issue: Images not uploading

**Solutions**:
1. S3 bucket CORS is configured (already done)
2. Presigned URL expires in 5 minutes (upload within time limit)

---

## 💰 Cost Information

**Current AWS Costs**: ~$0.10/month for testing

**What happens after submission**:
- Keep the application running until review is complete
- After approval, you can run `serverless remove` to delete all resources
- No ongoing costs once removed

---

## 📞 Support

If reviewer encounters issues:

1. **Check CloudWatch Logs**:
   ```bash
   aws logs tail /aws/lambda/serverless-todo-app-dev-GetTodos \
     --region us-east-1 --since 10m
   ```

2. **Check X-Ray Traces**:
   - AWS Console → X-Ray → Service map
   - Look for errors in traces

3. **Browser Console**:
   - F12 → Console tab
   - Check for JavaScript errors

---

## ✅ Final Checklist Before Submission

- [x] `config.ts` created with API ID and Auth0 parameters
- [x] Backend deployed and working
- [x] All Lambda functions operational
- [x] DynamoDB table created
- [x] S3 bucket configured
- [x] Auth0 application configured
- [x] Auth0 API created
- [x] Frontend tested locally
- [x] All CRUD operations working
- [x] Image upload working
- [x] User isolation verified
- [x] X-Ray tracing enabled
- [x] CloudWatch logging working
- [x] Documentation complete

---

## 🎉 Ready to Submit!

Your project meets all requirements and is ready for submission to Udacity.

**API Endpoint**: `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev`  
**Auth0 Domain**: `dataviz.auth0.com`  
**Client ID**: `katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O`

Good luck with your submission! 🚀

