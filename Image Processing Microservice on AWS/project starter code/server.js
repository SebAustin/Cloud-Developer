import express from 'express';
import bodyParser from 'body-parser';
import {filterImageFromURL, deleteLocalFiles} from './util/util.js';



  // Init the Express application
  const app = express();

  // Set the network port
  const port = process.env.PORT || 8082;
  
  // Use the body parser middleware for post requests
  app.use(bodyParser.json());

  // @TODO1 IMPLEMENT A RESTFUL ENDPOINT
  // GET /filteredimage?image_url={{URL}}
  // endpoint to filter an image from a public url.
  
  // Authentication middleware
  const requireAuth = (req, res, next) => {
    const authHeader = req.headers.authorization;
    const validToken = process.env.AUTH_TOKEN || 'udacity-cloud-dev-token';
    
    if (!authHeader) {
      return res.status(401).send({ error: 'Authorization header required' });
    }
    
    const token = authHeader.replace('Bearer ', '');
    if (token !== validToken) {
      return res.status(401).send({ error: 'Invalid authentication token' });
    }
    
    next();
  };

  app.get('/filteredimage', requireAuth, async (req, res) => {
    try {
      // 1. Validate the image_url query parameter
      const { image_url } = req.query;
      
      if (!image_url) {
        return res.status(400).send({ error: 'image_url query parameter is required' });
      }
      
      // Validate URL format
      let url;
      try {
        url = new URL(image_url);
        if (!url.protocol || (url.protocol !== 'http:' && url.protocol !== 'https:')) {
          return res.status(400).send({ error: 'Invalid URL: must be http or https' });
        }
      } catch (error) {
        return res.status(400).send({ error: 'Invalid URL format' });
      }
      
      // 2. Call filterImageFromURL to filter the image
      let filteredPath;
      try {
        filteredPath = await filterImageFromURL(image_url);
      } catch (error) {
        console.error('Error processing image:', error);
        return res.status(422).send({ 
          error: 'Unable to process image. Please ensure the URL points to a valid image file.' 
        });
      }
      
      // 3. Send the resulting file in the response
      res.sendFile(filteredPath, async (err) => {
        // 4. Delete files on the server after response is sent
        if (filteredPath) {
          try {
            await deleteLocalFiles([filteredPath]);
          } catch (cleanupError) {
            console.error('Error cleaning up files:', cleanupError);
          }
        }
        
        if (err) {
          console.error('Error sending file:', err);
          if (!res.headersSent) {
            return res.status(500).send({ error: 'Error sending filtered image' });
          }
        }
      });
      
    } catch (error) {
      console.error('Unexpected error:', error);
      return res.status(500).send({ error: 'Internal server error' });
    }
  });

  //! END @TODO1
  
  // Root Endpoint
  // Displays a simple message to the user
  app.get( "/", async (req, res) => {
    res.send("try GET /filteredimage?image_url={{}}")
  } );
  

  // Start the Server
  app.listen( port, () => {
      console.log( `server running http://localhost:${ port }` );
      console.log( `press CTRL+C to stop server` );
  } );
