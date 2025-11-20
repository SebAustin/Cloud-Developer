# Auth0 API Setup - Fix 403 Error

## Problem
The application is returning `403 Forbidden` because Auth0 is issuing opaque access tokens instead of JWT tokens. Our Lambda authorizer requires JWT tokens to validate.

## Solution
Create an Auth0 API to enable JWT token issuance.

---

## Step 1: Create Auth0 API

1. Log in to [Auth0 Dashboard](https://manage.auth0.com/)

2. Navigate to **Applications** → **APIs** in the left sidebar

3. Click **Create API**

4. Fill in the API details:
   - **Name**: `Serverless TODO API`
   - **Identifier**: `https://serverless-todo-api` (can be any unique identifier, doesn't need to be a real URL)
   - **Signing Algorithm**: Select **RS256** (should be default)

5. Click **Create**

---

## Step 2: Update Frontend Configuration

Now update your frontend code to use this API identifier as the audience.

### Option A: Environment Variable (Recommended)

1. **Update `.env` file**:

```env
# Backend API Configuration
REACT_APP_API_ENDPOINT=https://jtssc9hez9.execute-api.us-east-1.amazonaws.com/dev

# Auth0 Configuration
REACT_APP_AUTH0_DOMAIN=dataviz.auth0.com
REACT_APP_AUTH0_CLIENT_ID=katRLEWCjSUQjTWsxDKgPkrD6cg4ys2O

# Auth0 API Audience (add this line)
REACT_APP_AUTH0_AUDIENCE=https://serverless-todo-api
```

2. **Update `client/src/index.js`**:

```javascript
const domain = process.env.REACT_APP_AUTH0_DOMAIN
const clientId = process.env.REACT_APP_AUTH0_CLIENT_ID
const audience = process.env.REACT_APP_AUTH0_AUDIENCE

ReactDOM.render(
  <Auth0Provider
    domain={domain}
    clientId={clientId}
    redirectUri={window.location.origin}
    audience={audience}
  >
    <App />
  </Auth0Provider>,
  document.getElementById('root')
)
```

3. **Update all components** (`Todos.jsx`, `NewTodoInput.jsx`, `EditTodo.jsx`):

Replace:
```javascript
const accessToken = await getAccessTokenSilently()
```

With:
```javascript
const accessToken = await getAccessTokenSilently({
  audience: process.env.REACT_APP_AUTH0_AUDIENCE
})
```

---

## Alternative: Use Simple Constant

If you don't want to use environment variables:

1. **Create a config file** `client/src/config.js`:

```javascript
export const authConfig = {
  domain: process.env.REACT_APP_AUTH0_DOMAIN,
  clientId: process.env.REACT_APP_AUTH0_CLIENT_ID,
  audience: 'https://serverless-todo-api',
  apiEndpoint: process.env.REACT_APP_API_ENDPOINT
}
```

2. **Update components to import and use it**:

```javascript
import { authConfig } from '../config'

const accessToken = await getAccessTokenSilently({
  audience: authConfig.audience
})
```

---

## Why This Works

1. **Without audience**: Auth0 issues opaque tokens that can't be validated by custom code
2. **With audience**: Auth0 issues JWT tokens that contain claims and can be validated using JWKS

The Auth0 API identifier tells Auth0 to issue a JWT access token that your backend can validate.

---

## Quick Fix Commands

I can apply the fix for you automatically. Would you like me to:
1. Add the audience to `.env`
2. Update `index.js` 
3. Update all component files

Let me know and I'll make the changes!

