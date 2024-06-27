#!/bin/bash

# Navigate to the Flutter project directory
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <flutter project path> "
    exit 1
fi
cd $1 || exit

# Print a message to indicate the script is starting
echo "Starting Flutter build process..."

# Clean the Flutter project
echo "Running flutter clean..."
flutter clean

# Get the Flutter dependencies
echo "Running flutter pub get..."
flutter pub get

# Build the Flutter project for web
echo "Running flutter build web..."
flutter build web

# Print a message to indicate the script has finished
echo "Flutter build process completed!"
