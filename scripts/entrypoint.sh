#!/bin/bash
set -e

echo "Running entrypoint script with image tag: $1"

# Simple example: detect language and create a Dockerfile dynamically (very basic)

if [ -f "package.json" ]; then
  echo "Detected Node.js project"
  cat > Dockerfile <<EOF
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "index.js"]
EOF

elif [ -f "requirements.txt" ]; then
  echo "Detected Python project"
  cat > Dockerfile <<EOF
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
EOF

else
  echo "Language not detected, using alpine base"
  cat > Dockerfile <<EOF
FROM alpine
CMD ["echo", "No Dockerfile generated"]
EOF
fi

echo "Building Docker image with tag: $1"
docker build -t my-image:$1 .

echo "Docker image built successfully!"
