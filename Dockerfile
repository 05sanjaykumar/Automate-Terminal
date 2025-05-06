# Use a lightweight base image
FROM alpine:latest

# Install necessary tools
RUN apk add --no-cache bash curl git openssh

# Set working directory
WORKDIR /app

# Copy your scripts into the container
COPY scripts/ ./scripts/

# Make scripts executable
RUN chmod +x ./scripts/*.sh

# Default command (can be overridden)
CMD ["bash"]
