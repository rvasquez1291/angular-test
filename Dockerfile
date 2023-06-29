# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:18 as builder
# Set the working directory
WORKDIR /app

USER root

# Add the source code to app
COPY package.json package-lock.json ./

# Install all the dependencies
RUN npm install

COPY . .

# Generate the build of the application
RUN npm run build -- --configuration production --output-path=/dist

# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:1.20

# TEST
USER root

COPY nginx.conf /etc/nginx/nginx.conf

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /dist /usr/share/nginx/html

# Expose port 8080
EXPOSE 8080

ENTRYPOINT ["nginx", "-g", "daemon off;"]
