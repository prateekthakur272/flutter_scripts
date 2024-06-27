#!/bin/bash

# Function to display a message separator
function print_separator {
    echo "---------------------------------------------"
}

# Function to unzip Flutter project
function unzip_flutter_project {
    local ZIP_FILE=$1
    local DEST_DIR=$2

    echo "Unzipping $ZIP_FILE to $DEST_DIR..."
    if ! unzip -q "$ZIP_FILE" -d "$DEST_DIR"; then
        echo "Failed to unzip $ZIP_FILE to $DEST_DIR"
        exit 1
    fi
    # Remove __MACOSX folder if it exists
    if [ -d "$DEST_DIR/__MACOSX" ]; then
        echo "Removing __MACOSX folder..."
        rm -rf "$DEST_DIR/__MACOSX"
    fi
    print_separator
}

# Function to build Flutter web application
function build_flutter_web {
    local FLUTTER_PROJECT_DIR=$1

    echo "Building Flutter web application..."
    echo "$FLUTTER_PROJECT_DIR"
    cd "$FLUTTER_PROJECT_DIR/web_proj" || exit
    if ! flutter clean; then
        echo "Failed to run 'flutter clean'"
        exit 1
    fi
    if ! flutter pub get; then
        echo "Failed to run 'flutter pub get'"
        exit 1
    fi
    if ! flutter build web; then
        echo "Failed to build Flutter web application"
        exit 1
    fi
    print_separator
}

# Function to create Docker image
function create_docker_image {
    local FLUTTER_WEB_BUILD_DIR=$1
    local DOCKER_IMAGE_NAME=$2

    echo "Creating Docker image $DOCKER_IMAGE_NAME..."
    cat > Dockerfile <<EOF
# Use an official Nginx runtime as a parent image
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build files to nginx server
COPY $FLUTTER_WEB_BUILD_DIR /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run when starting the container
CMD ["nginx", "-g", "daemon off;"]
EOF

    if ! docker build -t "$DOCKER_IMAGE_NAME" .; then
        echo "Failed to create Docker image $DOCKER_IMAGE_NAME"
        exit 1
    fi
    print_separator
}

# Function to run Docker container
function run_docker_container {
    local DOCKER_IMAGE_NAME=$1
    local HOST_PORT=$2

    echo "Running Docker container from image $DOCKER_IMAGE_NAME..."
    if ! docker run -d -p "$HOST_PORT":80 "$DOCKER_IMAGE_NAME"; then
        echo "Failed to run Docker container from image $DOCKER_IMAGE_NAME"
        exit 1
    fi
    print_separator

    echo "Access your Flutter web app at http://localhost:$HOST_PORT"
}

# Main script starts here

# Ensure correct number of arguments
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <zip_file_path> <destination_directory> <docker_image_name> <host_port>"
    exit 1
fi

ZIP_FILE=$1
DEST_DIR=$2
DOCKER_IMAGE_NAME=$3
HOST_PORT=$4

# Execute workflow
unzip_flutter_project "$ZIP_FILE" "$DEST_DIR" &&
build_flutter_web "$DEST_DIR" &&
create_docker_image "$DEST_DIR/build/web" "$DOCKER_IMAGE_NAME" &&
run_docker_container "$DOCKER_IMAGE_NAME" "$HOST_PORT"
