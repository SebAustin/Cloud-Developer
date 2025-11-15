# Image Processing Microservice on AWS

A cloud-based image processing microservice built with Node.js and Express, deployed on AWS Elastic Beanstalk. This service accepts image URLs, applies filtering effects (grayscale, resize), and returns the processed image.

## Features

- ✅ RESTful API endpoint for image filtering
- ✅ URL validation and error handling
- ✅ Automatic cleanup of temporary files
- ✅ Authentication via Bearer token
- ✅ Deployed on AWS Elastic Beanstalk
- ✅ Supports HTTP status codes (200, 400, 401, 422, 500)

## Project Setup

### Prerequisites

- Node.js 18.x or higher
- npm
- AWS CLI
- AWS Elastic Beanstalk CLI (`eb`)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd "project starter code"
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file (optional for local development):
```bash
# Optional: Set custom authentication token
AUTH_TOKEN=your-secret-token-here
```

### Running Locally

Development mode with auto-reload:
```bash
npm run dev
```

Production mode:
```bash
npm start
```

The server will start on `http://localhost:8082`

## API Documentation

### Base URL (Local)
```
http://localhost:8082
```

### Deployed URL
```
http://image-filter-env.eba-qma49hh6.us-east-1.elasticbeanstalk.com
```

### Endpoints

#### 1. Root Endpoint
```
GET /
```

**Response:**
```
try GET /filteredimage?image_url={{}}
```

#### 2. Filter Image Endpoint

```
GET /filteredimage?image_url={IMAGE_URL}
```

**Authentication Required:** Yes (Bearer Token)

**Query Parameters:**
- `image_url` (required): A publicly accessible URL to an image file

**Headers:**
```
Authorization: Bearer <token>
```

Default token: `udacity-cloud-dev-token` (or set via `AUTH_TOKEN` environment variable)

**Success Response (200):**
- Returns the filtered image file (grayscale, resized to 256x256, JPEG quality 60)

**Error Responses:**

| Status Code | Description |
|-------------|-------------|
| 400 | Missing or invalid `image_url` parameter |
| 401 | Missing or invalid authentication token |
| 422 | Unable to process image (invalid image file) |
| 500 | Internal server error |

### Example Requests

**Using cURL (Local):**
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://localhost:8082/filteredimage?image_url=https://upload.wikimedia.org/wikipedia/commons/b/bd/Golden_tabby_and_white_kitten_n01.jpg" \
  --output filtered_image.jpg
```

**Using cURL (Deployed):**
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://[EB_URL]/filteredimage?image_url=https://upload.wikimedia.org/wikipedia/commons/b/bd/Golden_tabby_and_white_kitten_n01.jpg" \
  --output filtered_image.jpg
```

**Using Postman:**
1. Set method to `GET`
2. URL: `http://localhost:8082/filteredimage?image_url=https://upload.wikimedia.org/wikipedia/commons/b/bd/Golden_tabby_and_white_kitten_n01.jpg`
3. Add Header: `Authorization: Bearer udacity-cloud-dev-token`
4. Send request
5. Save response as image file

**Without Authentication (will fail):**
```bash
curl "http://localhost:8082/filteredimage?image_url=https://upload.wikimedia.org/wikipedia/commons/b/bd/Golden_tabby_and_white_kitten_n01.jpg"
```

Response:
```json
{"error": "Authorization header required"}
```

## AWS Elastic Beanstalk Deployment

### Initial Setup

1. Install the EB CLI:
```bash
pip install awsebcli
```

2. Configure AWS credentials:
```bash
aws configure
```

3. Initialize Elastic Beanstalk application:
```bash
eb init
```

Follow the prompts:
- Select your AWS region
- Create a new application or select existing
- Choose Node.js platform
- Set up SSH (optional)

4. Create an environment and deploy:
```bash
eb create image-filter-env
```

5. Set environment variables on EB:
```bash
eb setenv AUTH_TOKEN=your-production-token-here
```

### Subsequent Deployments

After making changes, deploy with:
```bash
eb deploy
```

### Monitoring

View logs:
```bash
eb logs
```

Check environment status:
```bash
eb status
```

Open application in browser:
```bash
eb open
```

### Environment Variables

Configure the following on AWS Elastic Beanstalk:
- `AUTH_TOKEN`: Your secret authentication token (default: `udacity-cloud-dev-token`)

## Testing

### Test Cases

1. **Valid Request with Authentication:**
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://localhost:8082/filteredimage?image_url=https://upload.wikimedia.org/wikipedia/commons/b/bd/Golden_tabby_and_white_kitten_n01.jpg" \
  --output test_filtered.jpg
```
Expected: 200 OK, filtered image file

2. **Missing image_url Parameter:**
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://localhost:8082/filteredimage"
```
Expected: 400 Bad Request

3. **Missing Authentication:**
```bash
curl "http://localhost:8082/filteredimage?image_url=https://upload.wikimedia.org/wikipedia/commons/b/bd/Golden_tabby_and_white_kitten_n01.jpg"
```
Expected: 401 Unauthorized

4. **Invalid URL:**
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://localhost:8082/filteredimage?image_url=not-a-valid-url"
```
Expected: 400 Bad Request

5. **Non-Image URL:**
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://localhost:8082/filteredimage?image_url=https://www.google.com"
```
Expected: 422 Unprocessable Entity

## Project Structure

```
project starter code/
├── server.js                    # Main Express application
├── package.json                 # Node.js dependencies and scripts
├── util/
│   └── util.js                 # Helper functions (filterImageFromURL, deleteLocalFiles)
├── .gitignore                  # Git ignore rules
├── .ebignore                   # Elastic Beanstalk ignore rules
├── deployment_screenshots/      # Screenshots for project submission
└── README.md                   # This file
```

## Technologies Used

- **Node.js** (v18.x) - JavaScript runtime
- **Express.js** - Web framework
- **Jimp** - Image processing library
- **AWS Elastic Beanstalk** - Cloud deployment platform
- **Body-parser** - Request body parsing middleware

## Stand-Out Features Implemented

✅ **Authentication**: Bearer token authentication middleware to secure the API endpoint

## License

ISC

## Author

Udacity Cloud Developer Nanodegree Project

## Acknowledgments

- Udacity Cloud Developer Nanodegree Program
- Starter code provided by Udacity
