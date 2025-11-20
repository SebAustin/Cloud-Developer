# Auth0 Setup Guide

This guide will walk you through setting up Auth0 authentication for the Serverless TODO application.

## Prerequisites

- An Auth0 account (free tier is sufficient)
- Access to the Auth0 Dashboard

## Step 1: Create an Auth0 Account

1. Go to [Auth0](https://auth0.com/) and click **Sign Up**
2. Create your account using your preferred method (email, Google, GitHub, etc.)
3. Complete the account setup process
4. Choose a unique tenant domain (e.g., `your-name-todo-app`) - this will be used in your JWKS URL

## Step 2: Create a New Application

1. Log in to your [Auth0 Dashboard](https://manage.auth0.com/)
2. Navigate to **Applications** > **Applications** in the left sidebar
3. Click **Create Application**
4. Enter application details:
   - **Name**: `Serverless TODO App` (or any name you prefer)
   - **Application Type**: Select **Single Page Web Applications**
5. Click **Create**

## Step 3: Configure Application Settings

After creating the application, you'll be taken to the application settings page.

### Basic Information

In the **Settings** tab, locate and note the following values (you'll need them later):

- **Domain**: This will look like `your-tenant.us.auth0.com` or `your-tenant.auth0.com`
- **Client ID**: A long alphanumeric string

### Application URIs

Scroll down to the **Application URIs** section and configure the following:

#### IMPORTANT: Initiate Login URI

⚠️ **Leave the "Initiate Login URI" field EMPTY** - This field requires HTTPS and is optional for this application. If you see an error about `absolute-https-uri-or-empty`, just clear this field.

#### For Local Development:

- **Allowed Callback URLs**: 
  ```
  http://localhost:3000
  ```

- **Allowed Logout URLs**: 
  ```
  http://localhost:3000
  ```

- **Allowed Web Origins**: 
  ```
  http://localhost:3000
  ```

#### For Udacity Workspace:

If you're using Udacity workspace, add these as well (separated by commas):

- **Allowed Callback URLs**: 
  ```
  http://localhost:3000, https://*.udacity-student-workspaces.com
  ```

- **Allowed Logout URLs**: 
  ```
  http://localhost:3000, https://*.udacity-student-workspaces.com
  ```

- **Allowed Web Origins**: 
  ```
  http://localhost:3000, https://*.udacity-student-workspaces.com
  ```

#### Notes:
- The fields above (Callback URLs, Logout URLs, Web Origins) **CAN** use HTTP for local development
- **Initiate Login URI** is a different field that requires HTTPS - leave it empty for now
- Once you deploy to production with a custom domain, you can add HTTPS URLs

### Advanced Settings

1. Scroll down to **Advanced Settings** at the bottom of the page
2. Click on the **OAuth** tab
3. Ensure **JsonWebToken Signature Algorithm** is set to **RS256** (this is usually the default)
4. Click **Save Changes** at the bottom of the page

## Step 4: Update Backend Configuration

### Update Auth0 Domain in Backend Code

1. Open the file: `/starter/backend/src/lambda/auth/auth0Authorizer.mjs`
2. Find the line:
   ```javascript
   const jwksUrl = 'https://YOUR_AUTH0_DOMAIN/.well-known/jwks.json'
   ```
3. Replace `YOUR_AUTH0_DOMAIN` with your actual Auth0 domain from Step 3
   
   Example:
   ```javascript
   const jwksUrl = 'https://dev-abc123.us.auth0.com/.well-known/jwks.json'
   ```

## Step 5: Update Frontend Configuration

### Create/Update the .env File

1. Navigate to the client folder: `/starter/client/`
2. Create or update the `.env` file with the following content:

   ```env
   REACT_APP_AUTH0_DOMAIN=your-tenant.us.auth0.com
   REACT_APP_AUTH0_CLIENT_ID=your-client-id-from-step-3
   REACT_APP_API_ENDPOINT=https://your-api-gateway-url/dev
   ```

   **Replace the placeholders:**
   - `REACT_APP_AUTH0_DOMAIN`: Your Auth0 domain from Step 3
   - `REACT_APP_AUTH0_CLIENT_ID`: Your Client ID from Step 3
   - `REACT_APP_API_ENDPOINT`: Your API Gateway endpoint (you'll get this after deploying the backend)

## Step 6: Test Auth0 Configuration

### Verify JWKS Endpoint

Before deploying, verify that your JWKS endpoint is accessible:

1. Open a browser and navigate to:
   ```
   https://YOUR_AUTH0_DOMAIN/.well-known/jwks.json
   ```
   
2. You should see a JSON response with keys that looks like:
   ```json
   {
     "keys": [
       {
         "alg": "RS256",
         "kty": "RSA",
         "use": "sig",
         "kid": "...",
         "x5c": ["..."]
       }
     ]
   }
   ```

## Step 7: Deploy and Test

### Deploy Backend

1. Navigate to the backend folder:
   ```bash
   cd starter/backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Deploy to AWS:
   ```bash
   serverless deploy --verbose
   ```

4. Note the **API Gateway endpoint** from the deployment output (it will look like `https://abc123xyz.execute-api.us-east-1.amazonaws.com/dev`)

5. Update your `client/.env` file with this endpoint URL

### Run Frontend

1. Navigate to the client folder:
   ```bash
   cd ../client
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

4. The application should open at `http://localhost:3000`

## Troubleshooting

### Issue: "User not authorized" error

**Possible causes:**
- Incorrect Auth0 domain in `auth0Authorizer.mjs`
- Wrong Client ID in `.env` file
- JWKS endpoint is not accessible
- JWT signature algorithm is not RS256

**Solutions:**
- Double-check all Auth0 configuration values
- Verify JWKS endpoint URL in browser
- Ensure Auth0 application is using RS256 algorithm

### Issue: CORS errors

**Possible causes:**
- Callback URLs not configured in Auth0
- Missing CORS configuration in serverless.yml

**Solutions:**
- Verify all Allowed URLs in Auth0 application settings
- Ensure `cors: true` is set in all function definitions in serverless.yml

### Issue: Redirect URI mismatch

**Possible causes:**
- Callback URLs don't match the URL you're accessing the app from

**Solutions:**
- Add the exact URL you're using to the Allowed Callback URLs in Auth0
- Include both `http://localhost:3000` and any workspace URLs

## Additional Resources

- [Auth0 React SDK Documentation](https://auth0.com/docs/quickstart/spa/react)
- [Auth0 API Authorization](https://auth0.com/docs/authorization)
- [JWT.io](https://jwt.io/) - Decode and inspect JWT tokens

## Security Best Practices

1. **Never commit your `.env` file** to version control
2. **Use different Auth0 applications** for development and production
3. **Regularly rotate** your Auth0 API keys and secrets
4. **Monitor** Auth0 logs for suspicious activity
5. **Keep allowed URLs specific** - avoid using wildcard patterns in production

## Summary

You should now have:
- ✅ An Auth0 application configured for Single Page Applications
- ✅ RS256 JWT signature algorithm enabled
- ✅ Callback URLs, Logout URLs, and Web Origins configured
- ✅ Auth0 domain and Client ID added to backend and frontend configurations
- ✅ A working authentication flow in your TODO application

If you encounter any issues, refer to the Troubleshooting section or check the CloudWatch logs for detailed error messages.

