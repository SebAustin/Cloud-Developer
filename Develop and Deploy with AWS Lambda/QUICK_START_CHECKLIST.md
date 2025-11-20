# Quick Start Checklist

Use this checklist to deploy and test your Serverless TODO application.

## Pre-Deployment Checklist

### ☐ 1. Auth0 Setup
- [ ] Create Auth0 account at https://auth0.com/
- [ ] Create Single Page Web Application
- [ ] Configure Allowed Callback URLs: `http://localhost:3000`
- [ ] Configure Allowed Logout URLs: `http://localhost:3000`
- [ ] Configure Allowed Web Origins: `http://localhost:3000`
- [ ] Verify JWT algorithm is set to RS256
- [ ] Copy Auth0 Domain (e.g., `your-app.us.auth0.com`)
- [ ] Copy Client ID

**Reference**: See `AUTH0_SETUP.md` for detailed instructions

### ☐ 2. Update Backend Auth0 Configuration
- [ ] Open `backend/src/lambda/auth/auth0Authorizer.mjs`
- [ ] Update line 8 with your Auth0 domain:
  ```javascript
  const jwksUrl = 'https://YOUR_AUTH0_DOMAIN/.well-known/jwks.json'
  ```
- [ ] Save the file

### ☐ 3. Verify AWS Credentials
- [ ] AWS CLI is installed: `aws --version`
- [ ] Credentials are configured: `aws sts get-caller-identity`
- [ ] Or export environment variables:
  ```bash
  export AWS_ACCESS_KEY_ID=your_key
  export AWS_SECRET_ACCESS_KEY=your_secret
  export AWS_SESSION_TOKEN=your_token  # if temporary
  ```

### ☐ 4. Verify Node.js and Serverless
- [ ] Node.js 14.x installed: `node --version`
- [ ] Serverless Framework installed: `serverless --version`
- [ ] If not installed: `npm install -g serverless@3.24.1`

## Deployment Checklist

### ☐ 5. Deploy Backend
```bash
cd starter/backend
npm install
serverless deploy --verbose
```

- [ ] Deployment completed successfully
- [ ] Note the API Gateway endpoint URL from output
  - Example: `https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev`
- [ ] Copy this URL for frontend configuration

### ☐ 6. Verify AWS Resources
Log in to AWS Console and verify:
- [ ] CloudFormation stack created: `serverless-todo-app-dev`
- [ ] DynamoDB table exists: `Todos-dev`
- [ ] S3 bucket exists: `serverless-c4-todo-images-dev`
- [ ] 6 Lambda functions created (Auth, GetTodos, CreateTodo, UpdateTodo, DeleteTodo, GenerateUploadUrl)
- [ ] API Gateway created: `dev-serverless-todo-app`

### ☐ 7. Configure Frontend
- [ ] Navigate to `starter/client` directory
- [ ] Create `.env` file with these values:
  ```env
  REACT_APP_AUTH0_DOMAIN=your-tenant.us.auth0.com
  REACT_APP_AUTH0_CLIENT_ID=your_client_id_from_auth0
  REACT_APP_API_ENDPOINT=https://your-api-gateway-url/dev
  ```
- [ ] Replace placeholders with actual values
- [ ] Save the file

### ☐ 8. Start Frontend
```bash
cd starter/client
npm install
npm start
```

- [ ] Development server started
- [ ] Browser opens at http://localhost:3000
- [ ] No compilation errors

## Testing Checklist

### ☐ 9. Test Authentication
- [ ] Click "Log In" button
- [ ] Redirected to Auth0 login page
- [ ] Successfully log in or sign up
- [ ] Redirected back to application
- [ ] See TODO list interface

### ☐ 10. Test Create TODO
- [ ] Enter TODO name: "Test TODO Item"
- [ ] Select due date
- [ ] Click Create or press Enter
- [ ] TODO appears in the list
- [ ] TODO has a unique ID and timestamp

### ☐ 11. Test Upload Image
- [ ] Click pencil/edit icon on a TODO
- [ ] Select an image file (jpg, png)
- [ ] Image uploads successfully
- [ ] Thumbnail appears next to TODO item

### ☐ 12. Test Update TODO
- [ ] Click checkbox to mark TODO as done
- [ ] TODO status updates immediately
- [ ] UI reflects the change (e.g., strikethrough)

### ☐ 13. Test Delete TODO
- [ ] Click delete/trash icon
- [ ] TODO is removed from the list
- [ ] Verify in DynamoDB that item is deleted

### ☐ 14. Test User Isolation
- [ ] Log out from current user
- [ ] Log in with different Auth0 account
- [ ] Verify you don't see previous user's TODOs
- [ ] Create a TODO with second user
- [ ] Log back in as first user
- [ ] Verify first user's TODOs are still there and second user's are not visible

## Monitoring Checklist

### ☐ 15. Check CloudWatch Logs
- [ ] Go to AWS CloudWatch Console
- [ ] Navigate to Log Groups
- [ ] Find log groups: `/aws/lambda/serverless-todo-app-dev-*`
- [ ] Click on a log group
- [ ] Verify logs are being generated
- [ ] Check for any errors

### ☐ 16. Check X-Ray Traces
- [ ] Go to AWS X-Ray Console
- [ ] Click on "Service map"
- [ ] Verify you see services (Lambda, DynamoDB, S3)
- [ ] Click on "Traces"
- [ ] Filter by recent time period
- [ ] Click on a trace to see details
- [ ] Verify all segments are successful

## Troubleshooting

### Common Issues and Quick Fixes

#### 403 Unauthorized Error
- [ ] Verify Auth0 domain in `auth0Authorizer.mjs` is correct
- [ ] Test JWKS URL in browser: `https://your-domain/.well-known/jwks.json`
- [ ] Check CloudWatch logs for Auth function
- [ ] Verify JWT algorithm is RS256 in Auth0 settings

#### CORS Error
- [ ] Verify all callback URLs in Auth0 match exactly
- [ ] Check that `cors: true` is in all functions in `serverless.yml`
- [ ] Verify CORS middleware in all Lambda handlers
- [ ] Clear browser cache and retry

#### Cannot Connect to API
- [ ] Verify `REACT_APP_API_ENDPOINT` in `.env` is correct
- [ ] Check that endpoint includes `/dev` at the end
- [ ] Verify API Gateway is deployed in AWS Console
- [ ] Test endpoint with cURL (see DEPLOYMENT_GUIDE.md)

#### Images Not Uploading
- [ ] Check S3 bucket exists in AWS Console
- [ ] Verify bucket CORS configuration
- [ ] Check CloudWatch logs for GenerateUploadUrl function
- [ ] Ensure presigned URL hasn't expired (5 min TTL)

## Optional: Test with cURL

Get JWT token from browser (Developer Tools > Application > Local Storage), then:

```bash
# Get TODOs
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  https://YOUR_API_ENDPOINT/dev/todos

# Create TODO
curl -X POST \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","dueDate":"2024-12-31"}' \
  https://YOUR_API_ENDPOINT/dev/todos
```

## Cleanup Checklist

When you're done testing and want to remove all resources:

### ☐ 17. Remove AWS Resources
```bash
cd starter/backend

# Empty S3 bucket first
aws s3 rm s3://serverless-c4-todo-images-dev --recursive

# Remove all resources
serverless remove
```

- [ ] CloudFormation stack deleted
- [ ] All Lambda functions removed
- [ ] DynamoDB table deleted
- [ ] S3 bucket deleted
- [ ] API Gateway removed

## Success Criteria

You've successfully completed the setup if:
- ✅ All checklist items are marked
- ✅ Application runs without errors
- ✅ You can create, read, update, delete TODOs
- ✅ Image uploads work
- ✅ User isolation is working
- ✅ CloudWatch logs show activity
- ✅ X-Ray traces are visible

## Need Help?

Refer to these documents:
- **AUTH0_SETUP.md** - Detailed Auth0 configuration
- **DEPLOYMENT_GUIDE.md** - Comprehensive deployment and testing guide
- **README.md** - Project overview and architecture
- **IMPLEMENTATION_SUMMARY.md** - What was implemented

## Estimated Time

- Auth0 Setup: 10-15 minutes
- Backend Deployment: 5-10 minutes
- Frontend Setup: 5 minutes
- Testing: 10-15 minutes
- **Total: 30-45 minutes**

---

**Good luck! 🚀**

