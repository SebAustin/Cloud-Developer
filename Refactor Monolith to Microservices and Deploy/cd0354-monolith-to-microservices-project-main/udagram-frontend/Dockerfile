### Build Stage
FROM node:18 AS ionic

## Install Ionic CLI globally
RUN npm install -g @ionic/cli

## Create app directory
WORKDIR /usr/src/app

## Install app dependencies
## A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm ci

## Bundle app source
COPY . .

## Build the Ionic app
RUN ionic build

### Run Stage
FROM nginx:alpine

## Copy built app from ionic stage to nginx
COPY --from=ionic /usr/src/app/www /usr/share/nginx/html
