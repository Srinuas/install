#!/bin/bash

# trivy_fix.sh - Simple script to fix Trivy no space error

echo "=== Trivy Fix Script ==="

# Create cache directory
sudo mkdir -p /var/lib/trivy
sudo chmod 777 /var/lib/trivy

# Set cache directory
export TRIVY_CACHE_DIR=/var/lib/trivy

echo "Cache directory set to: /var/lib/trivy"

# Run trivy scan
trivy image apimage

echo "Scan completed!"
