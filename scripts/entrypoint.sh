#!/bin/bash
set -e

TAG=$1

echo "🔍 Detecting project type..."

if [ -f "requirements.txt" ] && [ -f "main.py" ]; then
    echo "Python project detected"
    cat <<EOF > Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "main.py"]
EOF
else
    echo "Unknown project type. Exiting."
    exit 1
fi

echo "Building image: ghcr.io/${GITHUB_REPOSITORY_OWNER}/${GITHUB_REPOSITORY##*/}:${TAG}"
docker build -t ghcr.io/${GITHUB_REPOSITORY_OWNER}/${GITHUB_REPOSITORY##*/}:${TAG} .

echo "Logging in to GitHub Container Registry"
echo "${GITHUB_TOKEN}" | docker login ghcr.io -u "${GITHUB_ACTOR}" --password-stdin

echo "Pushing image..."
docker push ghcr.io/${GITHUB_REPOSITORY_OWNER}/${GITHUB_REPOSITORY##*/}:${TAG}