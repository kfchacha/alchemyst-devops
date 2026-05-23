#!/bin/bash
set -e

echo "=== Setting up caller-vm ==="

# System deps
sudo apt update -y
sudo apt install -y curl unzip git nginx

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install iii CLI
curl -fsSL https://iii.dev/install.sh | bash
export PATH="$HOME/.iii/bin:$PATH"
echo 'export PATH="$HOME/.iii/bin:$PATH"' >> ~/.bashrc

# Copy worker files
mkdir -p ~/quickstart/workers/caller-worker/src
cp -r /tmp/caller-worker/* ~/quickstart/workers/caller-worker/

# Fix config.yaml paths and engine host
mkdir -p ~/quickstart
cat > ~/quickstart/config.yaml << 'CONF'
workers:
  - name: iii-observability
    config:
      enabled: true
      service_name: iii
      exporter: memory
      memory_max_spans: 10000
      metrics_enabled: true
      metrics_exporter: memory
      logs_enabled: true
      logs_exporter: memory
      logs_console_output: true
      sampling_ratio: 1.0
  - name: iii-queue
    config:
      adapter:
        name: builtin
  - name: iii-state
    config:
      adapter:
        name: kv
        config:
          store_method: file_based
          file_path: ./data/state_store.db
  - name: iii-http
    config:
      port: 3111
      host: 0.0.0.0
      default_timeout: 30000
      concurrency_request_limit: 1024
      cors:
        allowed_origins:
        - '*'
        allowed_methods:
        - GET
        - POST
        - PUT
        - DELETE
        - OPTIONS
  - name: caller-worker
    worker_path: /home/ubuntu/quickstart/workers/caller-worker
CONF

# Install worker deps
cd ~/quickstart/workers/caller-worker
npm install

echo "=== caller-vm setup complete ==="
