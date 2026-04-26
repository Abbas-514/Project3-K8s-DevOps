FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the custom configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy frontend static files
COPY index.html style.css script.js /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
