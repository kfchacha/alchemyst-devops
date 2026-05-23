#!/bin/bash
set -e

echo "=== Setting up inference-vm ==="

# System deps
sudo apt update -y
sudo apt install -y python3-pip python3-venv git curl

# Create venv
python3 -m venv ~/venv
source ~/venv/bin/activate

# Copy worker files
mkdir -p ~/quickstart/workers/inference-worker
cp -r /tmp/inference-worker/* ~/quickstart/workers/inference-worker/

# Install Python deps
pip install --upgrade pip
pip install -r ~/quickstart/workers/inference-worker/requirements.txt

echo "=== inference-vm setup complete ==="
