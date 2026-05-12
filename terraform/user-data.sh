#!/bin/bash
# User data script for EC2 instance
# Installs Docker and runs the TaskFlow application

set -e

# Update system
yum update -y

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Create CloudWatch config
cat > /opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json << 'EOF'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/docker-app.log",
            "log_group_name": "/aws/ec2/taskflow",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/cloudwatch-config.json

# Pull and run the Docker image
docker pull ${docker_image}

docker run -d \
  --name taskflow \
  --restart unless-stopped \
  -p 80:80 \
  --health-cmd="wget --quiet --tries=1 --spider http://localhost/ || exit 1" \
  --health-interval=30s \
  --health-timeout=3s \
  --health-retries=3 \
  --log-driver=json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  ${docker_image}

# Wait for container to be healthy
timeout 60 bash -c 'until docker inspect --format="{{.State.Health.Status}}" taskflow | grep -q healthy; do sleep 2; done'

echo "TaskFlow application deployed successfully"
