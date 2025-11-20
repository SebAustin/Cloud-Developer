# Deployment and Testing Guide

This guide provides step-by-step instructions for deploying the Serverless TODO application to AWS and testing it end-to-end.

## Prerequisites

Before you begin, ensure you have:

- ✅ AWS account with appropriate permissions
- ✅ AWS CLI configured with credentials
- ✅ Node.js (version 14.x) installed
- ✅ Serverless Framework installed globally
- ✅ Auth0 account and application configured (see [AUTH0_SETUP.md](./AUTH0_SETUP.md))

## Part 1: Backend Deployment

### Step 1: Install Backend Dependencies

```bash
cd starter/backend
npm install
```

If you encounter any issues with package versions:

```bash
npm update --save
npm audit fix
```

### Step 2: Verify Serverless Framework Installation

Check if Serverless is installed:

```bash
serverless --version
```

If not installed, install it globally:

```bash
npm install -g serverless@3.24.1
```

### Step 3: Configure AWS Credentials

If you haven't already configured Serverless with AWS credentials:

```bash
# Login to Serverless dashboard (opens browser)
serverless login

# Configure AWS credentials
sls config credentials --provider aws --key YOUR_ACCESS_KEY_ID --secret YOUR_SECRET_KEY --profile serverless
```

Alternatively, you can use AWS CLI to configure credentials:

```bash
aws configure
```

Or export credentials as environment variables:

```bash
export AWS_ACCESS_KEY_ID=your_access_key_id
export AWS_SECRET_ACCESS_KEY=your_secret_access_key
export AWS_SESSION_TOKEN=your_session_token  # If using temporary credentials
```

### Step 4: Update Auth0 Configuration

Before deploying, update the Auth0 domain in the authorizer:

1. Open `src/lambda/auth/auth0Authorizer.mjs`
2. Replace `YOUR_AUTH0_DOMAIN` with your actual Auth0 domain:
   ```javascript
   const jwksUrl = 'https://your-tenant.us.auth0.com/.well-known/jwks.json'
   ```

### Step 5: Deploy to AWS

Deploy the backend with verbose logging:

```bash
serverless deploy --verbose
```

Or using the shorthand:

```bash
sls deploy -v
```

If you're using a specific AWS profile:

```bash
sls deploy -v --aws-profile serverless
```

### Step 6: Note the API Endpoint

After successful deployment, you'll see output similar to:

```
Service Information
service: serverless-todo-app
stage: dev
region: us-east-1
stack: serverless-todo-app-dev
endpoints:
  GET - https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev/todos
  POST - https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev/todos
  PATCH - https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev/todos/{todoId}
  DELETE - https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev/todos/{todoId}
  POST - https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev/todos/{todoId}/attachment
functions:
  Auth: serverless-todo-app-dev-Auth
  GetTodos: serverless-todo-app-dev-GetTodos
  CreateTodo: serverless-todo-app-dev-CreateTodo
  UpdateTodo: serverless-todo-app-dev-UpdateTodo
  DeleteTodo: serverless-todo-app-dev-DeleteTodo
  GenerateUploadUrl: serverless-todo-app-dev-GenerateUploadUrl
```

**Important:** Copy the base URL (e.g., `https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev`) - you'll need it for the frontend configuration.

## Part 2: Verify AWS Resources

### Check CloudFormation Stack

1. Log in to [AWS Console](https://console.aws.amazon.com/)
2. Navigate to **CloudFormation**
3. Look for stack named `serverless-todo-app-dev`
4. Check that the status is `CREATE_COMPLETE` or `UPDATE_COMPLETE`

### Verify DynamoDB Table

1. Navigate to **DynamoDB** in AWS Console
2. Click **Tables** in the left sidebar
3. Find the table `Todos-dev`
4. Click on the table and verify:
   - Partition key: `userId` (String)
   - Sort key: `todoId` (String)
   - Local Secondary Index: `CreatedAtIndex` with sort key `createdAt`

### Verify S3 Bucket

1. Navigate to **S3** in AWS Console
2. Find bucket `serverless-c4-todo-images-dev`
3. Verify CORS configuration:
   - Click on the bucket
   - Go to **Permissions** tab
   - Scroll to **Cross-origin resource sharing (CORS)**
   - Verify CORS rules are configured

### Verify Lambda Functions

1. Navigate to **Lambda** in AWS Console
2. You should see 6 functions:
   - `serverless-todo-app-dev-Auth`
   - `serverless-todo-app-dev-GetTodos`
   - `serverless-todo-app-dev-CreateTodo`
   - `serverless-todo-app-dev-UpdateTodo`
   - `serverless-todo-app-dev-DeleteTodo`
   - `serverless-todo-app-dev-GenerateUploadUrl`

### Verify API Gateway

1. Navigate to **API Gateway** in AWS Console
2. Find the API `dev-serverless-todo-app`
3. Click on **Stages** in the left sidebar
4. Click on the `dev` stage
5. Verify all endpoints are listed

## Part 3: Frontend Configuration and Deployment

### Step 1: Configure Frontend Environment

1. Navigate to the client folder:
   ```bash
   cd ../client
   ```

2. Create or update the `.env` file:
   ```env
   REACT_APP_AUTH0_DOMAIN=your-tenant.us.auth0.com
   REACT_APP_AUTH0_CLIENT_ID=your_auth0_client_id
   REACT_APP_API_ENDPOINT=https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev
   ```

   Replace:
   - `your-tenant.us.auth0.com` with your Auth0 domain
   - `your_auth0_client_id` with your Auth0 Client ID
   - The API endpoint URL with your actual API Gateway endpoint from Step 6 above

### Step 2: Install Frontend Dependencies

```bash
npm install
```

### Step 3: Start the Development Server

```bash
npm start
```

The application should automatically open in your browser at `http://localhost:3000`.

## Part 4: Testing the Application

### Test 1: Authentication

1. Open the application at `http://localhost:3000`
2. Click **Log In**
3. You should be redirected to Auth0 login page
4. Sign up for a new account or log in with existing credentials
5. After successful authentication, you should be redirected back to the application

**Expected Result:** You should see the TODO list interface (initially empty).

### Test 2: Create a TODO

1. After logging in, you should see a text input field
2. Enter a TODO name (e.g., "Buy groceries")
3. Select a due date
4. Click **Create** or press Enter

**Expected Result:** 
- The TODO should appear in the list
- Status code 201 should be returned
- The TODO should have a unique `todoId`

### Test 3: Upload an Image

1. Find a TODO item in the list
2. Click the **pencil/edit** icon
3. Select an image file from your computer
4. Click upload

**Expected Result:**
- The image should upload successfully
- You should see the image thumbnail next to the TODO item
- The image URL should be stored in the `attachmentUrl` field

### Test 4: Update a TODO

1. Click the checkbox next to a TODO item to mark it as done
2. The TODO should be updated immediately

**Expected Result:**
- The `done` status should change to `true`
- Status code 204 should be returned
- The UI should reflect the change (e.g., strikethrough text)

### Test 5: Delete a TODO

1. Find a TODO item
2. Click the **delete/trash** icon

**Expected Result:**
- The TODO should be removed from the list
- Status code 204 should be returned
- The item should be deleted from DynamoDB

### Test 6: User Isolation

1. Log out from the current user
2. Log in with a different Auth0 account
3. Verify that you don't see the previous user's TODOs

**Expected Result:** Each user should only see their own TODO items.

## Part 5: Testing with cURL Commands

You can also test the API directly using cURL. First, you'll need to get a JWT token.

### Get JWT Token

1. Log in to the frontend application
2. Open browser Developer Tools (F12)
3. Go to the **Application** or **Storage** tab
4. Find the Auth0 token in Local Storage or Session Storage
5. Copy the token value

### Test GET All TODOs

```bash
curl --location --request GET 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/dev/todos' \
--header 'Authorization: Bearer YOUR_JWT_TOKEN'
```

**Expected Response:**
```json
{
  "items": [
    {
      "todoId": "123-456-789",
      "userId": "auth0|123456",
      "createdAt": "2024-11-15T10:30:00.000Z",
      "name": "Buy groceries",
      "dueDate": "2024-11-20",
      "done": false,
      "attachmentUrl": "https://s3-bucket-url/123-456-789"
    }
  ]
}
```

### Test CREATE TODO

```bash
curl --location --request POST 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/dev/todos' \
--header 'Authorization: Bearer YOUR_JWT_TOKEN' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Buy bread",
    "dueDate": "2024-12-12"
}'
```

**Expected Response:**
```json
{
  "item": {
    "userId": "auth0|123456",
    "todoId": "new-todo-id",
    "createdAt": "2024-11-15T10:35:00.000Z",
    "name": "Buy bread",
    "dueDate": "2024-12-12",
    "done": false,
    "attachmentUrl": null
  }
}
```

### Test UPDATE TODO

```bash
curl --location --request PATCH 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/dev/todos/TODO_ID' \
--header 'Authorization: Bearer YOUR_JWT_TOKEN' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Buy organic bread",
    "dueDate": "2024-12-12",
    "done": true
}'
```

**Expected Response:** Status code 204 (No Content)

### Test DELETE TODO

```bash
curl --location --request DELETE 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/dev/todos/TODO_ID' \
--header 'Authorization: Bearer YOUR_JWT_TOKEN'
```

**Expected Response:** Status code 204 (No Content)

### Test GENERATE Upload URL

```bash
curl --location --request POST 'https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/dev/todos/TODO_ID/attachment' \
--header 'Authorization: Bearer YOUR_JWT_TOKEN'
```

**Expected Response:**
```json
{
  "uploadUrl": "https://s3-bucket-name.s3.us-east-1.amazonaws.com/todo-id?AWSAccessKeyId=...&Expires=...&Signature=..."
}
```

### Upload Image Using Presigned URL

```bash
curl -X PUT -T image.jpg -L "PRESIGNED_URL_FROM_ABOVE"
```

## Part 6: Monitoring and Logs

### View CloudWatch Logs

1. Navigate to **CloudWatch** in AWS Console
2. Click on **Log groups** in the left sidebar
3. Find log groups starting with `/aws/lambda/serverless-todo-app-dev-`
4. Click on a log group to view log streams
5. Click on a log stream to view detailed logs

### View X-Ray Traces

1. Navigate to **X-Ray** in AWS Console
2. Click on **Service map** to see visual representation
3. Click on **Traces** to see individual request traces
4. Filter traces by time range or response code

### Check API Gateway Logs

1. Navigate to **API Gateway** in AWS Console
2. Click on your API
3. Go to **Stages** > **dev**
4. Click on **Logs/Tracing** tab
5. View CloudWatch log group link

## Troubleshooting

### Issue: 403 Unauthorized Error

**Cause:** Auth0 token verification failing

**Solution:**
1. Check that Auth0 domain is correct in `auth0Authorizer.mjs`
2. Verify JWKS URL is accessible: `https://your-domain/.well-known/jwks.json`
3. Check CloudWatch logs for the Auth function
4. Ensure JWT signature algorithm is RS256 in Auth0 settings

### Issue: CORS Error

**Cause:** CORS not properly configured

**Solution:**
1. Verify `cors: true` is set in all function definitions in `serverless.yml`
2. Check that CORS middleware is used in all Lambda handlers
3. Verify `GatewayResponseDefault4XX` is configured in resources
4. Check S3 bucket CORS configuration

### Issue: DynamoDB Errors

**Cause:** IAM permissions or table configuration issues

**Solution:**
1. Verify IAM roles in `serverless.yml` have correct permissions
2. Check that table name matches environment variable
3. Verify partition key and sort key are correctly configured
4. Check CloudWatch logs for detailed error messages

### Issue: S3 Upload Fails

**Cause:** Presigned URL expired or incorrect permissions

**Solution:**
1. Check that presigned URL hasn't expired (5 minutes by default)
2. Verify S3 bucket policy allows PutObject
3. Check that bucket name is correct
4. Verify CORS is configured on the bucket

### Issue: Function Timeout

**Cause:** Cold start or slow operations

**Solution:**
1. Increase timeout in `serverless.yml` (default is 6 seconds)
2. Optimize DynamoDB queries
3. Add provisioned concurrency for frequently used functions

## Cleanup

To remove all AWS resources and avoid charges:

```bash
cd starter/backend
serverless remove
```

This will delete:
- All Lambda functions
- API Gateway
- DynamoDB table
- S3 bucket (if empty)
- CloudWatch log groups
- IAM roles

**Note:** If the S3 bucket contains objects, you'll need to empty it first:

```bash
aws s3 rm s3://serverless-c4-todo-images-dev --recursive
```

## Additional Commands

### View Service Information

```bash
serverless info
```

### View Function Logs

```bash
serverless logs -f GetTodos -t
```

The `-t` flag tails the logs in real-time.

### Invoke Function Locally

```bash
serverless invoke local -f CreateTodo -p path/to/event.json
```

### Deploy Single Function

```bash
serverless deploy function -f GetTodos
```

This is faster than deploying the entire stack.

## Cost Estimation

With the free tier, this application should cost nearly $0 for light usage:

- **Lambda**: 1M free requests/month + 400,000 GB-seconds compute
- **DynamoDB**: 25 GB storage + 25 read/write capacity units
- **S3**: 5 GB storage + 20,000 GET requests + 2,000 PUT requests
- **API Gateway**: 1M API calls/month (first 12 months)

For production use with moderate traffic, expect:
- Lambda: ~$0.50 - $2.00/month
- DynamoDB: ~$1.00 - $5.00/month
- S3: ~$0.50 - $2.00/month
- API Gateway: ~$1.00 - $5.00/month

## Summary

✅ Backend deployed to AWS Lambda
✅ DynamoDB table created for TODO storage
✅ S3 bucket configured for image attachments
✅ API Gateway endpoints configured with Auth0 authentication
✅ Frontend running locally with Auth0 integration
✅ X-Ray tracing enabled for monitoring
✅ CloudWatch logs configured for debugging

Your Serverless TODO application is now fully deployed and operational!

