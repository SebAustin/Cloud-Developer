# AWS Elastic Beanstalk Dashboard Screenshot Instructions

## Required Screenshot for Project Submission

You need to capture a screenshot of your AWS Elastic Beanstalk dashboard showing the deployed application.

### How to Access the EB Dashboard

1. **Open AWS Console:**
   - Go to https://console.aws.amazon.com/
   - Sign in with your AWS credentials

2. **Navigate to Elastic Beanstalk:**
   - In the AWS Console search bar, type "Elastic Beanstalk"
   - Click on "Elastic Beanstalk" service

3. **Select Your Application:**
   - You should see your application: **image-filter-microservice**
   - Click on the application name

4. **View Environment Details:**
   - Click on the environment: **image-filter-env**
   - This will show the environment dashboard

### What to Include in the Screenshot

Your screenshot should clearly show:

✅ **Application Name:** image-filter-microservice  
✅ **Environment Name:** image-filter-env  
✅ **Health Status:** Green (Healthy)  
✅ **Environment Status:** Ready or Running  
✅ **Environment URL:** image-filter-env.eba-qma49hh6.us-east-1.elasticbeanstalk.com  
✅ **Platform:** Node.js  
✅ **Recent Events:** Showing successful deployment

### How to Take the Screenshot

**On Mac:**
- Press `Command + Shift + 4` then press `Space` to capture a window
- Or use `Command + Shift + 3` to capture the full screen
- Or use the Screenshot app from Applications > Utilities

**On Windows:**
- Press `Windows + Shift + S` to use Snipping Tool
- Or press `PrtScn` to capture full screen
- Or use the Snipping Tool app

**On Linux:**
- Press `PrtScn` or use Screenshot utility
- Or use `gnome-screenshot` command

### Save the Screenshot

1. Save the screenshot as: `elastic_beanstalk_dashboard.png`
2. Place it in this directory: `deployment_screenshots/`
3. Ensure the image is clear and all text is readable

### Alternative: Using EB CLI

You can also use the EB CLI to open the console directly:

```bash
cd "project starter code"
eb console
```

This will automatically open your default browser to the EB environment dashboard.

## Verification

Before submitting, verify your screenshot shows:
- [ ] Application and environment names visible
- [ ] Health status is Green
- [ ] Environment URL is visible
- [ ] Platform shows Node.js
- [ ] Screenshot is clear and readable

## Deployment Information

**Environment URL:** http://image-filter-env.eba-qma49hh6.us-east-1.elasticbeanstalk.com

**Test Endpoint:**
```bash
curl -H "Authorization: Bearer udacity-cloud-dev-token" \
  "http://image-filter-env.eba-qma49hh6.us-east-1.elasticbeanstalk.com/filteredimage?image_url=https://upload.wikimedia.org/wikipedia/commons/b/bd/Golden_tabby_and_white_kitten_n01.jpg" \
  --output filtered_image.jpg
```

