#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <flutter_web_build_dir> <docker_image_name>"
    exit 1
fi

FLUTTER_WEB_BUILD_DIR=$1
DOCKER_IMAGE_NAME=$2

# Generate Dockerfile content
cat > Dockerfile <<EOF
# Use an official Nginx runtime as a parent image
FROM nginx

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build files to nginx server
COPY $FLUTTER_WEB_BUILD_DIR /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run when starting the container
CMD ["nginx", "-g", "daemon off;"]
EOF

# Build Docker image
docker build -t "$DOCKER_IMAGE_NAME" .

echo "Created Docker image $DOCKER_IMAGE_NAME"
