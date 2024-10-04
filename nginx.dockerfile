FROM nginx:alpine

# Install necessary packages
RUN apk add --no-cache nano \
    python3 \
    python3-dev \
    py3-pip \
    build-base \
    libressl-dev \
    musl-dev \
    libffi-dev \
    rust \
    cargo

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate the virtual environment and upgrade pip
RUN /opt/venv/bin/pip install --upgrade pip

# Install certbot-nginx in the virtual environment
RUN /opt/venv/bin/pip install certbot-nginx

# Create necessary directories
RUN mkdir /etc/letsencrypt

# Copy the nginx configuration file
COPY ./nginx/nginx.conf /etc/nginx/

# Prepare the HTML directory
RUN mkdir -p /var/www/html
RUN chown -R nginx:nginx /var/www/html

# Set the PATH to use the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

