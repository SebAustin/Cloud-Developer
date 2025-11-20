# Cloud Developer Nanodegree - AWS Projects Portfolio

[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![Udacity](https://img.shields.io/badge/Udacity-Cloud%20Developer-blue)](https://www.udacity.com/course/cloud-developer-nanodegree--nd9990)
[![Status](https://img.shields.io/badge/Status-Complete-success)](https://github.com)

A comprehensive portfolio of cloud-native applications built as part of the **Udacity Cloud Developer Nanodegree** program. This repository demonstrates hands-on experience with AWS services, serverless architectures, microservices, containerization, and DevOps practices.

## 📋 Projects Overview

| # | Project | Description | Key Technologies | Status |
|---|---------|-------------|------------------|--------|
| 1 | [Deploy Static Website on AWS](#project-1-deploy-static-website-on-aws) | Automated deployment of static website to S3 with CloudFront CDN | S3, CloudFront, AWS CLI | ✅ Complete |
| 2 | [Serverless TODO Application](#project-2-serverless-todo-application) | Full-stack serverless app with authentication and image uploads | Lambda, API Gateway, DynamoDB, Auth0 | ✅ Complete |
| 3 | [Image Processing Microservice](#project-3-image-processing-microservice) | RESTful image filtering service on Elastic Beanstalk | Node.js, Express, Elastic Beanstalk | ✅ Complete |
| 4 | [Refactor Monolith to Microservices](#project-4-refactor-monolith-to-microservices) | Microservices architecture with Docker and Kubernetes | Docker, Kubernetes, EKS, RDS | ✅ Complete |

---

## 🚀 Project Details

### Project 1: Deploy Static Website on AWS

**Location:** [`Deploy Static Website on AWS/`](./Deploy%20Static%20Website%20on%20AWS/)

A fully automated deployment solution for hosting static websites on AWS with global CDN distribution.

#### Key Features
- ✅ Automated S3 bucket creation and configuration
- ✅ Static website hosting setup
- ✅ CloudFront CDN distribution for global delivery
- ✅ IAM policy automation for public access
- ✅ Bash scripts for deployment and cleanup
- ✅ Comprehensive documentation and screenshot guides

#### Technologies
- **AWS Services:** S3, CloudFront, IAM
- **Tools:** AWS CLI, Bash
- **Frontend:** HTML, CSS, Bootstrap

#### Quick Start
```bash
cd "Deploy Static Website on AWS"
chmod +x deploy.sh
./deploy.sh
```

📖 **Documentation:** [PROJECT_README.md](./Deploy%20Static%20Website%20on%20AWS/PROJECT_README.md)

---

### Project 2: Serverless TODO Application

**Location:** [`Develop and Deploy with AWS Lambda/`](./Develop%20and%20Deploy%20with%20AWS%20Lambda/)

A production-ready serverless TODO application with JWT authentication, image attachments, and user isolation.

#### Key Features
- ✅ Full CRUD operations for TODO items
- ✅ Auth0 authentication with JWT tokens
- ✅ User-specific data isolation
- ✅ Image upload and attachment to S3
- ✅ RESTful API with request validation
- ✅ Distributed tracing with X-Ray
- ✅ Structured logging with Winston
- ✅ Three-layer architecture (business logic, data layer, file storage)

#### Technologies
- **AWS Services:** Lambda, API Gateway, DynamoDB, S3, X-Ray, CloudWatch
- **Backend:** Node.js 20.x, Serverless Framework 3.x
- **Frontend:** React, Auth0 React SDK
- **Authentication:** Auth0 (RS256 JWT)
- **Database:** DynamoDB with composite keys and LSI

#### Architecture
```
Client → API Gateway → Lambda Authorizer (Auth0) → Lambda Functions
                                                    ↓
                                        DynamoDB + S3 Storage
```

#### Live Deployment
- **API Endpoint:** `https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev`
- **Auth0 Domain:** `dataviz.auth0.com`

📖 **Documentation:** [README.md](./Develop%20and%20Deploy%20with%20AWS%20Lambda/README.md)

---

### Project 3: Image Processing Microservice

**Location:** [`Image Processing Microservice on AWS/`](./Image%20Processing%20Microservice%20on%20AWS/)

A cloud-based RESTful API for image processing with filtering capabilities, deployed on AWS Elastic Beanstalk.

#### Key Features
- ✅ Image filtering (grayscale, resize)
- ✅ RESTful API with query parameters
- ✅ Bearer token authentication
- ✅ Automatic temporary file cleanup
- ✅ Error handling with proper HTTP status codes
- ✅ Elastic Beanstalk deployment

#### Technologies
- **AWS Services:** Elastic Beanstalk, EC2
- **Backend:** Node.js 18.x, Express.js
- **Image Processing:** Jimp library
- **Deployment:** EB CLI

#### API Example
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://[EB-URL]/filteredimage?image_url=https://example.com/image.jpg" \
  --output filtered.jpg
```

📖 **Documentation:** [README.md](./Image%20Processing%20Microservice%20on%20AWS/project%20starter%20code/README.md)

---

### Project 4: Refactor Monolith to Microservices

**Location:** [`Refactor Monolith to Microservices and Deploy/`](./Refactor%20Monolith%20to%20Microservices%20and%20Deploy/)

Complete refactoring of the Udagram monolithic application into microservices architecture with Docker containerization and Kubernetes orchestration on AWS EKS.

#### Key Features
- ✅ Four independent microservices (Feed, User, Frontend, Reverse Proxy)
- ✅ Docker containerization for all services
- ✅ Multi-stage Docker builds for optimization
- ✅ Kubernetes deployment on AWS EKS
- ✅ Horizontal Pod Autoscaling (HPA) configured
- ✅ LoadBalancer services for external access
- ✅ ConfigMaps and Secrets for configuration management
- ✅ CI/CD ready with Travis CI
- ✅ Multi-architecture support (AMD64)

#### Microservices Architecture
```
┌──────────────┐
│   Frontend   │ (Angular + Ionic)
└──────┬───────┘
       │
┌──────▼────────┐
│ Reverse Proxy │ (Nginx)
└──┬────────┬───┘
   │        │
   ▼        ▼
┌─────┐  ┌──────┐
│Feed │  │ User │ (Node.js Services)
└──┬──┘  └───┬──┘
   │         │
   ▼         ▼
┌─────────────┐
│ PostgreSQL  │ (AWS RDS)
└─────────────┘
       +
┌─────────────┐
│     S3      │ (Image Storage)
└─────────────┘
```

#### Technologies
- **AWS Services:** EKS, RDS (PostgreSQL), S3, ECR
- **Containerization:** Docker, Docker Compose
- **Orchestration:** Kubernetes, kubectl, eksctl
- **Backend:** Node.js 18, Express, TypeScript, Sequelize
- **Frontend:** Angular 18, Ionic 8
- **Reverse Proxy:** Nginx
- **CI/CD:** Travis CI
- **Registry:** DockerHub

#### Docker Images
All images published to DockerHub:
- `henrysebastien/udagram-api-feed:v1`
- `henrysebastien/udagram-api-user:v1`
- `henrysebastien/udagram-frontend:v1`
- `henrysebastien/udagram-reverseproxy:v1`

📖 **Documentation:** [README.md](./Refactor%20Monolith%20to%20Microservices%20and%20Deploy/cd0354-monolith-to-microservices-project-main/README.md)

---

## 🛠️ Technology Stack

### AWS Services Used

| Service | Projects | Purpose |
|---------|----------|---------|
| **S3** | 1, 2, 4 | Static hosting, object storage, image storage |
| **CloudFront** | 1 | Content Delivery Network (CDN) |
| **Lambda** | 2 | Serverless compute functions |
| **API Gateway** | 2 | RESTful API management |
| **DynamoDB** | 2 | NoSQL database |
| **Elastic Beanstalk** | 3 | PaaS for web applications |
| **EKS (Kubernetes)** | 4 | Container orchestration |
| **RDS (PostgreSQL)** | 4 | Relational database |
| **X-Ray** | 2 | Distributed tracing |
| **CloudWatch** | 2, 3, 4 | Logging and monitoring |
| **IAM** | All | Identity and access management |

### Development Tools & Frameworks

- **Languages:** JavaScript/TypeScript, Node.js, Bash
- **Frontend Frameworks:** React, Angular, Ionic
- **Backend Frameworks:** Express.js, Serverless Framework
- **Containerization:** Docker, Docker Compose
- **Orchestration:** Kubernetes, kubectl, eksctl
- **Authentication:** Auth0 (OAuth 2.0, JWT)
- **Version Control:** Git, GitHub
- **CI/CD:** Travis CI
- **Testing:** Postman, cURL

---

## 📁 Repository Structure

```
Cloud-Developer/
├── Deploy Static Website on AWS/
│   ├── deploy.sh                      # Automated deployment script
│   ├── cleanup.sh                     # Resource cleanup script
│   ├── PROJECT_README.md              # Project documentation
│   ├── DEPLOYMENT_GUIDE.md            # Deployment instructions
│   └── udacity-starter-website/       # Website files
│
├── Develop and Deploy with AWS Lambda/
│   ├── backend/                       # Serverless backend
│   │   ├── src/
│   │   │   ├── businessLogic/         # Business logic layer
│   │   │   ├── dataLayer/             # DynamoDB data access
│   │   │   ├── fileStorage/           # S3 operations
│   │   │   └── lambda/                # Lambda handlers
│   │   └── serverless.yml             # Serverless configuration
│   ├── client/                        # React frontend
│   ├── README.md                      # Project documentation
│   └── DEPLOYMENT_GUIDE.md            # Deployment instructions
│
├── Image Processing Microservice on AWS/
│   └── project starter code/
│       ├── server.js                  # Express application
│       ├── util/                      # Image processing utilities
│       └── README.md                  # Project documentation
│
├── Refactor Monolith to Microservices and Deploy/
│   └── cd0354-monolith-to-microservices-project-main/
│       ├── udagram-api-feed/          # Feed microservice
│       ├── udagram-api-user/          # User microservice
│       ├── udagram-frontend/          # Frontend application
│       ├── udagram-reverseproxy/      # Nginx reverse proxy
│       ├── udagram-deployment/        # Kubernetes manifests
│       ├── docker-compose.yaml        # Local development
│       ├── README.md                  # Project documentation
│       └── DEPLOYMENT_GUIDE.md        # Deployment instructions
│
└── README.md                          # This file
```

---

## 🎯 Learning Outcomes

Through these projects, I gained hands-on experience with:

### Cloud Architecture
- ✅ Serverless architecture design and implementation
- ✅ Microservices architecture and decomposition
- ✅ RESTful API design and best practices
- ✅ Cloud-native application development

### AWS Services
- ✅ S3 for static hosting and object storage
- ✅ CloudFront for content delivery
- ✅ Lambda for serverless compute
- ✅ API Gateway for API management
- ✅ DynamoDB for NoSQL data storage
- ✅ Elastic Beanstalk for PaaS deployments
- ✅ EKS for Kubernetes orchestration
- ✅ RDS for managed relational databases

### DevOps & Containerization
- ✅ Docker containerization and multi-stage builds
- ✅ Docker Compose for local development
- ✅ Kubernetes deployment and management
- ✅ Horizontal Pod Autoscaling
- ✅ Infrastructure as Code
- ✅ CI/CD pipeline configuration

### Security & Best Practices
- ✅ IAM roles and policies
- ✅ JWT authentication and authorization
- ✅ Secrets management
- ✅ CORS configuration
- ✅ Security group management
- ✅ Credential protection

### Monitoring & Observability
- ✅ Distributed tracing with X-Ray
- ✅ Structured logging
- ✅ CloudWatch metrics and logs
- ✅ Application health monitoring

---

## 🚀 Getting Started

### Prerequisites

To run these projects, you'll need:

1. **AWS Account** - Active account with appropriate permissions
2. **AWS CLI** - Installed and configured with credentials
   ```bash
   aws configure
   ```

3. **Node.js** - Version 18.x or higher
   ```bash
   node --version
   npm --version
   ```

4. **Docker** - Docker Desktop installed
   ```bash
   docker --version
   docker-compose --version
   ```

5. **Additional Tools** (project-specific):
   - Serverless Framework: `npm install -g serverless`
   - Ionic CLI: `npm install -g @ionic/cli`
   - kubectl: For Kubernetes management
   - eksctl: For EKS cluster management

### Running a Project

Each project has its own detailed documentation. Navigate to the project directory and follow the README:

```bash
# Example: Static Website Deployment
cd "Deploy Static Website on AWS"
./deploy.sh

# Example: Serverless TODO App
cd "Develop and Deploy with AWS Lambda/backend"
npm install
serverless deploy

# Example: Image Processing Service
cd "Image Processing Microservice on AWS/project starter code"
npm install
npm start

# Example: Microservices Project
cd "Refactor Monolith to Microservices and Deploy/cd0354-monolith-to-microservices-project-main"
docker-compose up
```

---

## 📚 Documentation

Each project includes comprehensive documentation:

- **README.md** - Project overview and quick start
- **DEPLOYMENT_GUIDE.md** - Step-by-step deployment instructions
- **TROUBLESHOOTING.md** - Common issues and solutions (where applicable)
- **Screenshots/** - Visual documentation for verification

---

## 🎓 Certification

This repository contains projects completed as part of the [Udacity Cloud Developer Nanodegree](https://www.udacity.com/course/cloud-developer-nanodegree--nd9990) program.

### Skills Demonstrated
- Cloud application development on AWS
- Serverless architecture implementation
- Microservices design and deployment
- Container orchestration with Kubernetes
- CI/CD pipeline configuration
- Cloud security best practices
- Infrastructure automation

---

## 📖 Additional Resources

### AWS Documentation
- [AWS Documentation](https://docs.aws.amazon.com/)
- [AWS CLI Reference](https://docs.aws.amazon.com/cli/latest/reference/)
- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [Amazon EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/)
- [AWS Best Practices](https://aws.amazon.com/architecture/well-architected/)

### Learning Resources
- [Udacity Cloud Developer Nanodegree](https://www.udacity.com/course/cloud-developer-nanodegree--nd9990)
- [Serverless Framework Documentation](https://www.serverless.com/framework/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)

---

## 🔒 Security Note

**Important:** Never commit sensitive information to version control!

All projects follow security best practices:
- ✅ Environment variables for configuration
- ✅ `.gitignore` for credential files
- ✅ AWS Secrets Manager / Kubernetes Secrets
- ✅ IAM roles with least-privilege permissions
- ✅ No hardcoded credentials in code

Files that are git-ignored:
- `.env` files
- `set_env.sh`
- AWS credential files
- Private keys (`.pem`, `.key`)

---

## 💰 Cost Considerations

Most services used in these projects are eligible for AWS Free Tier:

| Service | Free Tier |
|---------|-----------|
| S3 | 5 GB storage, 20,000 GET requests |
| Lambda | 1M requests/month, 400,000 GB-seconds |
| DynamoDB | 25 GB storage, 25 RCU/WCU |
| CloudFront | 50 GB data transfer out |
| API Gateway | 1M API calls/month (12 months) |
| Elastic Beanstalk | Free (pay for underlying resources) |

**Recommendation:** Always clean up resources after testing to avoid unexpected charges!

---

## 🧹 Cleanup

Each project includes cleanup instructions:

- **Project 1:** Run `./cleanup.sh`
- **Project 2:** Run `serverless remove`
- **Project 3:** Run `eb terminate`
- **Project 4:** Run `eksctl delete cluster`

---

## 📊 Project Statistics

- **Total Projects:** 4
- **AWS Services Used:** 11+
- **Docker Images Published:** 4
- **Lambda Functions:** 6
- **Microservices:** 4
- **Lines of Code:** 10,000+
- **Documentation Files:** 20+

---

## 🤝 Contributing

This repository is primarily for educational purposes and project showcase. However, if you find any issues or have suggestions:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📝 License

This project is part of the Udacity Cloud Developer Nanodegree program and is for educational purposes.

---

## 👨‍💻 Author

**Henry Sebastien**

- **DockerHub:** [henrysebastien](https://hub.docker.com/u/henrysebastien)
- **Program:** Udacity Cloud Developer Nanodegree
- **Completion Date:** November 2025

---

## 🎯 Project Status

| Aspect | Status |
|--------|--------|
| All Projects Completed | ✅ |
| Deployed to AWS | ✅ |
| Documentation Complete | ✅ |
| Screenshots Captured | ✅ |
| Ready for Review | ✅ |

---

## 🌟 Highlights

### Technical Achievements
- ✅ Built and deployed 4 production-ready cloud applications
- ✅ Implemented end-to-end CI/CD pipelines
- ✅ Architected scalable microservices on Kubernetes
- ✅ Integrated Auth0 for secure authentication
- ✅ Achieved automatic horizontal scaling with HPA
- ✅ Implemented distributed tracing and monitoring
- ✅ Published Docker images to public registry

### Best Practices Applied
- ✅ Infrastructure as Code (IaC)
- ✅ Separation of concerns (3-layer architecture)
- ✅ Security-first approach
- ✅ Comprehensive documentation
- ✅ Automated deployment scripts
- ✅ Error handling and logging
- ✅ Resource optimization

---

**Last Updated:** November 20, 2025  
**Status:** ✅ **All Projects Complete and Deployed**

---

<div align="center">

**Thank you for visiting this repository!**

If you found these projects helpful, please ⭐ star this repository!

</div>

