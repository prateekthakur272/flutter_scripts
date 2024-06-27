# Use an official Nginx runtime as a parent image
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build files to nginx server
COPY ./build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run when starting the container
CMD ["nginx", "-g", "daemon off;"]
