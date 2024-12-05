#!/bin/bash

# Define the image names
UBUNTU_IMAGE="ubuntu-image"
JAVA_IMAGE="java-image"
PYTHON_IMAGE="python-image"

# Build the Docker images
echo "Building Ubuntu Docker image..."
docker build -t $UBUNTU_IMAGE ./ubuntu

echo "Building Java Docker image..."
docker build -t $JAVA_IMAGE ./java

echo "Building Python Docker image..."
docker build -t $PYTHON_IMAGE ./python

# Run Trivy scans for vulnerabilities
echo "Scanning Ubuntu image for vulnerabilities..."
trivy image $UBUNTU_IMAGE

echo "Scanning Java image for vulnerabilities..."
trivy image $JAVA_IMAGE

echo "Scanning Python image for vulnerabilities..."
trivy image $PYTHON_IMAGE

# Check the results and exit with an appropriate code
if [[ $(trivy image $UBUNTU_IMAGE | grep -i "vulnerabilities found") || $(trivy image $JAVA_IMAGE | grep -i "vulnerabilities found") || $(trivy image $PYTHON_IMAGE | grep -i "vulnerabilities found") ]]; then
  echo "Vulnerabilities found! Please review the scan results."
  exit 1
else
  echo "No vulnerabilities found. All images are clean."
  exit 0
fi
