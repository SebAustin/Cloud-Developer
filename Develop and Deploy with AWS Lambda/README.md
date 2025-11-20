# Serverless TODO Application

A full-stack serverless TODO application built with AWS Lambda, API Gateway, DynamoDB, S3, and Auth0 authentication. This project demonstrates modern serverless architecture with separation of concerns, distributed tracing, and comprehensive logging.

## 🌟 Live Deployment

**Status**: ✅ **Deployed and Running**

- **API Endpoint**: `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev`
- **Region**: `us-east-1`
- **Auth0 Domain**: `dataviz.auth0.com`
- **Stage**: `dev`

> **For Udacity Reviewers**: See `client/src/config.ts` for complete configuration.

## 🚀 Features

- ✅ Create, read, update, and delete TODO items
- ✅ Upload and attach images to TODO items
- ✅ User authentication with Auth0
- ✅ User-specific TODO isolation
- ✅ Serverless architecture with AWS Lambda
- ✅ RESTful API with API Gateway
- ✅ NoSQL data storage with DynamoDB
- ✅ Image storage with S3
- ✅ Distributed tracing with X-Ray
- ✅ Structured logging with Winston
- ✅ CORS-enabled for web applications
- ✅ Request validation at API Gateway level

## 📋 Architecture

### Backend Architecture

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│   API Gateway       │
│  (REST API + CORS)  │
└─────────┬───────────┘
          │
          ▼
    ┌─────────┐
    │  Auth0  │
    │Authorizer│
    └─────────┘
          │
          ▼
┌──────────────────────┐
│  Lambda Functions    │
│  ┌────────────────┐  │
│  │ Business Logic │  │
│  ├────────────────┤  │
│  │  Data Layer    │  │
│  ├────────────────┤  │
│  │ File Storage   │  │
│  └────────────────┘  │
└──────┬───────┬───────┘
       │       │
       ▼       ▼
   ┌───────┐ ┌─────┐
   │DynamoDB│ │ S3  │
   └───────┘ └─────┘
```

### Separation of Concerns

The application follows a three-layer architecture:

1. **Business Logic Layer** (`src/businessLogic/todos.mjs`)
   - Orchestrates application workflows
   - Implements business rules
   - Coordinates between data and file storage layers

2. **Data Layer** (`src/dataLayer/todosAccess.mjs`)
   - Handles all DynamoDB operations
   - Implements data access patterns
   - Manages data persistence

3. **File Storage Layer** (`src/fileStorage/attachmentUtils.mjs`)
   - Manages S3 operations
   - Generates presigned URLs
   - Handles file attachments

## 🛠️ Technology Stack

### Backend
- **Runtime**: Node.js 20.x
- **Framework**: Serverless Framework 3.x
- **AWS Services**:
  - Lambda (compute) - 6 functions deployed
  - API Gateway (REST API)
  - DynamoDB (database) - `Todos-dev` table
  - S3 (file storage) - `shenry-serverless-todo-images-dev-*` bucket
  - CloudWatch (logging) - 6 log groups
  - X-Ray (tracing) - Distributed tracing enabled
  - IAM (security) - Per-function least-privilege roles
- **Authentication**: Auth0 with RS256 JWT
- **Logging**: Winston (JSON formatted)
- **Middleware**: Middy with CORS and error handling

### Frontend
- **Framework**: React
- **Authentication**: Auth0 React SDK
- **HTTP Client**: Axios
- **Styling**: CSS

## 📁 Project Structure

```
starter/
├── backend/
│   ├── models/                          # Request validation schemas
│   │   ├── create-todo-model.json
│   │   └── update-todo-model.json
│   ├── src/
│   │   ├── auth/
│   │   │   └── utils.mjs               # JWT parsing utilities
│   │   ├── businessLogic/
│   │   │   └── todos.mjs               # Business logic layer
│   │   ├── dataLayer/
│   │   │   └── todosAccess.mjs         # DynamoDB data access
│   │   ├── fileStorage/
│   │   │   └── attachmentUtils.mjs     # S3 file operations
│   │   ├── lambda/
│   │   │   ├── auth/
│   │   │   │   └── auth0Authorizer.mjs # Auth0 custom authorizer
│   │   │   ├── http/
│   │   │   │   ├── createTodo.js       # Create TODO handler
│   │   │   │   ├── deleteTodo.js       # Delete TODO handler
│   │   │   │   ├── generateUploadUrl.js # Generate S3 upload URL
│   │   │   │   ├── getTodos.js         # Get all TODOs handler
│   │   │   │   └── updateTodo.js       # Update TODO handler
│   │   │   └── utils.mjs               # Lambda utilities
│   │   └── utils/
│   │       └── logger.mjs              # Winston logger configuration
│   ├── package.json
│   └── serverless.yml                  # Serverless configuration
│
├── client/
│   ├── public/
│   ├── src/
│   │   ├── api/
│   │   │   └── todos-api.js           # API client
│   │   ├── components/                # React components
│   │   ├── config.ts                  # ✅ API & Auth0 config (for reviewers)
│   │   ├── App.jsx
│   │   └── index.js
│   ├── .env                           # Environment variables (not in repo)
│   └── package.json
│
├── AUTH0_SETUP.md                     # Auth0 configuration guide
├── AUTH0_API_SETUP.md                 # Auth0 API configuration
├── DEPLOYMENT_GUIDE.md                # Deployment instructions
├── DEPLOYMENT_REVIEW.md               # Deployment status report
├── FINAL_FIX_SUMMARY.md               # Recent fixes documentation
├── SUBMISSION_GUIDE.md                # Udacity submission checklist
└── README.md                          # This file
```

## 🚦 Quick Start

### For Udacity Reviewers

The backend is **already deployed** and running! Just configure and run the frontend:

```bash
# 1. Navigate to client directory
cd client

# 2. Install dependencies
npm install

# 3. Create .env file with these values:
cat > .env << EOF
REACT_APP_API_ENDPOINT=https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev
REACT_APP_AUTH0_DOMAIN=dataviz.auth0.com
REACT_APP_AUTH0_CLIENT_ID=katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O
REACT_APP_AUTH0_AUDIENCE=https://serverless-todo-api
EOF

# 4. Start the development server
npm start
```

The application will open at `http://localhost:3000`.

### For Development/Deployment

<details>
<summary>Click to expand full deployment instructions</summary>

#### Prerequisites

- Node.js 14.x or higher
- AWS account with appropriate permissions
- Auth0 account
- Serverless Framework 3.x

#### 1. Clone the Repository

```bash
git clone <repository-url>
cd starter
```

#### 2. Set Up Auth0

Follow the detailed instructions in [AUTH0_SETUP.md](./AUTH0_SETUP.md) to:
- Create an Auth0 application
- Create an Auth0 API
- Configure callback URLs
- Get your Auth0 domain and client ID

#### 3. Deploy Backend

```bash
cd backend
npm install
serverless deploy --verbose
```

Note the API Gateway endpoint URL from the deployment output.

#### 4. Configure Frontend

Create a `.env` file in the `client` directory:

```env
REACT_APP_AUTH0_DOMAIN=your-auth0-domain.auth0.com
REACT_APP_AUTH0_CLIENT_ID=your_auth0_client_id
REACT_APP_API_ENDPOINT=https://your-api-gateway-url/dev
REACT_APP_AUTH0_AUDIENCE=https://serverless-todo-api
```

Also update `client/src/config.ts` with your API ID and Auth0 details.

#### 5. Run Frontend

```bash
cd ../client
npm install
npm start
```

The application will open at `http://localhost:3000`.

For detailed deployment instructions, see [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md).

</details>

## 🔧 Configuration

### Environment Variables

#### Backend (serverless.yml)

| Variable | Description | Example |
|----------|-------------|---------|
| `TODOS_TABLE` | DynamoDB table name | `Todos-dev` |
| `TODOS_CREATED_AT_INDEX` | Index name for sorting | `CreatedAtIndex` |
| `ATTACHMENTS_S3_BUCKET` | S3 bucket for images | `serverless-c4-todo-images-dev` |
| `SIGNED_URL_EXPIRATION` | Presigned URL TTL (seconds) | `300` |

#### Frontend (.env)

| Variable | Description | Current Value |
|----------|-------------|---------------|
| `REACT_APP_AUTH0_DOMAIN` | Auth0 tenant domain | `dataviz.auth0.com` |
| `REACT_APP_AUTH0_CLIENT_ID` | Auth0 client ID | `katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O` |
| `REACT_APP_API_ENDPOINT` | API Gateway base URL | `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev` |
| `REACT_APP_AUTH0_AUDIENCE` | Auth0 API identifier | `https://serverless-todo-api` |

> **Note**: The `.env` file is not committed to the repository for security reasons. Reviewers must create it with the values above.

## 📊 Data Model

### TODO Item

```typescript
{
  userId: string      // Partition key - Auth0 user ID
  todoId: string      // Sort key - UUID
  createdAt: string   // ISO 8601 timestamp (for sorting)
  name: string        // TODO item name
  dueDate: string     // Due date (YYYY-MM-DD)
  done: boolean       // Completion status
  attachmentUrl?: string  // S3 URL for attached image
}
```

### DynamoDB Table Design

- **Table Name**: `Todos-{stage}`
- **Partition Key**: `userId` (String)
- **Sort Key**: `todoId` (String)
- **Local Secondary Index**: `CreatedAtIndex`
  - Partition Key: `userId` (String)
  - Sort Key: `createdAt` (String)
  - Projection: ALL

## 🔒 Security

### Authentication & Authorization

- **Auth0 Integration**: Industry-standard OAuth 2.0 / OpenID Connect
- **JWT Verification**: RS256 algorithm with JWKS public key fetching
- **User Isolation**: Each user can only access their own TODO items
- **IAM Roles**: Least-privilege permissions for Lambda functions

### API Security

- **Custom Authorizer**: Lambda function validates JWT tokens
- **CORS Configuration**: Controlled cross-origin access
- **Request Validation**: JSON schema validation at API Gateway
- **HTTPS Only**: All API endpoints use TLS encryption

## 📈 Monitoring & Observability

### Distributed Tracing (X-Ray)

- All Lambda functions instrumented with X-Ray
- AWS SDK calls automatically traced
- Service map available in X-Ray console

### Logging (CloudWatch)

- Structured JSON logs with Winston
- Separate log groups per Lambda function
- Log retention configured
- Contextual information in every log entry

### Metrics

- Lambda execution metrics (duration, errors, invocations)
- API Gateway metrics (latency, 4xx/5xx errors)
- DynamoDB metrics (read/write capacity)
- Custom business metrics

## 🧪 Testing

### Functional Testing Status

All features have been tested and verified:

- ✅ **Authentication**: Auth0 login/logout working
- ✅ **Create TODO**: New items created successfully
- ✅ **Read TODOs**: User-specific items retrieved
- ✅ **Update TODO**: Status changes persist
- ✅ **Delete TODO**: Items removed successfully
- ✅ **Upload Images**: File attachments working
- ✅ **User Isolation**: Users only see their own TODOs
- ✅ **Page Reload**: Data persists across refreshes

### Manual Testing with cURL

See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md#part-5-testing-with-curl-commands) for detailed cURL examples.

### End-to-End Testing

1. Log in with Auth0 ✅
2. Create a TODO item ✅
3. Upload an image attachment ✅
4. Update TODO status ✅
5. Delete TODO item ✅
6. Verify user isolation ✅

### CloudWatch Logs

All Lambda functions are logging successfully:
```bash
aws logs tail /aws/lambda/serverless-todo-app-dev-GetTodos \
  --region us-east-1 --since 10m
```

### X-Ray Traces

Distributed tracing is active and capturing all requests:
- View service map: AWS Console → X-Ray → Service map
- View traces: AWS Console → X-Ray → Traces

## 🐛 Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| 403 Unauthorized | Auth0 API not configured | Create Auth0 API with identifier `https://serverless-todo-api` |
| Network Error on reload | Missing audience parameter | Add `REACT_APP_AUTH0_AUDIENCE` to .env |
| CORS errors | Missing CORS headers | Check serverless.yml and handler middleware |
| DynamoDB errors | Null values in attributes | Don't set attributes to null, omit them instead |
| S3 upload fails | Expired presigned URL | URL expires in 5 minutes, regenerate |

### Recent Fixes Applied

✅ **Fixed**: DynamoDB null value error  
✅ **Fixed**: Auth0 audience configuration  
✅ **Fixed**: Frontend token request parameters

For detailed troubleshooting, see [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md#troubleshooting) or [FINAL_FIX_SUMMARY.md](./FINAL_FIX_SUMMARY.md).

## 💰 Cost Optimization

### Free Tier Benefits

Most usage falls under AWS Free Tier:
- Lambda: 1M requests/month + 400,000 GB-seconds
- DynamoDB: 25 GB storage + 25 RCU/WCU
- S3: 5 GB storage + 20,000 GET + 2,000 PUT requests
- API Gateway: 1M calls/month (first 12 months)

### Optimization Strategies

- **DynamoDB**: On-demand billing for variable workloads
- **Lambda**: Optimized memory allocation (256 MB)
- **S3**: Lifecycle policies for old attachments
- **CloudWatch**: Configured log retention periods

Expected monthly cost for moderate usage: **$2-$10**

## 🧹 Cleanup

To remove all AWS resources:

```bash
cd backend
serverless remove
```

If S3 bucket has objects:

```bash
aws s3 rm s3://serverless-c4-todo-images-dev --recursive
serverless remove
```

## 📚 Additional Resources

### Project Documentation

- [AUTH0_SETUP.md](./AUTH0_SETUP.md) - Complete Auth0 configuration guide
- [AUTH0_API_SETUP.md](./AUTH0_API_SETUP.md) - Auth0 API configuration for JWT tokens
- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - Step-by-step deployment instructions
- [DEPLOYMENT_REVIEW.md](./DEPLOYMENT_REVIEW.md) - Infrastructure review and status
- [FINAL_FIX_SUMMARY.md](./FINAL_FIX_SUMMARY.md) - Recent bug fixes and solutions
- [SUBMISSION_GUIDE.md](./SUBMISSION_GUIDE.md) - Udacity submission checklist

### External Resources

- [Serverless Framework Documentation](https://www.serverless.com/framework/docs)
- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [Auth0 Documentation](https://auth0.com/docs)
- [DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html)

## 🤝 Contributing

This is a learning project for the Udacity Cloud Developer Nanodegree. Feel free to use it as a reference for your own implementations.

## 📝 License

See [LICENSE.txt](../LICENSE.txt) for details.

## 🎓 Project Requirements

This project fulfills all requirements for the Udacity Cloud Developer Nanodegree project:

### Functionality
- ✅ Users can create, update, delete TODO items
- ✅ Users can upload image attachments
- ✅ Application only displays user's own TODO items
- ✅ Authentication prevents unauthenticated access

### Code Base
- ✅ Code split into multiple layers (business logic, data layer, file storage)
- ✅ Async/await used throughout (no callbacks)

### Best Practices
- ✅ All resources defined in serverless.yml
- ✅ Per-function IAM permissions
- ✅ Distributed tracing enabled (X-Ray)
- ✅ Comprehensive logging with Winston
- ✅ HTTP request validation with JSON schemas

### Architecture
- ✅ DynamoDB table with composite key (userId + todoId)
- ✅ Query operation used (not scan) for data retrieval
- ✅ Local Secondary Index for efficient sorting

## 👨‍💻 Author

Built as part of the Udacity Cloud Developer Nanodegree program.

## 🎯 Deployment Status

| Component | Status | Details |
|-----------|--------|---------|
| Backend API | ✅ Deployed | `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev` |
| Lambda Functions | ✅ Active | 6 functions running |
| DynamoDB Table | ✅ Active | `Todos-dev` ready |
| S3 Bucket | ✅ Active | Images storage configured |
| Auth0 Integration | ✅ Configured | JWT verification working |
| X-Ray Tracing | ✅ Enabled | Service map available |
| CloudWatch Logs | ✅ Active | All functions logging |

**Last Updated**: November 16, 2025  
**Deployment Ready**: ✅ Yes  
**Submission Ready**: ✅ Yes

---

**Happy Coding! 🚀**

