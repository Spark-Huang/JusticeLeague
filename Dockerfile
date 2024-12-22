# Dockerfile

# Use an official Python runtime as the base image
FROM python:3.12-slim

# Set environment variables to ensure output is not buffered
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV OPENAI_API_KEY="your_key"
ENV WORKSPACE_DIR="agent_workspace"

# Set the working directory inside the container
WORKDIR /app

# Copy only requirements first (for better caching)
COPY ./api/requirements.txt /app/requirements.txt

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copy the rest of the application code
COPY ./api /app

# Make the bootup script executable
RUN chmod +x bootup.sh

# Expose the application port
EXPOSE 8000

# Start the application
CMD ["./bootup.sh"]
